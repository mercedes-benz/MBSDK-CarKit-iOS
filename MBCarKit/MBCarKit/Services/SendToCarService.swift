//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit
import MBCommonKit

/// Result object for SendRoute requests
public enum SendRouteResult {
    case success
    case failure(SendRouteError)
}

public enum FetchSendToCarCapabilitiesResult {
    case success([SendToCarCapability])
    case failure(FetchSendToCarCapabilitiesError)
}

public enum SendRouteError: Error {
    /// no sendRoute capabilities are available or could be fetched
    case noCapabilitiesAvailable
    
    /// sending the route via the bluetooth provider failed. This error is only returned
    /// if no send via backend is available, otherwise it will fallback to sending via the backend
    /// instead.
    case sendViaBluetoothFailed(Error?)
    
    /// sending the route via the backend failed
    case sendViaBackendFailed(String?)
    
    /// there is no bluetooth connection available. This error is only returned
    /// if no send via backend is available, otherwise it will fallback to sending via the backend
    /// instead.
    case noBluetoothConnection

    case unknown
}

public enum FetchSendToCarCapabilitiesError: Error {
    /// Fetching capabilities from the backend services did fail
    case network(String?)
    
    case unknown
}

public typealias OnSendRouteCompletion = ((SendRouteResult) -> Void)
public typealias OnFetchSendToCarCapabilitiesCompletion = ((FetchSendToCarCapabilitiesResult) -> Void)

public protocol SendToCarFunctions {
    
    /// Fetch a list of capabilities of the vehicle from either the local cache or - if not
    /// available - from backend services.
    ///
    /// The local cache is updated if the capabililties were fetched from the backend. Cached capabilities will also implicitly and asynchronnously get updated on each method call.
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin from the car
    ///   - onCompletion: Callback with the result of fetchSendToCarCapabilities function
    func fetchSendToCarCapabilities(finOrVin: String, onCompletion: @escaping OnFetchSendToCarCapabilitiesCompletion)
    
    /// Send a route with waypoints to the vehicle.
    ///
    /// Depending on the available capabilities of the vehicle and the bluetooth connection
    /// one of the following mechanisms is used:
    /// * Sending the route via bluetooth and sending via backend as fallback
    /// * Sending the route via bluetooth only and failing otherwise
    /// * Sending the route via backend only and failing otherwise
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin from the car
    ///   - routeModel: route that will be send to the car
    ///   - onCompletion: callback with the result of sendRoute function
    func sendRoute(finOrVin: String, routeModel: SendToCarRouteModel, onCompletion: @escaping OnSendRouteCompletion)
}

/// Service to send notifications to the head unit
public class SendToCarService: SendToCarFunctions {
    
    // MARK: Types
    private enum SendToCarOptions {
        case bluetoothWithBackendFallback(SendToCarWaypointModel)
        case bluetoothOnly(SendToCarWaypointModel)
        case backend
        case notPossible(Error?)
        
        var title: String {
            switch self {
            case .bluetoothWithBackendFallback: return "bluetoothWithBackendFallback"
            case .bluetoothOnly: return "bluetoothOnly"
            case .backend: return "backend"
            case .notPossible: return "notPossible"
            }
        }
    }

    // MARK: Typealias
    internal typealias SendToCarCapabilityAPIResult = NetworkResult<APISendToCarCapabilitiesModel>
    
    
    // MARK: - SendToCarFunctions Implementations
    public func fetchSendToCarCapabilities(finOrVin: String, onCompletion: @escaping OnFetchSendToCarCapabilitiesCompletion) {
        
        if self.hasSendToCarCapabilityCache(finOrVin: finOrVin) {
            onCompletion(.success(DatabaseSendToCarService.item(with: finOrVin).capabilities))
            
            requestSendToCarCapabilitiesAndUpdateCache(finOrVin: finOrVin)
        } else {
            requestSendToCarCapabilitiesAndUpdateCache(finOrVin: finOrVin, onCompletion: onCompletion)
        }
    }
    
    private func requestSendToCarCapabilitiesAndUpdateCache(finOrVin: String, onCompletion: OnFetchSendToCarCapabilitiesCompletion? = nil) {
        CarKit.tokenProvider.requestToken { token in
            
            let router = BffCapabilitiesRouter.sendToCarV2(accessToken: token.accessToken,
                                                           vin: finOrVin)
            
            NetworkLayer.requestDecodable(router: router) { [weak self] (result: SendToCarCapabilityAPIResult) in
                
                switch result {
                case .failure(let error):
                    LOG.E(error.localizedDescription)
                    
                    onCompletion?(.failure(.network(ErrorHandler.handle(error: error).localizedDescription ?? "")))
                case .success(let apiSendToCarCapabilities):
                    guard let self = self else {
                        onCompletion?(.failure(.unknown))
                        return
                    }
                    
                    LOG.D(apiSendToCarCapabilities)
                    let sendToCarCapabilitiesModel = self.buildSendToCarCapabilitiesModel(apiSendToCarCapabilities: apiSendToCarCapabilities)
                    
                    // if capabilites havent changed no need to save to cache
                    if self.isRetrievedCapabilitiesEqualToCachedCapabilities(sendToCarCapabilitiesModel: sendToCarCapabilitiesModel, finOrVin: finOrVin) {
                        onCompletion?(.success(sendToCarCapabilitiesModel.capabilities))
                        return
                    }
                    
                    // Update cache and post notification if capabilities have changed
                    DatabaseSendToCarService.save(sendToCarModel: sendToCarCapabilitiesModel, finOrVin: finOrVin) {
                        NotificationCenter.default.post(name: NSNotification.Name.didChangeSendToCarCapabilities,
                                                        object: sendToCarCapabilitiesModel.capabilities)
                        onCompletion?(.success(sendToCarCapabilitiesModel.capabilities))
                    }
                }
            }
        }
    }

    public func sendRoute(finOrVin: String, routeModel: SendToCarRouteModel, onCompletion: @escaping OnSendRouteCompletion) {

        LOG.I("Sending route to the vehicle.\n  - finOrVin: \(finOrVin)\n  - routeModel: \(routeModel)")
        
        LOG.D("Assuring SendToCar capability cache for vin: \(finOrVin)")
        self.assureSendToCarCapabilityCache(
            finOrVin: finOrVin,
            onFailure: { error in
                LOG.E("Refreshing SendToCar capability cache failed. Aborting SendRoute request.")
                onCompletion(.failure(error))
            },
            onCompletion: { [weak self] wasRefreshed in
                LOG.D("Successfully assured SendToCar capability cache. Required refresh: \(wasRefreshed).  Continuing sending the route...")
                
                if let sendToCarOptions = self?.getSendToCarOptions(finOrVin: finOrVin, routeModel: routeModel) {
                    LOG.I("Available SendToCar option: \(sendToCarOptions.title)")
                    
                    self?.sendRoute(for: sendToCarOptions, finOrVin: finOrVin, routeModel: routeModel, onCompletion: onCompletion)
                } else {
                    LOG.E("Could not determine sendToCarOptions. Aborting SendRoute request.")
                    onCompletion(.failure(.unknown))
                }
            }
        )
    }
    
    // MARK: - Private Interface
    private func isRetrievedCapabilitiesEqualToCachedCapabilities(sendToCarCapabilitiesModel: SendToCarCapabilitiesModel, finOrVin: String) -> Bool {
        guard self.hasSendToCarCapabilityCache(finOrVin: finOrVin) else {
            return false
        }
        
        let cacheCapabilites = DatabaseSendToCarService.item(with: finOrVin).capabilities
        let cacheCapabilitesSet = Set(cacheCapabilites)
        let backendCapabilitesSet = Set(sendToCarCapabilitiesModel.capabilities)
        
        return cacheCapabilitesSet == backendCapabilitesSet
    }
    
    private func buildSendToCarCapabilitiesModel(apiSendToCarCapabilities: APISendToCarCapabilitiesModel) -> SendToCarCapabilitiesModel {
        if CarKit.bluetoothProvider != nil {
            return SendToCarCapabilitiesModel(capabilities: apiSendToCarCapabilities.capabilities)
        } else {
            // if BT is an available capability, but the BT provider is not set, remove the BT capability
            return SendToCarCapabilitiesModel(capabilities: apiSendToCarCapabilities.capabilities.filter { $0 != SendToCarCapability.singlePoiBluetooth })
        }
    }
    
    private func sendRoute(for sendToCarOptions: SendToCarService.SendToCarOptions, finOrVin: String, routeModel: SendToCarRouteModel, onCompletion: @escaping OnSendRouteCompletion) {
        
        switch sendToCarOptions {
        case .bluetoothOnly(let poi):
            LOG.D("Check bluetooth connection..")
            
            if self.isBluetoothConnectionAvailable(for: finOrVin) {

                self.sendPoiViaBluetooth(poi: poi,
                                          finOrVin: finOrVin,
                                          allowedQueuing: true,
                                          onCompletion: onCompletion)

            } else {
                LOG.E("Bluetooth connection could not be established. Bluetooth is only capability. Add POI to cache")
                self.sendPoiViaBluetooth(poi: poi,
                                          finOrVin: finOrVin,
                                          allowedQueuing: true,
                                          onCompletion: onCompletion)
            }
            
        case .bluetoothWithBackendFallback(let poi):
            LOG.D("Check bluetooth connection..")
            
            if self.isBluetoothConnectionAvailable(for: finOrVin) {
                
                let bluetoothFailedFallback: (() -> Void) = {
                    LOG.D("Sending POI via Bluetooth failed. Using sendToCar via Backend as fallback.")
                    self.sendRouteToBackend(finOrVin: finOrVin,
                                            routeModel: routeModel,
                                            onCompletion: onCompletion)
                }
                
                self.sendPoiViaBluetooth(poi: poi,
                                         finOrVin: finOrVin,
                                         allowedQueuing: false,
                                         fallback: bluetoothFailedFallback,
                                         onCompletion: onCompletion)
            } else {
                LOG.E("Bluetooth connection did fail. Using sendToCar via Backend as fallback.")
                self.sendRouteToBackend(finOrVin: finOrVin,
                                        routeModel: routeModel,
                                        onCompletion: onCompletion)
            }
            
            
        case .backend:
            LOG.D("Sending route via Backend.")
			self.sendRouteToBackend(finOrVin: finOrVin,
									routeModel: routeModel,
									onCompletion: onCompletion)
            
        case .notPossible(let error):
            LOG.E("SendToCar is currently not possible: \(error?.localizedDescription ?? "<unkown>"). Aborting SendRoute.")
            onCompletion(.failure(.unknown))
        }
    }
    
    private func isBluetoothConnectionAvailable(for finOrVin: String) -> Bool {
        
        guard CarKit.bluetoothProvider?.connectionStatus != .connected && CarKit.bluetoothProvider?.connectedFinOrVin == finOrVin else {
            LOG.D("Bluetooth connection available")
            return true
        }
        LOG.D("No Bluetooth connection available")
        
        return false
    }
    
    private func assureSendToCarCapabilityCache(finOrVin: String, onFailure: @escaping ((SendRouteError) -> Void), onCompletion: @escaping ((Bool) -> Void)) {
		
		guard self.hasSendToCarCapabilityCache(finOrVin: finOrVin) == false else {
            onCompletion(false)
            return
        }
        
		self.fetchSendToCarCapabilities(finOrVin: finOrVin) { result in
            switch result {
            case .success(let capabilities):
                guard capabilities.isEmpty == false else {
                    onFailure(.noCapabilitiesAvailable)
                    return
                }
                onCompletion(true)
				
            case .failure:
                onFailure(.noCapabilitiesAvailable)
            }
        }
    }
    
    private func sendPoiViaBluetooth<T: BluetoothPoiMappable>(poi: T, finOrVin: String, allowedQueuing: Bool, fallback: (() -> Void)? = nil, onCompletion: @escaping OnSendRouteCompletion) {
		
		self.track(finOrVin: finOrVin,
				   routeType: .singlePoiBluetooth,
				   state: .enqueued)
        
        CarKit.bluetoothProvider?.send(poi: poi, to: finOrVin, allowedQueuing: allowedQueuing) { result in
            
			switch result {
			case .failure(let error):
				self.track(finOrVin: finOrVin,
						   routeType: .singlePoiBluetooth,
						   state: .failed)
				
				if let fallback = fallback {
                    fallback()
                } else {
                    onCompletion(.failure(.sendViaBluetoothFailed(error)))
                }
				
			case .success:
				self.track(finOrVin: finOrVin,
						   routeType: .singlePoiBluetooth,
						   state: .finished)
				
                onCompletion(.success)
            }
        }
    }
    
    private func getSendToCarOptions(finOrVin: String, routeModel: SendToCarRouteModel) -> SendToCarOptions {
		
        guard let poi = routeModel.waypoints.first else {
            return .notPossible(nil)
        }
        
        let capabilities = DatabaseSendToCarService.item(with: finOrVin).capabilities
        
		guard self.doesSupportBluetooth(finOrVin: finOrVin, routeModel: routeModel, capabilities: capabilities) else {
            return .backend
        }
        
        if capabilities.count == 1 { // make sure ONLY singlePoiBluetooth is available, nothing else
            return .bluetoothOnly(poi)
        }
        
        return .bluetoothWithBackendFallback(poi)
    }
    
    private func hasSendToCarCapabilityCache(finOrVin: String) -> Bool {
        return DatabaseSendToCarService.item(with: finOrVin).capabilities.isEmpty == false
    }
    
    private func doesSupportBluetooth(finOrVin: String, routeModel: SendToCarRouteModel, capabilities: [SendToCarCapability]) -> Bool {
        return CarKit.bluetoothProvider != nil &&
                routeModel.routeType == .singlePOI &&
                capabilities.contains(SendToCarCapability.singlePoiBluetooth)
    }

    private func sendRouteToBackend(finOrVin: String, routeModel: SendToCarRouteModel, onCompletion: @escaping OnSendRouteCompletion) {
        
        CarKit.tokenProvider.requestToken { token in
            
            let json   = try? routeModel.toJson()
            let router = BffVehicleRouter.route(accessToken: token.accessToken,
												vin: finOrVin,
												requestModel: json as? [String: Any])
			
			self.track(finOrVin: finOrVin, routeType: routeModel.routeType, state: .initiation)
            
            NetworkLayer.requestData(router: router) { (result) in
                
                switch result {
                case .failure(let error):
                    LOG.E("Sending route via Backend failed: \(error.localizedDescription)")
					self.track(finOrVin: finOrVin, routeType: routeModel.routeType, state: .finished)
					
                    onCompletion(.failure(.sendViaBackendFailed(ErrorHandler.handle(error: error).localizedDescription ?? "")))
                    
                case .success:
                    LOG.D("Successfully send poi or route via Backend")
					self.track(finOrVin: finOrVin, routeType: routeModel.routeType, state: .finished)

                    onCompletion(.success)
                }
            }
        }
    }
	
	private func track(finOrVin: String, routeType: HuCapability, state: CommandState) {
		
		let event = MyCarTrackingEvent.sendToCar(fin: finOrVin,
												 routeType: routeType,
												 state: state,
												 condition: "")
		self.track(event: event)
	}
	
	private func track(finOrVin: String, routeType: SendToCarCapability, state: CommandState) {
		
		let event = MyCarTrackingEvent.sendToCarBluetooth(fin: finOrVin,
														  routeType: routeType,
														  state: state,
														  condition: "")
		self.track(event: event)
	}
	
	private func track(event: MyCarTrackingEvent) {
		MBTrackingManager.track(event: event)
	}
}

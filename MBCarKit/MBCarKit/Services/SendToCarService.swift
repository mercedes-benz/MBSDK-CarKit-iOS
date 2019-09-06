//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBNetworkKit
import MBCommonKit

/// Service to send notifications to the head unit
public class SendToCarService {
	
	// MARK: Typealias
	
	/// Completion for capabilities of the head unit
	///
	/// Returns array of HuCapability
	public typealias CapabilityResult = ([HuCapability]) -> Void
	
	internal typealias CapabilityAPIResult = NetworkResult<APIHuCapabilityModel>


	// MARK: - Public

	/// Fetch a list of capabilities of the vehicle
	///
	/// - Parameters:
	///   - fin or vin from the car
	///   - onSuccess: Closure with array of HuCapability
	///   - onError: Error closure with error message string
	public func capabilities(finOrVin: String, onSuccess: @escaping CapabilityResult, onError: @escaping MBCarKit.ErrorDescription) {

		let caps: [HuCapability] = {
			guard MBCarKit.bluetoothProvider != nil else {
				return []
			}
			return [.singlePOI]
		}()

		self.rifCapabilities(finOrVin: finOrVin, onSuccess: { (capabilities) in
			
			let newCaps = Array(Set(caps + capabilities))
			onSuccess(newCaps)
		}, onError: { (error) in
			
			if caps.count > 0 {
				onSuccess(caps)
			}
			onError(error)
		})

	}
	
	/// Send a route with waypoints to the head unit
	///
	/// - Parameters:
	///   - finOrVin: fin or vin from the car
	///   - routeModel: SendToCarRouteModel with type of the route and waypoints
	///   - onSuccess: Closure for succeded sending
	///   - onError: Error closure with error message string
	public func route(finOrVin: String, routeModel: SendToCarRouteModel, onSuccess: @escaping () -> Void, onError: @escaping MBCarKit.ErrorDescription) {

		// Bluetoooth connection available
		if MBCarKit.bluetoothProvider?.isConnected == true,
			routeModel.routeType == .singlePOI,
			let poi = routeModel.waypoints.first {

			MBCarKit.bluetoothProvider?.send(poi: poi, allowedCache: false, onComplete: { [weak self] success in
				
				if success {
					onSuccess()
				} else {
					self?.sendRouteToBackend(finOrVin: finOrVin, routeModel: routeModel, onSuccess: onSuccess, onError: onError)
				}
			})
		} else {
			// Fallback to backend solution
			self.sendRouteToBackend(finOrVin: finOrVin, routeModel: routeModel, onSuccess: onSuccess, onError: onError)
		}
	}


	// MARK: - Private Interface

	private func rifCapabilities(finOrVin: String, onSuccess: @escaping CapabilityResult, onError: @escaping MBCarKit.ErrorDescription) {
		
		MBCarKit.tokenProvider.requestToken { token in

			let router = BffEndpointRouter.sendToCarCapability(accessToken: token.accessToken,
															   vin: finOrVin)
			NetworkLayer.requestDecodable(router: router) { (result: CapabilityAPIResult) in

				switch result {
				case .failure(let error):
					LOG.E(error.localizedDescription)

					let handleError   = NetworkLayer.handle(error: error, type: APIErrorDescriptionModel.self)
					let responseError = NetworkLayer.responseError(networkError: handleError.responseError?.networkError, model: handleError.errorModel?.description)
					onError(responseError.requestError ?? responseError.localizedDescription ?? "")

				case .success(let apiHuCapability):
					LOG.D(apiHuCapability)
					onSuccess(apiHuCapability.capabilities)
				}
			}
		}
	}

	private func sendRouteToBackend(finOrVin: String, routeModel: SendToCarRouteModel, onSuccess: @escaping () -> Void, onError: @escaping MBCarKit.ErrorDescription) {
		
		MBCarKit.tokenProvider.requestToken { token in

			let json   = try? routeModel.toJson()
			let router = BffEndpointRouter.sendToCarRoute(accessToken: token.accessToken,
														  vin: finOrVin,
														  requestModel: json as? [String: Any])

			MBTrackingManager.track(event: MyCarTrackingEvent.sendToCar(fin: finOrVin,
																		routeType: routeModel.routeType,
																		state: .created,
																		condition: .none))

			NetworkLayer.requestData(router: router) { (result) in

				switch result {
				case .failure(let error):
					LOG.E(error.localizedDescription)
					MBTrackingManager.track(event: MyCarTrackingEvent.sendToCar(fin: finOrVin,
																				routeType: routeModel.routeType,
																				state: .finished,
																				condition: .failed))

					let handleError   = NetworkLayer.handle(error: error, type: [APIErrorHuModel].self)
					let responseError = NetworkLayer.responseError(networkError: handleError.responseError?.networkError, model: handleError.errorModel?.first?.description)
					onError(responseError.requestError ?? responseError.localizedDescription ?? "")

				case .success:
					MBTrackingManager.track(event: MyCarTrackingEvent.sendToCar(fin: finOrVin,
																				routeType: routeModel.routeType,
																				state: .finished,
																				condition: .success))
					onSuccess()
				}
			}
		}
	}
}

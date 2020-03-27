//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

/// Service to call all vehicle data related requests
public class VehicleService {
	
	// MARK: Typealias
	
    public typealias AutomaticValetParkingCompletion = (EmptyResult) -> Void
    
	/// Completion for command capabilities
	public typealias CommandCapabilitiesResult = (Result<CommandCapabilitiesModel, MBError>) -> Void
	
	/// Completion for vehicle consumption
	public typealias ConsumptionResult = (Result<ConsumptionModel, MBError>) -> Void
	
	/// Completion to reset the damage detection
    public typealias DamageDetectionCompletion = (EmptyResult) -> Void
	
	/// Completion for vehicle data
	///
	/// Returns array of VehicleModel
    public typealias VehiclesCompletion = (Result<[VehicleModel], MBError>) -> Void
	
	/// Empty completion for vehicle data
    public typealias VehicleUpdateCompletion = (EmptyResult) -> Void
    
    /// Empty completion for removing Subuser
    public typealias RemoveUserAuthorizationCompletion = (EmptyResult) -> Void
    
    /// Empty completion for setting the profile sync
    public typealias SetProfileSyncCompletion = (EmptyResult) -> Void
    
    /// Completion for get pin sync statue
    public typealias PinSyncStatusCompletion = (Result<PinSyncStatus, MBError>) -> Void
    
    /// Empty completion for upgrading the temporary user
    public typealias UpgradeTemporaryUserCompletion = (EmptyResult) -> Void
    
	/// Empty completion for vehicle assigned user
	public typealias VehicleAssignedUserSucceeded = (Result<VehicleUserManagementModel, MBError>) -> Void
	typealias VehicleUserManagementResult = NetworkResult<APIVehicleUserManagementModel>

	typealias CommandCapabilitiesAPIResult = NetworkResult<[APICommandCapabilityModel]>
	typealias ConsumptionAPIResult = NetworkResult<APIVehicleConsumptionModel>

	typealias VehiclesAPIResult = NetworkResult<[APIVehicleDataModel]>
	typealias VehicleSelectionUpdate = (String) -> Void

	/// Completion for subuser qr-code invitation
	///
	/// Returns an image data object
	public typealias VehicleQrCodeInvitationCompletion = (Result<Data, MBError>) -> Void
	
	// MARK: - Public
	
	/// Gets an acceptance from the user and verifies whether to go ahead with the automatic valet parking drive or not
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - requestModel: AcceptAVPDriveModel
    ///   - completion: Closure with enum-based EmptyResult
	public func automaticValetParking(finOrVin: String, requestModel: AcceptAVPDriveModel, completion: @escaping AutomaticValetParkingCompletion) {
		
		CarKit.tokenProvider.requestToken { (token) in
			
			let json        = try? requestModel.toJson()
			let requestDict = json as? [String: Any]
			let router      = BffVehicleRouter.automaticValetParking(accessToken: token.accessToken,
																	 vin: finOrVin,
																	 requestModel: requestDict)
			self.request(router: router, completion: completion)
		}
	}
	
	/// Fetch the assigned users with basic information (Owner, Subuser)
	///
	/// - Parameters:
	///   - finOrVin: fin or vin of the vehicle
	///   - completion: Closure with consumption data of the vehicle
	public func fetchVehicleAssignedUsers(finOrVin: String, completion: @escaping VehicleAssignedUserSucceeded) {

		NetworkUserManagementService.fetchVehicleAssignedUsers(finOrVin: finOrVin) { (result) in

			switch result {
			case .failure(let error):
				LOG.E(error.localizedDescription)

				if let mgmt = DatabaseUserManagementService.item(with: finOrVin) {
					completion(.success(mgmt))
					return
				}

				completion(.failure(error))

			case .success(let apiVehicleUserManagement):
				LOG.D(apiVehicleUserManagement)

				let model = NetworkModelMapper.map(apiVehicleUserManagement: apiVehicleUserManagement, finOrVin: finOrVin)
				DatabaseUserManagementService.save(vehicleUserManagement: model) {
					completion(.success(model))
				}
			}
		}
	}

    /// Fetch invitation qr code for vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - profileId: profile id of the vehicle
    ///   - completion: Closure with data of the qr code
	public func qrCodeInviteForVehicle(finOrVin: String, profileId: VehicleProfileID, completion: @escaping VehicleQrCodeInvitationCompletion) {
		NetworkUserManagementService.fetchInvitationQrCode(finOrVin: finOrVin, profileId: profileId, completion: completion)
	}

	/// Fetch the command capabilities of the vehicle
	///
	/// - Parameters:
	///   - finOrVin: fin or vin of the vehicle
	///   - completion: Closure with a array of command capabilities of the vehcile
	public func fetchCommandCapabilities(finOrVin: String, completion: @escaping CommandCapabilitiesResult) {
		
		CarKit.tokenProvider.requestToken { (token) in
			
			let router = BffCapabilitiesRouter.commands(accessToken: token.accessToken,
														vin: finOrVin)
			NetworkLayer.requestDecodable(router: router, keyPath: "commands") { (result: CommandCapabilitiesAPIResult) in
				
				switch result {
				case .failure(let error):
					LOG.E(error.localizedDescription)
					
                    completion(.failure(ErrorHandler.handle(error: error)))
					
				case .success(let apiCommandCapabilities):
					LOG.D(apiCommandCapabilities)
					
					let commandCapabilitiesModel = NetworkModelMapper.map(apiCommandCapabilityModels: apiCommandCapabilities,
																		  finOrVin: finOrVin)
					DatabaseCommandCapabilitiesService.save(commandCapabilitiesModel: commandCapabilitiesModel, finOrVin: finOrVin) {
						completion(.success(commandCapabilitiesModel))
					}
				}
			}
		}
	}
	
	/// Fetch the consumption history and information about the vehicle and the model (Baumuster)
	///
	/// - Parameters:
	///   - finOrVin: fin or vin of the vehicle
	///   - completion: Closure with consumption data of the vehicle
	public func fetchConsumption(finOrVin: String, completion: @escaping ConsumptionResult) {
		
		CarKit.tokenProvider.requestToken { token in
			
			let router = BffVehicleRouter.consumption(accessToken: token.accessToken,
													  vin: finOrVin)
			
			NetworkLayer.requestDecodable(router: router) { (result: ConsumptionAPIResult) in
				
				switch result {
				case .failure(let error):
					LOG.E(error.localizedDescription)
					
					completion(.failure(ErrorHandler.handle(error: error)))
					
				case .success(let apiVehicleConsumption):
					LOG.D(apiVehicleConsumption)
					
					let model = NetworkModelMapper.map(apiVehicleConsumptionModel: apiVehicleConsumption)
					completion(.success(model))
				}
			}
		}
	}
	
	/// Fetch the vehicle data and update the cache immediately
	///
	/// - Parameters:
	///   - completion: Optional closure with vehicle data
	public func fetchVehicles(completion: VehiclesCompletion? = nil) {
		self.fetchVehicles(returnError: true,
						   completion: completion,
						   needsVehicleSelectionUpdate: nil)
	}
	
	/// Fetch the vehicle data at and select the first vehicle in data set
	///
	/// - Parameters:
	///   - completion: Closure with optional vehicle identifier
	public func instantSelectVehicle(completion: @escaping (String?) -> Void) {
		        
		self.fetchVehicles { [weak self] (result) in
			
            switch result {
            case .success(let vehicles):
                
                guard let finOrVin = self?.handleInstantVehicleSelection(vehicles: vehicles) else {
                    completion(nil)
                    return
                }
                
                DatabaseService.update(finOrVin: finOrVin) {
                    
                    completion(finOrVin)
                    CarKit.sharedVehicleSelection = nil
                }
                
            case .failure:
                completion(nil)
            }
		}
	}
	
    /// Removes the Subuser from the vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - authorizationID: Authorization id from the user to remove
    ///   - completion: Closure with enum-based EmptyResult
    public func removeUserAuthorization(finOrVin: String, authorizationID: String, completion: @escaping RemoveUserAuthorizationCompletion) {
        
        NetworkUserManagementService.removeUserAuthorization(finOrVin: finOrVin, authorizationID: authorizationID) { (result) in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
                
            case .success:
                DatabaseUserManagementService.deleteSubuser(with: authorizationID, from: finOrVin, completion: {
                    completion(.success)
                })
            }
        }
    }
    
	/// Reset damage detection for a vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - completion: Closure
	public func resetDamageDetection(finOrVin: String, completion: @escaping DamageDetectionCompletion) {
		
		CarKit.tokenProvider.requestToken { (token) in
			
			let router = BffVehicleRouter.resetDamageDetection(accessToken: token.accessToken,
															   vin: finOrVin)
			self.request(router: router, completion: completion)
		}
	}
    
    /// Set the profile sync of the vehicle
    ///
    /// - Parameters:
    ///   - enabled: Bool if the profile sync should be enabled or disabled
    ///   - finOrVin: fin or vin of the vehicle
    ///   - completion: Closure with enum-based EmptyResult
    public func setProfileSync(enabled: Bool, finOrVin: String, completion: @escaping SetProfileSyncCompletion) {
        
        NetworkUserManagementService.setProfileSync(enabled: enabled, finOrVin: finOrVin) { (result) in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
                
            case .success:
                let status: VehicleProfileSyncStatus = enabled ? .on : .off
                DatabaseUserManagementService.updateProfileSync(status: status, from: finOrVin, completion: {
                    completion(.success)
                })
            }
        }
    }
    
    /// Get the sync state of pin for vehicle
    ///
    /// - Parameters:
    /// - finOrVin: The fin or vin of the vehicle
    /// - completion: Closure with pin status enum
    public func getPinSyncState(finOrVin: String, completion: @escaping PinSyncStatusCompletion) {
        
        CarKit.tokenProvider.requestToken { token in
            
            let router = BffUserManagementRouter.syncState(accessToken: token.accessToken, vin: finOrVin)
            
            NetworkLayer.requestDecodable(router: router) { (result: NetworkResult<APIPinSyncState>) in
                
                switch result {
                case .failure(let error):
                    LOG.E(error.localizedDescription)
                    completion(.failure(ErrorHandler.handle(error: error)))
                    
                case .success(let state):
                    completion(.success(state.status))
                }
            }
        }
    }
	
	/// Update the license plate of a given vehicle
	///
	/// - Parameters:
	///   - finOrVin: The fin or Vin of the car
    ///   - completion: Closure with enum-based EmptyResult
	public func updateLicense(finOrVin: String, licensePlate: String, completion: @escaping VehicleUpdateCompletion) {

        CarKit.tokenProvider.requestToken { token in

            let router = BffVehicleRouter.licensePlate(accessToken: token.accessToken,
													   vin: finOrVin,
													   locale: CarKit.localeIdentifier,
													   license: licensePlate)

			NetworkLayer.requestData(router: router) { (result) in
				
				switch result {
				case .failure(let error):
					completion(.failure(ErrorHandler.handle(error: error)))
					
				case .success(let value):
					LOG.D(value)
					
					DatabaseVehicleService.update(licensePlate: licensePlate, for: finOrVin, completion: nil)
					completion(.success)
				}
			}
        }
	}
	
	/// Update the preferred dealers of a given vehicle
	///
	/// - Parameters:
	///   - finOrVin: The fin or Vin of the car
    ///   - completion: Closure with enum-based EmptyResult
	public func updatePreferredDealer(finOrVin: String, preferredDealers: [VehicleDealerUpdateModel], completion: @escaping VehicleUpdateCompletion) {
		
		CarKit.tokenProvider.requestToken { token in
			
			let apiModels = NetworkModelMapper.map(dealerUpdateModels: preferredDealers)
			let json      = try? apiModels.toJson()
			let router    = BffVehicleRouter.dealersPreferred(accessToken: token.accessToken,
															  vin: finOrVin,
															  requestModel: json as? [[String: Any]])
			self.request(router: router, completion: completion)
		}
	}
    
	/// Upgrades the temporary user to a sub user
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - authorizationID: Authorization id from the user to remove
    ///   - completion: Closure with enum-based EmptyResult
    public func upgradeTemporaryUser(authorizationID: String, finOrVin: String, completion: @escaping UpgradeTemporaryUserCompletion) {
        
        NetworkUserManagementService.upgradeTemporaryUser(authorizationID: authorizationID, finOrVin: finOrVin) { (result) in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
                
            case .success:
                DatabaseUserManagementService.deleteSubuser(with: authorizationID, from: finOrVin, completion: {
                    completion(.success)
                })
            }
        }
    }
	
    
	// MARK: - Internal
	
	func fetchVehicles(completion: @escaping VehicleUpdateCompletion, needsVehicleSelectionUpdate: @escaping VehicleSelectionUpdate) {

		self.fetchVehicles(returnError: false, completion: { (_) in
            completion(.success)
		}, needsVehicleSelectionUpdate: needsVehicleSelectionUpdate)
	}
	
	
	// MARK: - Helper
	
	private func fetchVehicles(returnError: Bool, completion: VehiclesCompletion?, needsVehicleSelectionUpdate: VehicleSelectionUpdate?) {
		
		CarKit.tokenProvider.requestToken { token in
			
			let router = BffVehicleRouter.masterdata(accessToken: token.accessToken,
													 countryCode: CarKit.countryCode,
													 locale: CarKit.localeIdentifier)
			
			NetworkLayer.requestDecodable(router: router) { [weak self] (result: VehiclesAPIResult) in
				
				switch result {
				case .failure(let error):
					LOG.E(error.localizedDescription)
					
					if returnError {
                        completion?(.success(DatabaseVehicleService.fetch()))
                    }
					
				case .success(let apiVehicleDataModels):
					LOG.D(apiVehicleDataModels)
					
					self?.handle(apiVehicleDataModels: apiVehicleDataModels, completion: completion, needsVehicleSelectionUpdate: { (selectedVin) in
						needsVehicleSelectionUpdate?(selectedVin)
					})
				}
			}
		}
	}

	private func handle(apiVehicleDataModels: [APIVehicleDataModel], completion: VehiclesCompletion?, needsVehicleSelectionUpdate: @escaping VehicleSelectionUpdate) {
		
		let vehicles = NetworkModelMapper.map(apiVehicleDataModels: apiVehicleDataModels)
		DatabaseVehicleService.save(vehicleModels: vehicles, completion: {
			
            completion?(.success(vehicles))
			
			if vehicles.isEmpty {
				DatabaseVehicleSelectionService.delete(completion: nil)
			}
		}, needsVehicleSelectionUpdate: { (preAssignedVin) in
			
			let newSelectedVin: String? = {
                
                // If there is a pre assign vehicle, set it to selected
                if let preAssignedVin = preAssignedVin {
                    return preAssignedVin
                } else {
                    
                    // If the selected vin isn't empty return it, if its empty use the vin from the first vehicle
                    if CarKit.selectedFinOrVin?.isEmpty == false {
						return CarKit.selectedFinOrVin
					}
					return vehicles.first?.finOrVin
                }
			}()
			
			guard let selectedVin = newSelectedVin else {
				return
			}
			
			LOG.D("change vin selection: \(selectedVin)")
			needsVehicleSelectionUpdate(selectedVin)
		})
	}
	
	private func handleInstantVehicleSelection(vehicles: [VehicleModel]) -> String? {
		
		let firstIndex = vehicles.firstIndex(where: { (vehicle) -> Bool in
			return (vehicle.trustLevel > 1 && vehicle.pending == nil) ||
                (vehicle.trustLevel == 1 && vehicle.vehicleConnectivity?.isLegacy == true)
		})
		
		guard let index = firstIndex else {
			return nil
		}
		
		let selectedVin: String = CarKit.sharedVehicleSelection ?? CarKit.selectedFinOrVin ?? ""
		let filterFinOrVin = vehicles.first(where: { $0.finOrVin == selectedVin })?.finOrVin
		return filterFinOrVin ?? vehicles.item(at: index)?.finOrVin
	}
	
	private func request(router: BffVehicleRouter, completion: @escaping (EmptyResult) -> Void) {
		
		NetworkLayer.requestData(router: router) { (result) in
			
			switch result {
			case .failure(let error):
				LOG.E(error.localizedDescription)
				completion(.failure(ErrorHandler.handle(error: error)))
				
			case .success:
				LOG.D()
				completion(.success)
			}
		}
	}
}

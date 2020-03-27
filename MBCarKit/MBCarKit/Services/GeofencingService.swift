//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

public class GeofencingService: NSObject {
    
    // MARK: Typealias
    
    /// Completion for geofences
    public typealias GeofencesResult = (Result<[GeofenceModel], MBError>) -> Void
    
    /// Completion for geofence
    public typealias GeofenceResult = (Result<GeofenceModel, MBError>) -> Void
    
    /// Empty completion for create geofence data
    public typealias CreateGeofenceResult = (EmptyResult) -> Void
    
    /// Empty completion for update geofence data
    public typealias UpdateGeofenceResult = (EmptyResult) -> Void
    
    /// Empty completion for delete geofence data
    public typealias DeleteGeofenceResult = (EmptyResult) -> Void
    
    
    typealias GeofencesAPIResult = NetworkResult<[APIGeofence]>
    typealias GeofenceAPIResult = NetworkResult<APIGeofence>
    
    // MARK: - Public
    
    /// Get all the geofences that are associated with the user
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - completion: Closure with geofences data of the user
    public func fetchGeofences(finOrVin: String, completion: @escaping GeofencesResult) {
        
        CarKit.tokenProvider.requestToken { token in
            
            let router = BffGeofencingRouter.getGeofences(accessToken: token.accessToken,
														  finOrVin: finOrVin)
            NetworkLayer.requestDecodable(router: router) { (result: GeofencesAPIResult) in
                
                switch result {
                case .failure(let error):
                    completion(.failure(ErrorHandler.handle(error: error)))
                    
                case .success(let apiGeofence):
                    let model = NetworkModelMapper.map(apiGeofenceModels: apiGeofence)
                    completion(.success(model))
                }
            }
        }
    }
    
    /// Create a new geofence for the user
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - geofence: the model data of the geofence
    ///   - completion: Closure with CreateGeofenceResult
    public func createGeofence(finOrVin: String, geofence: GeofenceModel, completion: @escaping CreateGeofenceResult) {
        
        CarKit.tokenProvider.requestToken { token in
            
            let bodyDictParams = geofence.params()
            let router = BffGeofencingRouter.createGeofence(accessToken: token.accessToken,
															finOrVin: finOrVin,
															requestModel: bodyDictParams)
			self.request(router: router, completion: completion)
        }
    }
	
    /// Get one specific geofence by id
    ///
    /// - Parameters:
    ///   - id: id of the geofence to fetch
    ///   - completion: Closure with geofence data of the user
    public func fetchGeofence(id: Int, completion: @escaping GeofenceResult) {
        
        CarKit.tokenProvider.requestToken { token in
            
            let router = BffGeofencingRouter.getGeofence(accessToken: token.accessToken,
														 idParameter: id)
            NetworkLayer.requestDecodable(router: router) { (result: GeofenceAPIResult) in
                
                switch result {
                case .failure(let error):
                    LOG.E(error.localizedDescription)
                    
                    completion(.failure(ErrorHandler.handle(error: error)))
                    
                case .success(let apiGeofence):
                    LOG.D(apiGeofence)
                    
                    let model = NetworkModelMapper.map(apiGeofenceModel: apiGeofence)
                    completion(.success(model))
                }
            }
        }
    }
    
    /// Update a geofence
    ///
    /// - Parameters:
    ///   - id: id of the geofence to update
    ///   - geofence: the updated model of the geofence
    ///   - onSuccess: Closure with UpdateGeofenceResult
    public func updateGeofence(id: Int, geofence: GeofenceModel, completion: @escaping UpdateGeofenceResult) {
        
        CarKit.tokenProvider.requestToken { token in
            
            let bodyDictParams = geofence.params()
            let router = BffGeofencingRouter.updateGeofence(accessToken: token.accessToken,
															idParameter: id,
															requestModel: bodyDictParams)
            self.request(router: router, completion: completion)
        }
    }
    
    /// Delete a geofence with the id
    ///
    /// - Parameters:
    ///   - id: the id of the fence that shall be deleted
    ///   - completion: Closure with DeleteGeofenceResult
    public func deleteGeofence(id: Int, completion: @escaping DeleteGeofenceResult) {
        
        CarKit.tokenProvider.requestToken { token in
            
            let router = BffGeofencingRouter.deleteGeofence(accessToken: token.accessToken,
															idParameter: id)
            self.request(router: router, completion: completion)
        }
    }
    
    /// Activate a geofence with the id for the vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - id: the id of the fence that shall be activated or deactivated
    ///   - completion: Closure with UpdateGeofenceResult
    public func activateGeofenceForVehicle(id: Int, finOrVin: String, completion: @escaping UpdateGeofenceResult) {
        
        CarKit.tokenProvider.requestToken { token in
            
            let router = BffGeofencingRouter.activateGeofencingForVehicle(accessToken: token.accessToken,
																		  finOrVin: finOrVin,
																		  idParameter: id)
            self.request(router: router, completion: completion)
        }
    }
    
    /// Delete a geofence with the id for the vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - id: the id of the fence that shall be deleted
    ///   - completion: Closure with DeleteGeofenceResult
    public func deleteGeofenceForVehicle(id: Int, finOrVin: String, completion: @escaping DeleteGeofenceResult) {
        
        CarKit.tokenProvider.requestToken { token in
            
            let router = BffGeofencingRouter.deleteGeofenceForVehicle(accessToken: token.accessToken,
																	  finOrVin: finOrVin,
																	  idParameter: id)
            self.request(router: router, completion: completion)
        }
    }
    
	
	// MARK: - Helper
	
	private func request(router: BffGeofencingRouter, completion: @escaping (EmptyResult) -> Void) {
		
		NetworkLayer.requestData(router: router) { (result) in
			
			switch result {
			case .failure(let error):   completion(.failure(ErrorHandler.handle(error: error)))
			case .success:              completion(.success)
			}
		}
	}
}

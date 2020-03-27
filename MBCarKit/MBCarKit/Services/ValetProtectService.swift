//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

/// Service to call all vale protect data related requests
public class ValetProtectService: NSObject {

    // MARK: Typealias
    
    /// Completion for valet protect item
    public typealias ValetProtectResult = (Result<ValetProtectModel, MBError>) -> Void
    
    /// Empty completion for create vale protect data
    public typealias ValetProtectCreateCompletion = (Result<ValetProtectModel, MBError>) -> Void
    
    /// Empty completion for delete valet protect data
    public typealias ValetProtectDeleteCompletion = (EmptyResult) -> Void
    
    typealias ValetProtectAPIResult = NetworkResult<APIValetProtect>
    
    /// Completion for valet protect violations
    public typealias ValetProtectViolationsResult = (Result<[ValetProtectViolationModel], MBError>) -> Void
    typealias ValetProtectViolationsAPIResult = NetworkResult<[APIValetProtectViolation]>

    /// Completion for valet protect violation
    public typealias ValetProtectViolationResult = (Result<ValetProtectViolationModel, MBError>) -> Void
    typealias ValetProtectViolationAPIResult = NetworkResult<APIValetProtectViolation>
    
    
    // MARK: - Public
    
    /// Fetch the valet protect for the vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - unit: unit of the Valet Protect radius (kilometers or miles)
    ///   - completion: Closure with valet protect item
    public func fetchValetProtectItem(finOrVin: String, unit: DistanceUnit, completion: @escaping ValetProtectResult) {
    
        CarKit.tokenProvider.requestToken { token in
            
            let router = BffValetProtectRouter.getValetProtectItem(finOrVin: finOrVin,
																   unit: unit.mapToString(),
																   accessToken: token.accessToken)
            NetworkLayer.requestDecodable(router: router) { (result: ValetProtectAPIResult) in
                
                switch result {
                case .failure(let error):
                    completion(.failure(ErrorHandler.handle(error: error)))
                    
                case .success(let apiValetProtect):
                    LOG.D(apiValetProtect)
                    
                    let model = NetworkModelMapper.map(apiValetProtectModel: apiValetProtect)
                    completion(.success(model))
                }
            }
        }
    }
    
    /// Create a valet protect item for the vehicle
    ///
    /// - Parameters:
    ///   - requestModel: the valet protect model to create
    ///   - finOrVin: fin or vin of the vehicle
    ///   - completion: Closure with enum-based ValetProtectModel
    public func createValetProtectItem(_ requestModel: ValetProtectModel, finOrVin: String, completion: @escaping ValetProtectCreateCompletion) {
        
        CarKit.tokenProvider.requestToken { token in
            
            let json        = try? requestModel.toJson()
            let requestDict = json as? [String: Any]
            let router = BffValetProtectRouter.createValetProtectItem(finOrVin: finOrVin,
																	  requestModel: requestDict,
																	  accessToken: token.accessToken)
            NetworkLayer.requestDecodable(router: router) { (result: ValetProtectAPIResult) in
                
                switch result {
                case .failure(let error):
                    completion(.failure(ErrorHandler.handle(error: error)))
                    
                case .success(let apiValetProtect):
                    LOG.D(apiValetProtect)
                    
                    let model = NetworkModelMapper.map(apiValetProtectModel: apiValetProtect)
                    completion(.success(model))
                }
            }
        }
    }
    
    /// Delete a valet protect item for the vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - completion: Closure with enum-based EmptyResult
    public func deleteValetProtectItem(finOrVin: String, completion: @escaping ValetProtectDeleteCompletion) {
        
        CarKit.tokenProvider.requestToken { token in
    
            let router = BffValetProtectRouter.deleteValetProtectItem(finOrVin: finOrVin,
																	  accessToken: token.accessToken)
            self.request(router: router, completion: completion)
        }
    }
    
    /// Fetch all valet protect violations for the vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - unit: unit of the Valet Protect radius (kilometers or miles)
    ///   - completion: Closure with valet protect violations
    public func fetchAllValetProtectViolations(finOrVin: String, unit: DistanceUnit, completion: @escaping ValetProtectViolationsResult) {

        CarKit.tokenProvider.requestToken { token in
            
            let router = BffValetProtectRouter.getAllViolations(finOrVin: finOrVin,
																unit: unit.mapToString(),
																accessToken: token.accessToken)
            NetworkLayer.requestDecodable(router: router) { (result: ValetProtectViolationsAPIResult) in
                
                switch result {
                case .failure(let error):
                    completion(.failure(ErrorHandler.handle(error: error)))

                case .success(let apiValetProtectViolations):
                     let model = NetworkModelMapper.map(apiValetProtectViolationModels: apiValetProtectViolations)
                     completion(.success(model))
                }
            }
        }
    }
    
    /// Delete all valet protect violations for the vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - completion: Closure with enum-based EmptyResult
    public func deleteAllValetProtectViolations(finOrVin: String, completion: @escaping ValetProtectDeleteCompletion) {
        
        CarKit.tokenProvider.requestToken { token in
            
            let router = BffValetProtectRouter.deleteAllViolations(finOrVin: finOrVin,
																   accessToken: token.accessToken)
            self.request(router: router, completion: completion)
        }
    }
    
    /// Fetch a valet protect violation
    ///
    /// - Parameters:
    ///   - id: id of the valet protect  violation to fetch
    ///   - finOrVin: fin or vin of the vehicle
    ///   - unit: unit of the Valet Protect radius (kilometers or miles)
    ///   - completion: Closure with valet protect violations
    public func fetchValetProtectViolation(id: String, finOrVin: String, unit: DistanceUnit, completion: @escaping ValetProtectViolationResult) {
        
        CarKit.tokenProvider.requestToken { token in

            let router = BffValetProtectRouter.getViolation(finOrVin: finOrVin,
															id: id,
															unit: unit.mapToString(),
															accessToken: token.accessToken)
            NetworkLayer.requestDecodable(router: router) { (result: ValetProtectViolationAPIResult) in
                
                switch result {
                case .failure(let error):
                    completion(.failure(ErrorHandler.handle(error: error)))

                case .success(let apiValetProtectViolation):
                     let model = NetworkModelMapper.map(apiValetProtectViolationModel: apiValetProtectViolation)
                     completion(.success(model))
                }
            }
        }
    }
    
    /// Delete a valet protect violation
    ///
    /// - Parameters:
    ///   - id: id of the valet protect  violation to delete
    ///   - finOrVin: fin or vin of the vehicle
    ///   - completion: Closure with enum-based EmptyResult
    public func deleteValetProtectViolation(id: String, finOrVin: String, completion: @escaping ValetProtectDeleteCompletion) {
        
        CarKit.tokenProvider.requestToken { token in
            
            let router = BffValetProtectRouter.deleteViolation(finOrVin: finOrVin,
															   id: id,
															   accessToken: token.accessToken)
			self.request(router: router, completion: completion)
        }
    }
    
    
	// MARK: - Helper
	
	private func request(router: BffValetProtectRouter, completion: @escaping (EmptyResult) -> Void) {
		
		NetworkLayer.requestData(router: router) { (result) in
			
			switch result {
			case .failure(let error):
				LOG.E(error.localizedDescription)
				completion(.failure(ErrorHandler.handle(error: error)))
			
			case .success:
				completion(.success)
			}
		}
	}
}

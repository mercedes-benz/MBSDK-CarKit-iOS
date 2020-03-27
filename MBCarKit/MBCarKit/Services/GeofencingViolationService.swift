//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

public class GeofencingViolationService: NSObject {
    
    // MARK: Typealias
    
    /// Completion for violations
    public typealias ViolationsResult = (Result<[ViolationModel], MBError>) -> Void

    /// Empty completion for delete one violation data
    public typealias DeleteViolationResult = (EmptyResult) -> Void
    
    /// Empty completion for delete all violations data
    public typealias DeleteAllViolationsResult = (EmptyResult) -> Void
    
    typealias ViolationsAPIResult = NetworkResult<[APIViolation]>
    
    // MARK: - Public
    
    /// Get all the geofencing violations for the currently selected vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    public func fetchGeofencingViolations(finOrVin: String, completion: @escaping ViolationsResult) {
        
        CarKit.tokenProvider.requestToken { token in
            
            let router = BffGeofencingViolationRouter.getAllGeofencingViolations(accessToken: token.accessToken, finOrVin: finOrVin)
            NetworkLayer.requestDecodable(router: router) { (result: ViolationsAPIResult) in
                
                switch result {
                case .failure(let error):
                    LOG.E(error.localizedDescription)
                    
                    completion(.failure(ErrorHandler.handle(error: error)))
                    
                case .success(let apiViolation):
                    LOG.D(apiViolation)
                    
                    let model = NetworkModelMapper.map(apiViolationModels: apiViolation)
                    completion(.success(model))
                }
            }
        }
    }
    
    /// Delete a geofencing violation with id for the currently selected vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - id: the id of the violation that shall be deleted
    public func deleteGeofencingViolation(finOrVin: String, id: Int, completion: @escaping DeleteViolationResult) {
        
        CarKit.tokenProvider.requestToken { token in
            
            let router = BffGeofencingViolationRouter.deleteGeofencingViolation(accessToken: token.accessToken,
																				finOrVin: finOrVin,
																				idParameter: id)
            self.request(router: router, completion: completion)
        }
    }
    
    /// Delete all geofencing violations for the currently selected vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    public func deleteAllGeofencingViolations(finOrVin: String, completion: @escaping DeleteAllViolationsResult) {
        
        CarKit.tokenProvider.requestToken { token in
            
            let router = BffGeofencingViolationRouter.deleteAllGeofencingViolations(accessToken: token.accessToken,
																					finOrVin: finOrVin)
			self.request(router: router, completion: completion)
        }
    }
    
	
	// MARK: - Helper
	
	private func request(router: BffGeofencingViolationRouter, completion: @escaping (EmptyResult) -> Void) {
		
		NetworkLayer.requestData(router: router) { (result) in
			
			switch result {
			case .failure(let error):   completion(.failure(ErrorHandler.handle(error: error)))
			case .success:              completion(.success)
			}
		}
	}
}

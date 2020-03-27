//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

public class SpeedAlertService: NSObject {
    
    // MARK: Typealias
    
    /// Completion for speed alert violations
    public typealias SppedAlertViolationsResult = (Result<[SpeedAlertViolationModel], MBError>) -> Void
    
    /// Empty completion for delete one speed alert violation data
    public typealias DeleteViolationCompletion = (EmptyResult) -> Void
    
    /// Empty completion for delete all speed alert violations data
    public typealias DeleteAllViolationsCompletion = (EmptyResult) -> Void
    
    typealias SpeedAlertViolationsAPIResult = NetworkResult<[APISpeedAlertViolation]>
    
    
    // MARK: - Public
    
    /// Get all the speed alert violations for the currently selected vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - unit: unit of the speed unit (kilometers or miles)
    
    public func fetchSpeedAlertViolations(finOrVin: String, unit: SpeedUnit, completion: @escaping SppedAlertViolationsResult) {

        CarKit.tokenProvider.requestToken { token in
            
            let router = BffSpeedAlertRouter.getAllSpeedAlertViolations(accessToken: token.accessToken,
                                                                             unit: unit.mapToString(),
                                                                             finOrVin: finOrVin)
            NetworkLayer.requestDecodable(router: router) { (result: SpeedAlertViolationsAPIResult) in
                
                switch result {
                case .failure(let error):
                    LOG.E(error.localizedDescription)
                    
                    completion(.failure(ErrorHandler.handle(error: error)))
                    
                case .success(let apiViolation):
                    LOG.D(apiViolation)
                    
                    let model = NetworkModelMapper.map(apiSpeedAlertViolationModels: apiViolation)
                    completion(.success(model))
                }
            }
        }
    }
    
    /// Delete a speed alert violation with id for the currently selected vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    ///   - id: the id of the speed alert violation that shall be deleted
    public func deleteSpeedAlertViolation(finOrVin: String, id: Int, completion: @escaping DeleteViolationCompletion) {
        
        CarKit.tokenProvider.requestToken { token in
            
            let router = BffSpeedAlertRouter.deleteSpeedAlertViolation(accessToken: token.accessToken,
																	   finOrVin: finOrVin,
																	   idParameter: id)
			self.request(router: router, completion: completion)
        }
    }
    
    /// Delete all speed alert violations for the currently selected vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle
    public func deleteAllSpeedAlertViolations(finOrVin: String, completion: @escaping DeleteAllViolationsCompletion) {
        
        CarKit.tokenProvider.requestToken { token in
            
            let router = BffSpeedAlertRouter.deleteAllSpeedAlertViolations(accessToken: token.accessToken,
																		   finOrVin: finOrVin)
			self.request(router: router, completion: completion)
        }
    }
    
    
	// MARK: - Helper
	
	private func request(router: BffSpeedAlertRouter, completion: @escaping (EmptyResult) -> Void) {
		
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

//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

public class SpeedFenceService: NSObject {
    
    // MARK: - Typealias
    
    /// Completion for fetch speedfence
    public typealias FetchSpeedfencesSucceeded = (Result<[SpeedFenceModel], MBError>) -> Void
    
    /// Completion for creeate speedfence
    public typealias CreateSpeedfenceSucceeded = (EmptyResult) -> Void
    
    /// Completion for delete all speedfences
    public typealias DeleteAllSpeedfencesSucceeded = (EmptyResult) -> Void
    
    /// Completion for delete speedfence
    public typealias DeleteSpeedfenceSucceeded = (EmptyResult) -> Void
    
    internal typealias SpeedfenceAPIResult = NetworkResult<[APISpeedFenceModel]>
    
	
    // MARK: - Public
    
    /// Get all the speedfences for the given vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle.
    public func fetchSpeedfences(finOrVin: String, completion: @escaping FetchSpeedfencesSucceeded) {
        
        CarKit.tokenProvider.requestToken { token in
            
            let router = BffSpeedFenceRouter.get(accessToken: token.accessToken, finOrVin: finOrVin)
            
            NetworkLayer.requestDecodable(router: router) { (result: SpeedfenceAPIResult) in
                
                switch result {
                case .failure(let error):
                    LOG.E(error.localizedDescription)
                    
                    completion(.failure(ErrorHandler.handle(error: error)))
                    
                case .success(let model):
                    
                    let resultModel = NetworkModelMapper.map(apiSpeedfencesModel: model)
                    completion(.success(resultModel))
                }
            }
        }
    }
    
    /// Create speedfences for the given vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle.
    ///   - speedfences: The model of speedfences which shall be created.
    public func createSpeedfences(finOrVin: String, speedfences: [SpeedFenceModel], completion: @escaping CreateSpeedfenceSucceeded) {
        
        CarKit.tokenProvider.requestToken { token in
            
            let json = try? speedfences.toJson()
            let router = BffSpeedFenceRouter.create(accessToken: token.accessToken,
													finOrVin: finOrVin,
													requestModel: json as? [String: Any])
            self.request(router: router, completion: completion)
        }
    }
    
    /// Deletes all speedfences for the given vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle.
    public func deleteAllSpeedfences(finOrVin: String, completion: @escaping DeleteAllSpeedfencesSucceeded) {
        
        CarKit.tokenProvider.requestToken { token in
            
            let router = BffSpeedFenceRouter.deleteAll(accessToken: token.accessToken,
													   finOrVin: finOrVin)
            self.request(router: router, completion: completion)
        }
    }
    
    /// Get all the speedfences for the given vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the vehicle.
    ///   - fenceId: ID of the fence to delete.
    public func deleteSpeedfences(finOrVin: String, fenceId: Int, completion: @escaping DeleteSpeedfenceSucceeded) {
        
        CarKit.tokenProvider.requestToken { token in
            
            let router = BffSpeedFenceRouter.delete(accessToken: token.accessToken,
													finOrVin: finOrVin,
													fenceId: fenceId)
			self.request(router: router, completion: completion)
        }
    }
	
	
	// MARK: - Helper
	
	private func request(router: BffSpeedFenceRouter, completion: @escaping (EmptyResult) -> Void) {
		
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

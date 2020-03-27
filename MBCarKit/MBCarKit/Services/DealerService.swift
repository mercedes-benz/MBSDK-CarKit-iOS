//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBNetworkKit

/// Service to call all outlet related requests
public class DealerService {

    // MARK: Typealias
    internal typealias DealersAPIResult = NetworkResult<[APIDealerSearchDealerModel]>
    
    public typealias DealersResult = (Result<[DealerSearchDealerModel], MBError>) -> Void

	// MARK: - Public
	
    /// Fetch the outlets
    ///
    /// - Parameters:
    ///   - requestModel: DealerSearchRequestModel with specific kind of search
    ///   - completion: closure with DealersResult
    public func fetchDealers(requestModel: DealerSearchRequestModel, completion: @escaping DealersResult) {

        CarKit.tokenProvider.requestToken { token in
            
            let apiSearchRequestModel = NetworkModelMapper.map(dealerSearchRequestModel: requestModel)
            let json        = try? apiSearchRequestModel.toJson()
            let requestDict = json as? [String: Any]
            let router      = BffVehicleRouter.dealers(accessToken: token.accessToken, requestModel: requestDict)

            NetworkLayer.requestDecodable(router: router) { (result: DealersAPIResult) in

                switch result {
                case .failure(let error):
                    LOG.E(error.localizedDescription)
                    
                    completion(.failure(ErrorHandler.handle(error: error)))

                case .success(let apiServiceModels):
                    LOG.D(apiServiceModels)

                    let serviceModels = NetworkModelMapper.map(apiDealerSearchDealerModels: apiServiceModels)
                    completion(.success(serviceModels))
                }
            }
        }
    }
}

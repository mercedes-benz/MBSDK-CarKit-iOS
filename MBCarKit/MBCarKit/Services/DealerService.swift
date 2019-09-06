//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBNetworkKit

/// Service to call all outlet related requests
public class DealerService {

    // MARK: Typealias
    internal typealias DealersAPIResult = NetworkResult<[APIDealerSearchDealerModel]>
	

	// MARK: - Public
	
	/// Fetch the outlets
	///
	/// - Parameters:
	///   - requestModel: DealerSearchRequestModel with specific kind of search
	///   - completion: Success closure with array of DealerSearchDealerModel
	///   - onError: Error closure with error message string
	public func fetchDealers(requestModel: DealerSearchRequestModel, completion: @escaping ([DealerSearchDealerModel]) -> Void, onError: @escaping MBCarKit.ErrorDescription) {

        MBCarKit.tokenProvider.requestToken { token in
			
            let apiSearchRequestModel = NetworkModelMapper.map(dealerSearchRequestModel: requestModel)
            let json        = try? apiSearchRequestModel.toJson()
            let requestDict = json as? [String: Any]
            let router      = BffEndpointRouter.dealers(accessToken: token.accessToken, requestModel: requestDict)

            NetworkLayer.requestDecodable(router: router) { (result: DealersAPIResult) in

                switch result {
                case .failure(let error):
                    LOG.E(error.localizedDescription)
                    onError(self.handle(error: error))

                case .success(let apiServiceModels):
                    LOG.D(apiServiceModels)

                    let serviceModels = NetworkModelMapper.map(apiDealerSearchDealerModels: apiServiceModels)
                    completion(serviceModels)
                }
            }
        }
	}
	
	
	// MARK: - Helper
	
	private func handle(error: Error) -> String {
		
		let handleError   = NetworkLayer.handle(error: error, type: APIErrorDescriptionModel.self)
		let responseError = NetworkLayer.responseError(networkError: handleError.responseError?.networkError, model: handleError.errorModel?.description)
		return responseError.requestError ?? responseError.localizedDescription ?? ""
	}
}

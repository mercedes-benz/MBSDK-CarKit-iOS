//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

enum BffSpeedFenceRouter: EndpointRouter {
    case create(accessToken: String, finOrVin: String, requestModel: [String: Any]?)
    case delete(accessToken: String, finOrVin: String, fenceId: Int)
    case deleteAll(accessToken: String, finOrVin: String)
    case get(accessToken: String, finOrVin: String)
	
    // MARK: - Properties
    var baseURL: String {
        guard let baseUrl = CarKit.bffProvider?.urlProvider else {
            fatalError("This is a placeholder implementation. Please implement your own baseURL or use the implementation from MBRSAppfamily")
        }
        return baseUrl.baseUrl
    }
    
    var method: HTTPMethodType {
        switch self {
        case .create:		return .post
        case .delete:		return .delete
        case .deleteAll:	return .delete
        case .get:			return .get
        }
    }
    
    var path: String {
        switch self {
        case .create(accessToken: _, let finOrVin, _),
             .deleteAll(accessToken: _, let finOrVin),
			 .get(accessToken: _, let finOrVin):
            return "/speedfences/vehicles/\(finOrVin)"
			
        case .delete(accessToken: _, let finOrVin, let fenceId):
            return "/speedfences/vehicles/\(finOrVin)/fence/\(fenceId)"
        }
    }
    
    var parameters: [String: Any]? {
        return nil
    }
    
    var parameterEncoding: ParameterEncodingType {
        return .json
    }
    
    var cachePolicy: URLRequest.CachePolicy? {
        return nil
    }
    
    var httpHeaders: [String: String]? {
        guard let headerParamProvider = CarKit.bffProvider?.headerParamProvider else {
            fatalError("This is a placeholder implementation. Please implement your own headerParamProvider or use the implementation from MBRSAppfamily")
        }
        var headers = headerParamProvider.defaultHeaderParams
        
        switch self {
        case .create(let accessToken, _, _),
			 .delete(let accessToken, _, _),
             .deleteAll(let accessToken, _),
			 .get(let accessToken, _):
            headers[headerParamProvider.authorizationHeaderParamKey] = accessToken
            return headers
        }
    }
    
    var bodyParameters: [String: Any]? {
        switch self {
        case .create(_, _, let requestModel):
            return requestModel
			
        default:
            return nil
        }
    }
    
    var bodyEncoding: ParameterEncodingType {
        return .json
    }
}

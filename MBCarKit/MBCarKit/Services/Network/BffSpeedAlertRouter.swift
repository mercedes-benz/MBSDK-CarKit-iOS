//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

enum BffSpeedAlertRouter: EndpointRouter {
    case getAllSpeedAlertViolations(accessToken: String, unit: String, finOrVin: String)
    case deleteSpeedAlertViolation(accessToken: String, finOrVin: String, idParameter: Int)
    case deleteAllSpeedAlertViolations(accessToken: String, finOrVin: String)
    
	
	// MARK: - Properties

    var baseURL: String {
        guard let baseUrl = CarKit.bffProvider?.urlProvider else {
            fatalError("This is a placeholder implementation. Please implement your own baseURL or use the implementation from MBRSAppfamily")
        }
        return baseUrl.baseUrl
    }
    
    var method: HTTPMethodType {
        switch self {
        case .getAllSpeedAlertViolations:		return .get
        case .deleteSpeedAlertViolation:		return .delete
        case .deleteAllSpeedAlertViolations:	return .delete
        }
    }
    
    var path: String {
        switch self {
        case .getAllSpeedAlertViolations(_, _, let finOrVin),
             .deleteAllSpeedAlertViolations(_, let finOrVin):
            return "/speedalert/vehicles/\(finOrVin)/violations"

        case .deleteSpeedAlertViolation(_, let finOrVin, let idParameter):
            return "/speedalert/vehicles/\(finOrVin)/violations/\(idParameter)"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getAllSpeedAlertViolations(_, let unit, _):
            return ["unit": unit]
            
        case .deleteSpeedAlertViolation, .deleteAllSpeedAlertViolations:
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncodingType {
        return .url(type: .standard)
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
        case .getAllSpeedAlertViolations(let accessToken, _, _),
             .deleteSpeedAlertViolation(let accessToken, _, _),
             .deleteAllSpeedAlertViolations(let accessToken, _):
            headers[headerParamProvider.authorizationHeaderParamKey] = accessToken
            return headers
        }
    }
    
    var bodyParameters: [String: Any]? {
        return nil
    }
    
    var bodyEncoding: ParameterEncodingType {
        return .json
    }
    
}

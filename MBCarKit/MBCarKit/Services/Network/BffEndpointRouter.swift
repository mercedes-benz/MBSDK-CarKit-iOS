//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBNetworkKit

enum BffEndpointRouter: EndpointRouter {
	case assignmentAdd(accessToken: String, vin: String)
	case assignmentConfirm(accessToken: String, vac: String, vin: String)
	case assignmentDelete(accessToken: String, vin: String)
	case assignmentQr(accessToken: String, link: String)
	case consumption(accessToken: String, vin: String)
	case dealers(accessToken: String, requestModel: [String: Any]?)
	case dealersPreferred(accessToken: String, vin: String, requestModel: [[String: Any]]?)
	case image(accessToken: String, vin: String, requestModel: [String: Any]?)
	case images(accessToken: String, requestModel: [String: Any]?)
	case rif(accessToken: String, vin: String)
	case sendToCarCapability(accessToken: String, vin: String)
	case sendToCarRoute(accessToken: String, vin: String, requestModel: [String: Any]?)
	case serviceGet(accessToken: String, vin: String, locale: String, grouped: String?, services: [Int]?)
	case serviceUpdate(accessToken: String, vin: String, locale: String, requestModel: [[String: Any]]?)
	case vehicleLicense(accessToken: String, vin: String, locale: String, license: String)
	case vehicles(accessToken: String, countryCode: String, locale: String)
	
	// MARK: Properties
	var baseURL: String {
		guard let urlProvider = MBCarKit.bffProvider?.urlProvider else {
			fatalError("This is a placeholder implementation. Please implement your own bffProvider or use the implementation from MBMobileSDK")
		}
		return urlProvider.baseUrl
	}
	var httpHeaders: [String: String]? {
		
		guard let headerParamProvider = MBCarKit.bffProvider?.headerParamProvider else {
			fatalError("This is a placeholder implementation. Please implement your own headerParamProvider or use the implementation from MBMobileSDK")
		}
        var headers = headerParamProvider.defaultHeaderParams
        
		switch self {
		case .assignmentAdd(let accessToken, _),
			 .assignmentConfirm(let accessToken, _, _),
			 .assignmentDelete(let accessToken, _),
			 .assignmentQr(let accessToken, _),
			 .consumption(let accessToken, _),
			 .dealers(let accessToken, _),
			 .dealersPreferred(let accessToken, _, _),
			 .image(let accessToken, _, _),
			 .images(let accessToken, _),
			 .rif(let accessToken, _),
			 .sendToCarCapability(let accessToken, _),
			 .sendToCarRoute(let accessToken, _, _),
             .serviceGet(let accessToken, _, _, _, _),
			 .serviceUpdate(let accessToken, _, _, _),
			 .vehicles(let accessToken, _, _):
			headers[headerParamProvider.authorizationHeaderParamKey] = accessToken
			
		case .vehicleLicense(let accessToken, _, let locale, _):
			headers[headerParamProvider.authorizationHeaderParamKey] = accessToken
			headers[headerParamProvider.countryCodeHeaderParamKey] = locale
		}
		
		return headers
	}
	var method: HTTPMethodType {
		switch self {
		case .assignmentAdd:		return .put
		case .assignmentConfirm:	return .put
		case .assignmentDelete:		return .delete
		case .assignmentQr:			return .post
		case .consumption:			return .get
		case .dealers:				return .post
		case .dealersPreferred:		return .put
		case .image,
			 .images:				return .get
		case .rif:					return .get
		case .sendToCarCapability:	return .get
		case .sendToCarRoute:		return .post
		case .serviceGet:			return .get
		case .serviceUpdate:		return .post
		case .vehicleLicense:		return .put
		case .vehicles:				return .get
		}
	}
	var path: String {
		let ciamId = "self"
		switch self {
		case .assignmentAdd(_, let vin):
			return "/vehicle/\(vin)/user/\(ciamId)/assignment"

		case .assignmentConfirm(_, _, let vin):
            return "/vehicles/\(vin)/vehicle-assignment-code-confirmation"

		case .assignmentDelete(_, let vin):
			return "/vehicle/\(vin)/user/assignment"
			
		case .assignmentQr:
			return "/qr-assignment"
		
		case .consumption(_, let vin):
			return "vehicle/\(vin)/consumption"
			
		case .dealers:
            return "/outlets"

		case .dealersPreferred(_, let vin, _):
			return "/vehicle/\(vin)/dealers"
			
		case .image(_, let vin, _):
			return "/vehicle/\(vin)/images"
			
		case .images:
			return "/user/\(ciamId)/vehicleimages"
			
		case .rif(_, let vin):
			return "/rifability/\(vin)"
			
		case .sendToCarCapability(_, let vin):
			return "/vehicle/\(vin)/HUNotifCapability"
			
		case .sendToCarRoute(_, let vin, _):
			return "/vehicle/\(vin)/route"
			
		case .serviceGet(_, let vin, _, _, _),
			 .serviceUpdate(_, let vin, _, _):
			return "/vehicle/\(vin)/user/\(ciamId)/services"
			
		case .vehicleLicense(_, let vin, _, _):
			return "/vehicles/\(vin)/licenseplate"

		case .vehicles:
			return "/vehicle/\(ciamId)/masterdata"
		}
	}
	var parameters: [String: Any]? {
		switch self {
		case .assignmentAdd:
			return nil
			
		case .assignmentConfirm:
			return nil
			
		case .assignmentDelete:
			return nil
			
		case .assignmentQr(_, let link):
			return [
				"qrLink": link
			]
		
		case .consumption,
			 .dealers,
			 .dealersPreferred:
			return nil

		case .image(_, _, let requestModel),
			 .images(_, let requestModel):
			return requestModel
			
		case .rif:
			return nil
			
		case .sendToCarCapability,
			 .sendToCarRoute:
			return nil
			
		case .serviceGet(_, _, let locale, let grouped, let services):
			var params = [
				"locale": locale
			]
			
			if let grouped = grouped {
				params["group_by"] = grouped
			}
			
			if let services = services,
				services.isEmpty == false {
				params["id"] = services.map { "\($0)" }.joined(separator: ",")
			}
			return params
			
		case .serviceUpdate(_, _, let locale, _):
			return [
				"locale": locale
			]
			
		case .vehicleLicense:
			return nil
			
		case .vehicles(_, let countryCode, let locale):
			return [
				"countryCode": countryCode,
				"locale": locale
			]
		}
	}
	var parameterEncoding: ParameterEncodingType {
		switch self {
		case .assignmentAdd,
             .assignmentConfirm,
             .assignmentDelete,
             .assignmentQr:
            return .json
		
		case .consumption,
			 .dealers,
			 .dealersPreferred:
            return .json

		case .image,
			 .images:
			return .url(type: .standard)
			
		case .rif:
			return .json
			
		case .sendToCarCapability:
			return .json
			
		case .sendToCarRoute:
			return .url(type: .query)
			
		case .serviceGet:
			return .url(type: .standard)

		case .serviceUpdate:
            return .url(type: .query)
			
		case .vehicleLicense:
			return .url(type: .query)
			
		case .vehicles:
			return .url(type: .standard)
		}
	}

    var bodyParameters: [String: Any]? {

		switch self {
		case .assignmentAdd,
			 .assignmentDelete,
			 .assignmentQr:
			return nil
			
		case .assignmentConfirm(_, let vac, _):
            return [
                "code": vac
            ]
			
		case .consumption:
			return nil
			
		case .dealers(_, let requestModel):
			return requestModel

		case .dealersPreferred(_, _, let requestModel):
			guard let requestModel = requestModel else {
				return nil
			}
			
			return [
				"items": requestModel
			]
			
		case .image,
			 .images,
			 .rif,
			 .sendToCarCapability,
			 .serviceGet:
			return nil
			
		case .sendToCarRoute(_, _, let requestModel):
			return requestModel

		case .serviceUpdate(_, _, _, let requestModel):
			guard let requestModel = requestModel else {
				return nil
			}
			
			return [
				"services": requestModel
			]
			
		case .vehicleLicense(_, _, _, let license):
			return [
				"licenseplate": license
			]
			
		case .vehicles:
			return nil
		}
    }

    var bodyEncoding: ParameterEncodingType {

		switch self {
		case .assignmentAdd,
			 .assignmentConfirm,
			 .assignmentDelete,
			 .assignmentQr,
			 .consumption:
			return self.parameterEncoding
			
		case .dealers,
			 .dealersPreferred:
			return .json
			
		case .image,
			 .images,
			 .rif,
			 .sendToCarCapability,
			 .serviceGet:
			return self.parameterEncoding
			
		case .sendToCarRoute,
			 .serviceUpdate,
			 .vehicleLicense:
			return .json
			
		case .vehicles:
			return self.parameterEncoding
		}
    }
    
	var cachePolicy: URLRequest.CachePolicy? {
		return nil
	}
	
	var timeout: TimeInterval {
		return MBCarKit.bffProvider?.urlProvider.requestTimeout ?? MBCarKit.defaultRequestTimeout
	}
}

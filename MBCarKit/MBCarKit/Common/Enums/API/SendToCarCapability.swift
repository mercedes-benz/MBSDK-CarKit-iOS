//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public enum SendToCarCapability: String, CaseIterable, Codable, CustomStringConvertible {

    case singlePoiBluetooth = "SINGLE_POI_BLUETOOTH"
    case singlePoiBackend = "SINGLE_POI_BACKEND"
    case staticRouteBackend = "STATIC_ROUTE_BACKEND"
    case dynamicRouteBackend = "DYNAMIC_ROUTE_BACKEND"

    public var description: String {
        switch self {
        case .singlePoiBluetooth:  return "Single poi via bluetooth"
        case .singlePoiBackend:    return "Single poi via backend"
        case .staticRouteBackend:  return "Route via backend"
        case .dynamicRouteBackend: return "Route via backend"
        }
    }
}

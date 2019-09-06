//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIDealerSearchRadiusModel: Codable {

    static let defaultValue = 5.0
    
    enum Unit: String, Codable {

        case km = "KM"
    }

    let value: String
    let unit: Unit
}

struct APIDealerSearchSearchAreaRequestModel: Codable {

    let center: APIDealerSearchCoordinateRequestModel
    let radius: APIDealerSearchRadiusModel
}

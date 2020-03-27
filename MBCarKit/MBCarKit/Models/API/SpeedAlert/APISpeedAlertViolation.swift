//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public struct APISpeedAlertViolation: Codable {
    let id: Int
    let time: Int
    let speedalertTreshold: Int
    let speedalertEndtime: Int
    let coordinates: APISpeedAlertCoordinates
}

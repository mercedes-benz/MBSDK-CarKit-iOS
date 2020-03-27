//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

 public struct APISpeedFenceModel: Codable {
    let armtype: Int
    let endtime: Int
    let geofenceid: Int
    let name: String
    let speedfenceid: Int
    let syncstatus: Int
    let threshold: Int
    let ts: Int
    let violationdelay: Int
    let violationtypes: [SpeedFenceViolationType]
}

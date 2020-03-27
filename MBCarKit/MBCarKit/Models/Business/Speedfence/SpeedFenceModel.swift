//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

public struct SpeedFenceModel: Codable {
    public let armtype: Int
    public let endtime: Int
    public let geofenceid: Int
    public let name: String
    public let speedfenceid: Int
    public let syncstatus: Int
    public let threshold: Int
    public let ts: Int
    public let violationdelay: Int
    public let violationtypes: [SpeedFenceViolationType]
}

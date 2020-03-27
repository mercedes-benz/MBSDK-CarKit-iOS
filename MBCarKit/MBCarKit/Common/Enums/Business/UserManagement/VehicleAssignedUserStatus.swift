//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public enum VehicleAssignedUserStatus: String, Codable {
	case owner = "OWNER"
	case pending = "PENDING_USER"
	case valid = "VALID_USER"
	case unknown = "UNKNOWN_STATUS"
}

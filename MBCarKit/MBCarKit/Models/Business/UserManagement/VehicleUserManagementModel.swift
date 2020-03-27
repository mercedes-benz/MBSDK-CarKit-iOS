//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public struct VehicleUserManagementModel {

	// MARK: Properties

	public let finOrVin: String
	public let metaData: UserManagementMetaDataModel
	public let owner: VehicleAssignedUserModel
	public let users: [VehicleAssignedUserModel]?
	public let unassignedProfiles: [VehicleProfileModel]
}

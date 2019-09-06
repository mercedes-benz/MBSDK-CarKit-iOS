//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - VehicleDoorModel

/// Representation of door related attributes
public struct VehicleDoorModel {
	
	public let lockState: StatusAttributeType<LockStatus, NoUnit>
	public let state: StatusAttributeType<DoorStatus, NoUnit>
}


// MARK: - VehicleDoorsModel

/// Representation all kind of doors
public struct VehicleDoorsModel {
	
	public let decklid: VehicleDoorModel
	public let frontLeft: VehicleDoorModel
	public let frontRight: VehicleDoorModel
	public let lockStatusOverall: StatusAttributeType<DoorLockOverallStatus, NoUnit>
	public let rearLeft: VehicleDoorModel
	public let rearRight: VehicleDoorModel
	public let statusOverall: StatusAttributeType<DoorOverallStatus, NoUnit>
}

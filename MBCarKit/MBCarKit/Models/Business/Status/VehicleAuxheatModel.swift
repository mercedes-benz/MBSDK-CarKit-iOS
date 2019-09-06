//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of auxheat related attributes
public struct VehicleAuxheatModel {
	
	public let isActive: StatusAttributeType<ActiveState, NoUnit>
	public let runtime: StatusAttributeType<Int, NoUnit>
	public let state: StatusAttributeType<AuxheatState, NoUnit>
	public let time1: StatusAttributeType<Int, ClockHourUnit>
	public let time2: StatusAttributeType<Int, ClockHourUnit>
	public let time3: StatusAttributeType<Int, ClockHourUnit>
	public let timeSelection: StatusAttributeType<AuxheatTimeSelectionState, NoUnit>
	public let warnings: StatusAttributeType<AuxheatWarningBitmask, NoUnit>
}

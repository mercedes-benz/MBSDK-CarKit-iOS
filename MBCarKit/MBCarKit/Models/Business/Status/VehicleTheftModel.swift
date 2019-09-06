//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of theft related attributes
public struct VehicleTheftModel {
	
	public let collision: VehicleCollisionModel
	public let interiorProtectionSensorStatus: StatusAttributeType<ProtectionStatus, NoUnit>
    public let lastTheftWarning: StatusAttributeType<Int, NoUnit>
	public let lastTheftWarningReason: StatusAttributeType<TheftWarningReason, NoUnit>
	public let theftAlarmActive: StatusAttributeType<ActiveState, NoUnit>
	public let theftSystemArmed: StatusAttributeType<ArmedState, NoUnit>
	public let towProtectionSensorStatus: StatusAttributeType<ProtectionStatus, NoUnit>
}

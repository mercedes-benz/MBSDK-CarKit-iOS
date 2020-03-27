//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of collision related attributes
public struct VehicleCollisionModel {
	
	public let lastParkEvent: StatusAttributeType<Int, ClockHourUnit>
	public let parkEventLevel: StatusAttributeType<LowMediumHighState, NoUnit>
	public let parkEventSensorStatus: StatusAttributeType<ProtectionStatus, NoUnit>
	public let parkEventType: StatusAttributeType<ParkEventType, NoUnit>
}

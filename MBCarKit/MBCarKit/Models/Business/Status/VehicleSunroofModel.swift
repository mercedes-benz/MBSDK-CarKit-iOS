//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of sunroof related attributes
public struct VehicleSunroofModel {
	
	public let event: StatusAttributeType<SunroofEventState, NoUnit>
	public let isEventActive: StatusAttributeType<ActiveState, NoUnit>
	public let status: StatusAttributeType<SunroofStatus, NoUnit>
}

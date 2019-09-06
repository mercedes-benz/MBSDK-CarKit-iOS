//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation all kind of windows
public struct VehicleWindowsModel {
	
	public let frontLeft: StatusAttributeType<WindowStatus, NoUnit>
	public let frontRight: StatusAttributeType<WindowStatus, NoUnit>
	public let overallState: StatusAttributeType<WindowsOverallStatus, NoUnit>
	public let rearLeft: StatusAttributeType<WindowStatus, NoUnit>
	public let rearRight: StatusAttributeType<WindowStatus, NoUnit>
	public let sunroof: VehicleSunroofModel
}

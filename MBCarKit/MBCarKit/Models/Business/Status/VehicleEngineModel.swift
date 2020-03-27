//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of engine related attributes
public struct VehicleEngineModel {
	
	public let ignitionState: StatusAttributeType<IgnitionState, NoUnit>
	public let remoteStartEndtime: StatusAttributeType<Int, NoUnit>
	public let remoteStartIsActive: StatusAttributeType<RemoteStartActiveState, NoUnit>
	public let remoteStartTemperature: StatusAttributeType<Double, TemperatureUnit>
	public let state: StatusAttributeType<EngineState, NoUnit>
}

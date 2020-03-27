//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of vehicle related attributes
public struct VehicleVehicleModel {
	
	public let dataConnectionState: StatusAttributeType<Double, NoUnit>
	public let engineHoodStatus: StatusAttributeType<OpenCloseState, NoUnit>
	public let filterParticaleState: StatusAttributeType<FilterParticleState, NoUnit>
	public let odo: StatusAttributeType<Int, DistanceUnit>
	public let lockGasState: StatusAttributeType<LockStatus, NoUnit>
	public let parkBrakeStatus: StatusAttributeType<ActiveState, NoUnit>
	public let roofTopState: StatusAttributeType<RoofTopState, NoUnit>
	public let serviceIntervalDays: StatusAttributeType<Int, NoUnit>
	public let serviceIntervalDistance: StatusAttributeType<Int, DistanceUnit>
	public let soc: StatusAttributeType<Int, RatioUnit>
    public let speedAlert: StatusAttributeType<[VehicleSpeedAlertModel], NoUnit>
	public let speedUnitFromIC: StatusAttributeType<SpeedUnitType, NoUnit>
	public let starterBatteryState: StatusAttributeType<StarterBatteryState, NoUnit>
	public let time: StatusAttributeType<Int, NoUnit>
	public let vehicleLockState: StatusAttributeType<VehicleLockStatus, NoUnit>
}

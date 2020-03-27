//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - VehicleTireModel

/// Representation of tire related attributes
public struct VehicleTireModel {
	
	public let pressure: StatusAttributeType<Double, PressureUnit>
	public let warningLevel: StatusAttributeType<TireMarkerWarning, NoUnit>
}


// MARK: - VehicleTiresModel

/// Representation of tires related attributes
public struct VehicleTiresModel {
	
	public let frontLeft: VehicleTireModel
	public let frontRight: VehicleTireModel
	public let pressureMeasurementTimestamp: StatusAttributeType<Int, NoUnit>
	public let rearLeft: VehicleTireModel
	public let rearRight: VehicleTireModel
	public let sensorAvailable: StatusAttributeType<TireSensorState, NoUnit>
	public let warningLevelOverall: StatusAttributeType<TireMarkerWarning, NoUnit>
}

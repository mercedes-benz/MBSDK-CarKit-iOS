//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - VehicleStatisticsModel

/// Representation of statistic related attributes
public struct VehicleStatisticsModel {
	
	public let averageSpeed: VehicleStatisticResetStartDoubleModel<SpeedUnit>
	public let distance: VehicleStatisticDistanceModel
	public let drivenTime: VehicleStatisticDrivenTimeModel
	public let electric: VehicleStatisticTankModel<ElectricityConsumptionUnit, DistanceUnit>
	public let gas: VehicleStatisticTankModel<GasConsumptionUnit, DistanceUnit>
	public let liquid: VehicleStatisticTankModel<CombustionConsumptionUnit, DistanceUnit>
}


// MARK: - VehicleStatisticDistanceModel

/// Representation of statistic based distance related attributes
public struct VehicleStatisticDistanceModel {
	
	public let reset: StatusAttributeType<Double, DistanceUnit>
	public let start: StatusAttributeType<Double, DistanceUnit>
	public let ze: VehicleStatisticResetStartIntModel<DistanceUnit>
}


// MARK: - VehicleStatisticDrivenTimeModel

/// Representation of statistic based driven time related attributes
public struct VehicleStatisticDrivenTimeModel {
	
	public let reset: StatusAttributeType<Int, NoUnit>
	public let start: StatusAttributeType<Int, NoUnit>
	public let ze: VehicleStatisticResetStartIntModel<NoUnit>
}


// MARK: - VehicleStatisticResetStartDoubleModel

/// Representation of statistic based reset start related attributes
public struct VehicleStatisticResetStartDoubleModel<T> {
	
	public let reset: StatusAttributeType<Double, T>
	public let start: StatusAttributeType<Double, T>
}


// MARK: - VehicleStatisticResetStartIntModel

/// Representation of statistic based reset start related attributes
public struct VehicleStatisticResetStartIntModel<T> {
	
	public let reset: StatusAttributeType<Int, T>
	public let start: StatusAttributeType<Int, T>
}

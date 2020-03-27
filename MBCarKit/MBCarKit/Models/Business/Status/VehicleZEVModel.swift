//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - VehicleZEVModel

/// Representation of zev related attributes
public struct VehicleZEVModel {
	
    public let chargePrograms: StatusAttributeType<[VehicleChargeProgramModel], NoUnit>
	public let chargingActive: StatusAttributeType<ActiveState, NoUnit>
	public let chargingError: StatusAttributeType<ChargingError, NoUnit>
	public let chargingMode: StatusAttributeType<ChargingMode, NoUnit>
	public let chargingPower: StatusAttributeType<Double, NoUnit>
	public let chargingStatus: StatusAttributeType<ChargingStatus, NoUnit>
	public let departureTime: StatusAttributeType<Int, ClockHourUnit>
	public let departureTimeMode: StatusAttributeType<DepartureTimeMode, NoUnit>
	public let departureTimeSoc: StatusAttributeType<Int, RatioUnit>
	public let departureTimeWeekday: StatusAttributeType<Day, NoUnit>
	public let endOfChargeTime: StatusAttributeType<Int, ClockHourUnit>
	public let endOfChargeTimeRelative: StatusAttributeType<Double, ClockHourUnit>
	public let endOfChargeTimeWeekday: StatusAttributeType<Day, NoUnit>
	public let hybridWarnings: StatusAttributeType<HybridWarningState, NoUnit>
	public let isActive: StatusAttributeType<ActiveState, NoUnit>
	public let maxRange: StatusAttributeType<Int, DistanceUnit>
	public let maxSoc: StatusAttributeType<Int, RatioUnit>
	public let maxSocLowerLimit: StatusAttributeType<Int, RatioUnit>
	public let precondActive: StatusAttributeType<ActiveState, NoUnit>
	public let precondAtDeparture: StatusAttributeType<ActiveState, NoUnit>
	public let precondAtDepartureDisable: StatusAttributeType<DisableState, NoUnit>
	public let precondDuration: StatusAttributeType<Int, NoUnit>
	public let precondError: StatusAttributeType<PrecondError, NoUnit>
	public let precondNow: StatusAttributeType<ActiveState, NoUnit>
	public let precondNowError: StatusAttributeType<PrecondError, NoUnit>
	public let precondSeatFrontLeft: StatusAttributeType<OnOffState, NoUnit>
	public let precondSeatFrontRight: StatusAttributeType<OnOffState, NoUnit>
	public let precondSeatRearLeft: StatusAttributeType<OnOffState, NoUnit>
	public let precondSeatRearRight: StatusAttributeType<OnOffState, NoUnit>
	public let selectedChargeProgram: StatusAttributeType<ChargingProgram, NoUnit>
	public let smartCharging: StatusAttributeType<SmartCharging, NoUnit>
	public let smartChargingAtDeparture: StatusAttributeType<SmartChargingDeparture, NoUnit>
	public let smartChargingAtDeparture2: StatusAttributeType<SmartChargingDeparture, NoUnit>
	public let socProfile: StatusAttributeType<[VehicleZEVSocProfileModel], NoUnit>
	public let temperature: VehicleZEVTemperatureModel
	public let weekdayTariff: StatusAttributeType<[VehicleZEVTariffModel], NoUnit>
	public let weekendTariff: StatusAttributeType<[VehicleZEVTariffModel], NoUnit>
}


// MARK: - VehicleZEVSocProfileModel

/// Representation of zev state of charge profile related attributes
public struct VehicleZEVSocProfileModel {
	
	public let soc: Int32
	public let time: Int64
}


// MARK: - VehicleZEVTariffModel

/// Representation of zev temperature zone related attributes
public struct VehicleZEVTariffModel {
	
	public let rate: Int32
	public let time: Int32
}


// MARK: - VehicleZEVTemperatureModel

/// Representation of zev temperature zone related attributes
public struct VehicleZEVTemperatureModel {
	
	public let frontCenter: StatusAttributeType<Double, TemperatureUnit>
	public let frontLeft: StatusAttributeType<Double, TemperatureUnit>
	public let frontRight: StatusAttributeType<Double, TemperatureUnit>
	public let rearCenter: StatusAttributeType<Double, TemperatureUnit>
	public let rearCenter2: StatusAttributeType<Double, TemperatureUnit>
	public let rearLeft: StatusAttributeType<Double, TemperatureUnit>
	public let rearRight: StatusAttributeType<Double, TemperatureUnit>
}

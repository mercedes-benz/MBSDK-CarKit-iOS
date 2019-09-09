//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

class VehicleStatusDTO {
	
	var auxheatActive: VehicleStatusAttributeModel<Bool, NoUnit>?
	var auxheatRuntime: VehicleStatusAttributeModel<Int, NoUnit>?
	var auxheatState: VehicleStatusAttributeModel<Int, NoUnit>?
	var auxheatTime1: VehicleStatusAttributeModel<Int, ClockHourUnit>?
	var auxheatTime2: VehicleStatusAttributeModel<Int, ClockHourUnit>?
	var auxheatTime3: VehicleStatusAttributeModel<Int, ClockHourUnit>?
	var auxheatTimeSelection: VehicleStatusAttributeModel<Int, NoUnit>?
	var auxheatWarnings: VehicleStatusAttributeModel<Int, NoUnit>?
	var averageSpeedReset: VehicleStatusAttributeModel<Double, SpeedUnit>?
	var averageSpeedStart: VehicleStatusAttributeModel<Double, SpeedUnit>?
	var chargingActive: VehicleStatusAttributeModel<Bool, NoUnit>?
	var chargingError: VehicleStatusAttributeModel<Int, NoUnit>?
	var chargingMode: VehicleStatusAttributeModel<Int, NoUnit>?
	var chargingPower: VehicleStatusAttributeModel<Double, NoUnit>?
	var chargingStatus: VehicleStatusAttributeModel<Int, NoUnit>?
	var clientMessageData: Data?
	var decklidLockState: VehicleStatusAttributeModel<Bool, NoUnit>?
	var decklidState: VehicleStatusAttributeModel<Bool, NoUnit>?
	var departureTime: VehicleStatusAttributeModel<Int, ClockHourUnit>?
	var departureTimeMode: VehicleStatusAttributeModel<Int, NoUnit>?
	var departureTimeSoc: VehicleStatusAttributeModel<Int, RatioUnit>?
	var departureTimeWeekday: VehicleStatusAttributeModel<Int, NoUnit>?
	var distanceElectricalReset: VehicleStatusAttributeModel<Double, DistanceUnit>?
	var distanceElectricalStart: VehicleStatusAttributeModel<Double, DistanceUnit>?
	var distanceGasReset: VehicleStatusAttributeModel<Double, DistanceUnit>?
	var distanceGasStart: VehicleStatusAttributeModel<Double, DistanceUnit>?
	var distanceReset: VehicleStatusAttributeModel<Double, DistanceUnit>?
	var distanceStart: VehicleStatusAttributeModel<Double, DistanceUnit>?
	var distanceZEReset: VehicleStatusAttributeModel<Int, DistanceUnit>?
	var distanceZEStart: VehicleStatusAttributeModel<Int, DistanceUnit>?
	var doorFrontLeftLockState: VehicleStatusAttributeModel<Bool, NoUnit>?
	var doorFrontLeftState: VehicleStatusAttributeModel<Bool, NoUnit>?
	var doorFrontRightLockState: VehicleStatusAttributeModel<Bool, NoUnit>?
	var doorFrontRightState: VehicleStatusAttributeModel<Bool, NoUnit>?
	var doorLockStatusGas: VehicleStatusAttributeModel<Bool, NoUnit>?
	var doorLockStatusOverall: VehicleStatusAttributeModel<Int, NoUnit>?
	var doorLockStatusVehicle: VehicleStatusAttributeModel<Int, NoUnit>?
	var doorRearLeftLockState: VehicleStatusAttributeModel<Bool, NoUnit>?
	var doorRearLeftState: VehicleStatusAttributeModel<Bool, NoUnit>?
	var doorRearRightLockState: VehicleStatusAttributeModel<Bool, NoUnit>?
	var doorRearRightState: VehicleStatusAttributeModel<Bool, NoUnit>?
	var doorStatusOverall: VehicleStatusAttributeModel<Int, NoUnit>?
	var drivenTimeReset: VehicleStatusAttributeModel<Int, NoUnit>?
	var drivenTimeStart: VehicleStatusAttributeModel<Int, NoUnit>?
	var drivenTimeZEReset: VehicleStatusAttributeModel<Int, NoUnit>?
	var drivenTimeZEStart: VehicleStatusAttributeModel<Int, NoUnit>?
	var ecoScoreAccel: VehicleStatusAttributeModel<Int, RatioUnit>?
	var ecoScoreBonusRange: VehicleStatusAttributeModel<Double, DistanceUnit>?
	var ecoScoreConst: VehicleStatusAttributeModel<Int, RatioUnit>?
	var ecoScoreFreeWhl: VehicleStatusAttributeModel<Int, RatioUnit>?
	var ecoScoreTotal: VehicleStatusAttributeModel<Int, RatioUnit>?
	var electricConsumptionReset: VehicleStatusAttributeModel<Double, ElectricityConsumptionUnit>?
	var electricConsumptionStart: VehicleStatusAttributeModel<Double, ElectricityConsumptionUnit>?
	var electricalRangeSkipIndication: VehicleStatusAttributeModel<Bool, NoUnit>?
	var endOfChargeTime: VehicleStatusAttributeModel<Int, ClockHourUnit>?
	var endOfChargeTimeRelative: VehicleStatusAttributeModel<Double, ClockHourUnit>?
	var endOfChargeTimeWeekday: VehicleStatusAttributeModel<Int, NoUnit>?
	var engineHoodStatus: VehicleStatusAttributeModel<Bool, NoUnit>?
	var engineState: VehicleStatusAttributeModel<Bool, NoUnit>?
    var eventTimestamp: Int64?
	var filterParticleLoading: VehicleStatusAttributeModel<Int, NoUnit>?
	var gasConsumptionReset: VehicleStatusAttributeModel<Double, GasConsumptionUnit>?
	var gasConsumptionStart: VehicleStatusAttributeModel<Double, GasConsumptionUnit>?
	var hybridWarnings: VehicleStatusAttributeModel<Int, NoUnit>?
	var ignitionState: VehicleStatusAttributeModel<Int, NoUnit>?
	var interiorProtectionSensorStatus: VehicleStatusAttributeModel<Int, NoUnit>?
	var languageHU: VehicleStatusAttributeModel<Int, NoUnit>?
    var lastParkEvent: VehicleStatusAttributeModel<Int, NoUnit>?
    var lastTheftWarning: VehicleStatusAttributeModel<Int, NoUnit>?
    var lastTheftWarningReason: VehicleStatusAttributeModel<Int, NoUnit>?
	var liquidConsumptionReset: VehicleStatusAttributeModel<Double, CombustionConsumptionUnit>?
	var liquidConsumptionStart: VehicleStatusAttributeModel<Double, CombustionConsumptionUnit>?
	var liquidRangeSkipIndication: VehicleStatusAttributeModel<Bool, NoUnit>?
	var maxRange: VehicleStatusAttributeModel<Int, DistanceUnit>?
	var maxSoc: VehicleStatusAttributeModel<Int, RatioUnit>?
	var maxSocLowerLimit: VehicleStatusAttributeModel<Int, RatioUnit>?
	var odo: VehicleStatusAttributeModel<Int, DistanceUnit>?
	var parkBrakeStatus: VehicleStatusAttributeModel<Bool, NoUnit>?
	var parkEventLevel: VehicleStatusAttributeModel<Int, NoUnit>?
	var parkEventType: VehicleStatusAttributeModel<Int, NoUnit>?
	var positionErrorCode: VehicleStatusAttributeModel<Int, NoUnit>?
	var positionHeading: VehicleStatusAttributeModel<Double, NoUnit>?
	var positionLat: VehicleStatusAttributeModel<Double, NoUnit>?
	var positionLong: VehicleStatusAttributeModel<Double, NoUnit>?
	var precondActive: VehicleStatusAttributeModel<Bool, NoUnit>?
	var precondAtDeparture: VehicleStatusAttributeModel<Bool, NoUnit>?
	var precondAtDepartureDisable: VehicleStatusAttributeModel<Bool, NoUnit>?
	var precondDuration: VehicleStatusAttributeModel<Int, NoUnit>?
	var precondError: VehicleStatusAttributeModel<Int, NoUnit>?
	var precondNow: VehicleStatusAttributeModel<Bool, NoUnit>?
	var precondNowError: VehicleStatusAttributeModel<Int, NoUnit>?
	var precondSeatFrontLeft: VehicleStatusAttributeModel<Bool, NoUnit>?
	var precondSeatFrontRight: VehicleStatusAttributeModel<Bool, NoUnit>?
	var precondSeatRearLeft: VehicleStatusAttributeModel<Bool, NoUnit>?
	var precondSeatRearRight: VehicleStatusAttributeModel<Bool, NoUnit>?
	var remoteStartActive: VehicleStatusAttributeModel<Bool, NoUnit>?
	var remoteStartEndtime: VehicleStatusAttributeModel<Int, NoUnit>?
	var remoteStartTemperature: VehicleStatusAttributeModel<Double, TemperatureUnit>?
	var roofTopStatus: VehicleStatusAttributeModel<Int, NoUnit>?
	var selectedChargeProgram: VehicleStatusAttributeModel<Int, NoUnit>?
	var serviceIntervalDays: VehicleStatusAttributeModel<Int, NoUnit>?
	var serviceIntervalDistance: VehicleStatusAttributeModel<Int, DistanceUnit>?
	let sequenceNumber: Int32
	var smartCharging: VehicleStatusAttributeModel<Int, NoUnit>?
	var smartChargingAtDeparture: VehicleStatusAttributeModel<Bool, NoUnit>?
	var smartChargingAtDeparture2: VehicleStatusAttributeModel<Bool, NoUnit>?
	var soc: VehicleStatusAttributeModel<Int, RatioUnit>?
	var socProfile: VehicleStatusAttributeModel<[VehicleZEVSocProfileModel], NoUnit>?
	var speedUnitFromIC: VehicleStatusAttributeModel<Bool, NoUnit>?
	var starterBatteryState: VehicleStatusAttributeModel<Int, NoUnit>?
	var sunroofEventState: VehicleStatusAttributeModel<Int, NoUnit>?
	var sunroofEventActive: VehicleStatusAttributeModel<Bool, NoUnit>?
	var sunnroofState: VehicleStatusAttributeModel<Int, NoUnit>?
	var tankAdBlueLevel: VehicleStatusAttributeModel<Int, RatioUnit>?
	var tankElectricLevel: VehicleStatusAttributeModel<Double, RatioUnit>?
	var tankElectricRange: VehicleStatusAttributeModel<Int, DistanceUnit>?
	var tankGasLevel: VehicleStatusAttributeModel<Double, RatioUnit>?
	var tankGasRange: VehicleStatusAttributeModel<Double, DistanceUnit>?
	var tankLiquidLevel: VehicleStatusAttributeModel<Int, RatioUnit>?
	var tankLiquidRange: VehicleStatusAttributeModel<Int, DistanceUnit>?
	var temperaturePointFrontCenter: VehicleStatusAttributeModel<Double, TemperatureUnit>?
	var temperaturePointFrontLeft: VehicleStatusAttributeModel<Double, TemperatureUnit>?
	var temperaturePointFrontRight: VehicleStatusAttributeModel<Double, TemperatureUnit>?
	var temperaturePointRearCenter: VehicleStatusAttributeModel<Double, TemperatureUnit>?
	var temperaturePointRearCenter2: VehicleStatusAttributeModel<Double, TemperatureUnit>?
	var temperaturePointRearLeft: VehicleStatusAttributeModel<Double, TemperatureUnit>?
	var temperaturePointRearRight: VehicleStatusAttributeModel<Double, TemperatureUnit>?
	var temperatureUnitHU: VehicleStatusAttributeModel<Bool, NoUnit>?
	var theftSystemArmed: VehicleStatusAttributeModel<Bool, NoUnit>?
	var theftAlarmActive: VehicleStatusAttributeModel<Bool, NoUnit>?
	var timeFormatHU: VehicleStatusAttributeModel<Bool, NoUnit>?
	var tireMarkerFrontLeft: VehicleStatusAttributeModel<Int, NoUnit>?
	var tireMarkerFrontRight: VehicleStatusAttributeModel<Int, NoUnit>?
	var tireMarkerRearLeft: VehicleStatusAttributeModel<Int, NoUnit>?
	var tireMarkerRearRight: VehicleStatusAttributeModel<Int, NoUnit>?
	var tirePressureFrontLeft: VehicleStatusAttributeModel<Double, PressureUnit>?
	var tirePressureFrontRight: VehicleStatusAttributeModel<Double, PressureUnit>?
	var tirePressureMeasTimestamp: VehicleStatusAttributeModel<Int, NoUnit>?
	var tirePressureRearLeft: VehicleStatusAttributeModel<Double, PressureUnit>?
	var tirePressureRearRight: VehicleStatusAttributeModel<Double, PressureUnit>?
	var tireSensorAvailable: VehicleStatusAttributeModel<Int, NoUnit>?
	var towProtectionSensorStatus: VehicleStatusAttributeModel<Int, NoUnit>?
	var trackingStateHU: VehicleStatusAttributeModel<Bool, NoUnit>?
	var vehicleDataConnectionState: VehicleStatusAttributeModel<Double, NoUnit>?
	var vehicleLockState: VehicleStatusAttributeModel<Int, NoUnit>?
	let vin: String
	var vTime: VehicleStatusAttributeModel<Int, NoUnit>?
	var warningBreakFluid: VehicleStatusAttributeModel<Bool, NoUnit>?
	var warningBrakeLiningWear: VehicleStatusAttributeModel<Bool, NoUnit>?
	var warningCoolantLevelLow: VehicleStatusAttributeModel<Bool, NoUnit>?
	var warningEngineLight: VehicleStatusAttributeModel<Bool, NoUnit>?
	var warningTireLamp: VehicleStatusAttributeModel<Int, NoUnit>?
	var warningTireLevelPrw: VehicleStatusAttributeModel<Int, NoUnit>?
	var warningTireSprw: VehicleStatusAttributeModel<Bool, NoUnit>?
	var warningTireSrdk: VehicleStatusAttributeModel<Int, NoUnit>?
	var warningWashWater: VehicleStatusAttributeModel<Bool, NoUnit>?
	var weekdaytariff: VehicleStatusAttributeModel<[VehicleZEVTariffModel], NoUnit>?
	var weekendtariff: VehicleStatusAttributeModel<[VehicleZEVTariffModel], NoUnit>?
	var weeklySetHU: VehicleStatusAttributeModel<[DayTimeModel], NoUnit>?
	var windowFrontLeftState: VehicleStatusAttributeModel<Int, NoUnit>?
	var windowFrontRightState: VehicleStatusAttributeModel<Int, NoUnit>?
	var windowRearLeftState: VehicleStatusAttributeModel<Int, NoUnit>?
	var windowRearRightState: VehicleStatusAttributeModel<Int, NoUnit>?
	var windowStatusOverall: VehicleStatusAttributeModel<Int, NoUnit>?
	var zevActive: VehicleStatusAttributeModel<Bool, NoUnit>?
	
	
	// MARK: - Init
	
	init(sequenceNumber: Int32, vin: String) {
		
		self.sequenceNumber = sequenceNumber
		self.vin = vin
	}
}

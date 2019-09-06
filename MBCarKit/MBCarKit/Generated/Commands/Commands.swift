//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//
// swiftlint:disable all

import Foundation

// MARK: - Command

public struct Command { 

	// MARK: - AuxHeatConfigure

    /// Command for configuring the auxiliary heating. It is possible to define three daytimes and select one active time.
	public struct AuxHeatConfigure {  

        /// Daytime in minutes after midnight. E.g. valid value for 8 am would be 480. Value range is 0 to 1439.
        let time1: Int

        /// Daytime in minutes after midnight. E.g. valid value for 8 am would be 480. Value range is 0 to 1439.
        let time2: Int

        /// Daytime in minutes after midnight. E.g. valid value for 8 am would be 480. Value range is 0 to 1439.
        let time3: Int

        /// The activated auxiliary heating preset time
        let timeSelection: AuxheatTimeSelectionState

        public init(time1: Int, time2: Int, time3: Int, timeSelection: AuxheatTimeSelectionState) {
        
            self.time1 = time1
            self.time2 = time2
            self.time3 = time3
            self.timeSelection = timeSelection
        }
	}

	// MARK: - AuxHeatStart

    /// Command for starting the auxiliary heating.
	public struct AuxHeatStart { 

        public init() {
        
        }
	}

	// MARK: - AuxHeatStop

    /// Command for stopping the auxiliary heating.
	public struct AuxHeatStop { 

        public init() {
        
        }
	}

	// MARK: - BatteryMaxStateOfChargeConfigure

    /// Command for setting the charging limit to potentially protect the battery by lowering the maximum state of charge
	public struct BatteryMaxStateOfChargeConfigure {  

        /// To protect the battery a maximum state of charge can be configured. Valid values 50, 60, 70, 80, 90 or 100
        let maxStateOfCharge: Int

        public init(maxStateOfCharge: Int) {
        
            self.maxStateOfCharge = maxStateOfCharge
        }
	}

	// MARK: - ChargeOptimizationConfigure

    /// Command for configuring the charge optimization settings.
    /// The vehicle will preferably charge in cheap tariff times. Only supported for vehicles produced until beginning 2018.
    /// NOT YET SUPPORTED ON PRODUCTION!
	public struct ChargeOptimizationConfigure {  

        /// List of tariff tuples indicating cheap/expensive time periods for weekdays
        let weekdays: [TariffModel]

        /// List of tariff tuples indicating cheap/expensive time periods for weekends
        let weekends: [TariffModel]

        public init(weekdays: [TariffModel], weekends: [TariffModel]) {
        
            self.weekdays = weekdays
            self.weekends = weekends
        }
	}

	// MARK: - ChargeOptimizationStart

    /// Command for configuring the charge optimization settings.
    /// The vehicle will preferably charge in cheap tariff times. Only supported for vehicles produced until beginning 2018.
    /// NOT YET SUPPORTED ON PRODUCTION!
	public struct ChargeOptimizationStart { 

        public init() {
        
        }
	}

	// MARK: - ChargeOptimizationStop

    /// Command for configuring the charge optimization settings.
    /// The vehicle will preferably charge in cheap tariff times. Only supported for vehicles produced until beginning 2018.
    /// NOT YET SUPPORTED ON PRODUCTION!
	public struct ChargeOptimizationStop { 

        public init() {
        
        }
	}

	// MARK: - DoorsLock

    /// Command for locking all doors of the vehicle.
    /// 
    /// Preconditions:
    /// * The doors of the vehicle must be closed.
	public struct DoorsLock { 

        public init() {
        
        }
	}

	// MARK: - DoorsUnlock

    /// Command for unlocking all doors of the vehicle. The user is required to enter his/her PIN for this command
	public struct DoorsUnlock { 

        public init() {
        
        }
	}

	// MARK: - EngineStart

    /// Command for starting the engine of the vehicle.
    /// Beware that there are regional restrictions for this command. E.g. this command won't work in Europe but would work in other countries like UAE.
    /// 
    /// Preconditions:
    /// * Vehicle must be parked
	public struct EngineStart { 

        public init() {
        
        }
	}

	// MARK: - EngineStop

    /// Command for stopping the engine of the vehicle. Beware that there are regional restrictions for this command. E.g. this command won't work in Europe but would in UAE.
	public struct EngineStop { 

        public init() {
        
        }
	}

	// MARK: - SunroofClose

    /// Command for closing the sunroof of the vehicle.
    /// 
    /// Preconditions:
    /// * Vehicle must be parked
    /// * doors must be locked and closed
    /// * ignition off.
	public struct SunroofClose { 

        public init() {
        
        }
	}

	// MARK: - SunroofLift

    /// Command for lifting the sunroof of the vehicle.
    /// 
    /// Preconditions:
    /// * Vehicle must be parked
    /// * doors must be locked and closed
    /// * ignition off.
	public struct SunroofLift { 

        public init() {
        
        }
	}

	// MARK: - SunroofOpen

    /// Command for opening the sunroof of the vehicle. The user is required to enter his/her PIN for this command.
    /// Preconditions:
    /// 
    /// * Vehicle must be parked
    /// * doors must be locked and closed
    /// * ignition off.
	public struct SunroofOpen { 

        public init() {
        
        }
	}

	// MARK: - SignalPosition

    /// Command for signaling the position of the vehicle by either horning or flashing lights or both for a defined duration. Beware horn is not allowed in Europe.
    /// NOT YET SUPPORTED ON PRODUCTION!
	public struct SignalPosition {  

        /// Amount for how often horning should be repeated
        let hornRepeat: Int

        /// The horn type to be used for signaling the position
        let hornType: HornType

        /// The light type to be used for signaling the position
        let lightType: LightType

        /// The duration for how long the position should be signaled in seconds
        let durationInSeconds: Int

        /// Type of how to signal the position
        let sigPosType: SigposType

        public init(hornRepeat: Int, hornType: HornType, lightType: LightType, durationInSeconds: Int, sigPosType: SigposType) {
        
            self.hornRepeat = hornRepeat
            self.hornType = hornType
            self.lightType = lightType
            self.durationInSeconds = durationInSeconds
            self.sigPosType = sigPosType
        }
	}

	// MARK: - SpeedAlertStart

    /// Command for setting and starting the speed alert configuration.
    /// NOT YET SUPPORTED ON PRODUCTION!
	public struct SpeedAlertStart {  

        /// 
        let alertEndTime: Int

        /// 
        let threshold: Int

        public init(alertEndTime: Int, threshold: Int) {
        
            self.alertEndTime = alertEndTime
            self.threshold = threshold
        }
	}

	// MARK: - SpeedAlertStop

    /// Command for disabling the speed alert.
    /// NOT YET SUPPORTED ON PRODUCTION!
	public struct SpeedAlertStop { 

        public init() {
        
        }
	}

	// MARK: - TemperatureConfigure

    /// Command for configuring the temperature zones of the vehicle.
    /// NOT YET SUPPORTED ON PRODUCTION!
	public struct TemperatureConfigure {  

        /// A list of temperature points consisting of the zone and desired temperature. Beware: all available zones must be set.
        let temperaturePoints: [TemperaturePointModel]

        public init(temperaturePoints: [TemperaturePointModel]) {
        
            self.temperaturePoints = temperaturePoints
        }
	}

	// MARK: - TheftAlarmConfirmDamageDetection

    /// Command for confirming damage detection.
    /// NOT YET SUPPORTED ON PRODUCTION!
	public struct TheftAlarmConfirmDamageDetection { 

        public init() {
        
        }
	}

	// MARK: - TheftAlarmDeselectDamageDetection

    /// Command for deselecting damage detection.
    /// NOT YET SUPPORTED ON PRODUCTION!
	public struct TheftAlarmDeselectDamageDetection { 

        public init() {
        
        }
	}

	// MARK: - TheftAlarmDeselectInterior

    /// Command for deselecting interior.
    /// NOT YET SUPPORTED ON PRODUCTION!
	public struct TheftAlarmDeselectInterior { 

        public init() {
        
        }
	}

	// MARK: - TheftAlarmDeselectTow

    /// Command for deselecting tow for theft alarm.
    /// NOT YET SUPPORTED ON PRODUCTION!
	public struct TheftAlarmDeselectTow { 

        public init() {
        
        }
	}

	// MARK: - TheftAlarmSelectDamageDetection

    /// Command for selecting damage detection.
    /// NOT YET SUPPORTED ON PRODUCTION!
	public struct TheftAlarmSelectDamageDetection { 

        public init() {
        
        }
	}

	// MARK: - TheftAlarmSelectInterior

    /// Command for selecting interior for theft alarm.
    /// NOT YET SUPPORTED ON PRODUCTION!
	public struct TheftAlarmSelectInterior { 

        public init() {
        
        }
	}

	// MARK: - TheftAlarmSelectTow

    /// Command to select tow for theft alarm.
    /// NOT YET SUPPORTED ON PRODUCTION!
	public struct TheftAlarmSelectTow { 

        public init() {
        
        }
	}

	// MARK: - TheftAlarmStart

    /// Command for starting the theft alarm.
    /// NOT YET SUPPORTED ON PRODUCTION!
	public struct TheftAlarmStart {  

        /// 
        let durationInSeconds: Int

        public init(durationInSeconds: Int) {
        
            self.durationInSeconds = durationInSeconds
        }
	}

	// MARK: - TheftAlarmStop

    /// Command for stopping the theft alarm.
    /// NOT YET SUPPORTED ON PRODUCTION!
	public struct TheftAlarmStop { 

        public init() {
        
        }
	}

	// MARK: - WeekProfileConfigure

    /// Command for configuring the departure times for a whole week to precondition the car upfront. Sending this command will replace the week profile settings and won't update/patch it.
	public struct WeekProfileConfigure {  

        /// A list of departure times that consist of the day and time in minutes since midnight (value range 0 to 1439)
        let dayTimes: [DayTimeModel]

        public init(dayTimes: [DayTimeModel]) {
        
            self.dayTimes = dayTimes
        }
	}

	// MARK: - WindowsClose

    /// Command for closing all windows of the vehicle.
    /// 
    /// Preconditions:
    /// * ignition off
    /// * doors closed & locked
	public struct WindowsClose { 

        public init() {
        
        }
	}

	// MARK: - WindowsOpen

    /// Command for opening all windows of the vehicle.
    /// The user is required to enter his/her PIN.
    /// 
    /// Preconditions:
    /// * ignition off
    /// * doors closed & locked
	public struct WindowsOpen { 

        public init() {
        
        }
	}

	// MARK: - ZevPreconditioningConfigure

    /// Command for disabling automatic preconditioning on departure time, activating a single time or activating the departure time week profile.
	public struct ZevPreconditioningConfigure {  

        /// Daytime in minutes after midnight. E.g. valid value for 8 am would be 480. Value range is 0 to 1439. Won't have an effect if mode is set to `weekly`
        let departureTime: Int

        /// The departure time setting. Either disabled, once or weekly (uses the configured week profile). If weekly is set the departure time value won't have an effect.
        let departureTimeMode: DepartureTimeConfiguration

        public init(departureTime: Int, departureTimeMode: DepartureTimeConfiguration) {
        
            self.departureTime = departureTime
            self.departureTimeMode = departureTimeMode
        }
	}

	// MARK: - ZevPreconditioningConfigureSeats

    /// Command for configuring the precondition either the driver seat only or all seats must be set to true. All other configurations are not supported.
	public struct ZevPreconditioningConfigureSeats {  

        /// Indicates whether the front left seat should be preconditioned. If this is the driver seat and set to false, all other seats must be false as well
        let frontLeft: Bool

        /// Indicates whether the front right seat should be preconditioned. If this is the driver seat and set to false, all other seats must be false as well.
        let frontRight: Bool

        /// Indicates whether the rear left seat should be preconditioned. If true, all other seats must be true as well
        let rearLeft: Bool

        /// Indicates whether the rear right seat should be preconditioned. If true, all other seats must be true as well
        let rearRight: Bool

        public init(frontLeft: Bool, frontRight: Bool, rearLeft: Bool, rearRight: Bool) {
        
            self.frontLeft = frontLeft
            self.frontRight = frontRight
            self.rearLeft = rearLeft
            self.rearRight = rearRight
        }
	}

	// MARK: - ZevPreconditioningStart

    /// Command for starting the preconditioning of an zev (=zero emission vehicle)
	public struct ZevPreconditioningStart {  

        /// Daytime in minutes after midnight. E.g. valid value for 8 am would be 480. Value range is 0 to 1439.
        let departureTime: Int

        /// The type of preconditioning to start
        let type: PreconditioningType

        public init(departureTime: Int, type: PreconditioningType) {
        
            self.departureTime = departureTime
            self.type = type
        }
	}

	// MARK: - ZevPreconditioningStop

    /// Command for stopping the preconditioning of an zev (=zero emission vehicle)
	public struct ZevPreconditioningStop {  

        /// The type of preconditioning to stop
        let type: PreconditioningType

        public init(type: PreconditioningType) {
        
            self.type = type
        }
	}
}

// swiftlint:enable all

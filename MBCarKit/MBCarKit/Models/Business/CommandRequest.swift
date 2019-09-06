//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import SwiftProtobuf
import MBCommonKit

// swiftlint:disable function_body_length

// MARK: - CommandRequest

/// Representation of a command request
@available(*, deprecated, message: "Use CommandVehicleApiRequest instead.")
public class CommandRequest: NSObject {
	
	public enum `Type` {
		case auxheatConfigure(time1: Int?, time2: Int?, time3: Int?, timeSelection: AuxheatTimeSelectionState?)
		case auxheatStart
		case auxheatStop
		case doorsLock
		case doorsUnlock
		case engineStart
		case engineStop
		case sunroofClose
		case sunroofLift
		case sunroofOpen
		case windowsClose
		case windowsOpen
		
		
		fileprivate var needsPin: Bool {
			switch self {
			case .auxheatConfigure:		return false
			case .auxheatStart:			return false
			case .auxheatStop:			return false
			case .doorsLock:			return false
			case .doorsUnlock:			return true
			case .engineStart:			return true
			case .engineStop:			return false
			case .sunroofClose:			return false
			case .sunroofLift:			return false
			case .sunroofOpen:			return true
			case .windowsClose:			return false
			case .windowsOpen:			return true
			}
		}
	}
	
	// MARK: - Properties
	public var pinProvider: PinProviding?
	private (set) var type: Type
	
	
	// MARK: - Init
	
	public init(type: Type) {
		self.type = type
	}
	
	
	// MARK: - Methods
	
	func create(complete: @escaping (Proto_CommandRequest) -> Void, onCancel: @escaping () -> Void) {
		
		self.getPin(complete: { (pin) in
			
			var commandRequest = self.commandRequest

			switch self.type {
			case .auxheatConfigure(let time1, let time2, let time3, let timeSelection):
                MBTrackingManager.track(event: MyCarTrackingEvent.configureAuxHeat(fin: commandRequest.vin, state: CommandStateType.created, condition: CommandConditionType.none))
				commandRequest.auxheatConfigure = self.auxheatConfigure(time1: time1, time2: time2, time3: time3, timeSelection: timeSelection?.toInt)
				
			case .auxheatStart:
                MBTrackingManager.track(event: MyCarTrackingEvent.startAuxHeat(fin: commandRequest.vin, state: CommandStateType.created, condition: CommandConditionType.none))
				commandRequest.auxheatStart = Proto_AuxheatStart()
				
			case .auxheatStop:
                MBTrackingManager.track(event: MyCarTrackingEvent.stopAuxHeat(fin: commandRequest.vin, state: CommandStateType.created, condition: CommandConditionType.none))
				commandRequest.auxheatStop = Proto_AuxheatStop()
				
			case .doorsLock:
                MBTrackingManager.track(event: MyCarTrackingEvent.doorLock(fin: commandRequest.vin, state: CommandStateType.created, condition: CommandConditionType.none))
				commandRequest.doorsLock = Proto_DoorsLock()
				
			case .doorsUnlock:
                MBTrackingManager.track(event: MyCarTrackingEvent.doorUnlock(fin: commandRequest.vin, state: CommandStateType.created, condition: CommandConditionType.none))
				commandRequest.doorsUnlock = self.doorsUnlock(pin: pin)
				
			case .engineStart:
                MBTrackingManager.track(event: MyCarTrackingEvent.engineStart(fin: commandRequest.vin, state: CommandStateType.created, condition: CommandConditionType.none))
				commandRequest.engineStart = self.engineStart(pin: pin)
				
			case .engineStop:
                MBTrackingManager.track(event: MyCarTrackingEvent.engineStop(fin: commandRequest.vin, state: CommandStateType.created, condition: CommandConditionType.none))
				commandRequest.engineStop = Proto_EngineStop()
				
			case .sunroofClose:
                MBTrackingManager.track(event: MyCarTrackingEvent.closeSunroof(fin: commandRequest.vin, state: CommandStateType.created, condition: CommandConditionType.none))
				commandRequest.sunroofClose = Proto_SunroofClose()
				
			case .sunroofLift:
                MBTrackingManager.track(event: MyCarTrackingEvent.liftSunroof(fin: commandRequest.vin, state: CommandStateType.created, condition: CommandConditionType.none))
				commandRequest.sunroofLift = Proto_SunroofLift()
				
			case .sunroofOpen:
                MBTrackingManager.track(event: MyCarTrackingEvent.openSunroof(fin: commandRequest.vin, state: CommandStateType.created, condition: CommandConditionType.none))
				commandRequest.sunroofOpen = self.sunroofOpen(pin: pin)
				
			case .windowsClose:
                MBTrackingManager.track(event: MyCarTrackingEvent.closeWindow(fin: commandRequest.vin, state: CommandStateType.created, condition: CommandConditionType.none))
				commandRequest.windowsClose = Proto_WindowsClose()
				
			case .windowsOpen:
                MBTrackingManager.track(event: MyCarTrackingEvent.openWindow(fin: commandRequest.vin, state: CommandStateType.created, condition: CommandConditionType.none))
				commandRequest.windowsOpen = self.windowsOpen(pin: pin)
			}
			
			complete(commandRequest)
		}, onCancel: onCancel)
	}
	
	
	// MARK: - Helper
	
	private var commandRequest: Proto_CommandRequest {
		return Proto_CommandRequest.with {
			
			$0.backend   = .vva
			$0.requestID = UUID().uuidString
			$0.vin       = DatabaseService.selectedFinOrVin
		}
	}
	
	private func getPin(complete: @escaping PinProviding.PinProvidingCompletion, onCancel: @escaping PinProviding.CancelPinProvidingCompletion) {
		
		guard self.type.needsPin else {
			complete("")
			return
		}
		
		let provider: PinProviding? = self.pinProvider ?? MBCarKit.pinProvider
		guard let pinProvider = provider else {
			fatalError("This command needs a pin provider. Please implement the pin provider protocol before.")
		}

        pinProvider.requestPin(forReason: nil, preventFromUsageAlert: false, onSuccess: { (pin) in
			complete(pin)
		}, onCancel: onCancel)
	}
	
	
	// MARK: - Commands
	
	private func auxheatConfigure(time1: Int?, time2: Int?, time3: Int?, timeSelection: Int?) -> Proto_AuxheatConfigure {
		return Proto_AuxheatConfigure.with {
			
			if let time1 = time1 {
				$0.time1 = Int32(time1)
			}
			
			if let time2 = time2 {
				$0.time2 = Int32(time2)
			}
			
			if let time3 = time3 {
				$0.time3 = Int32(time3)
			}
			
			if let timeSelection = timeSelection,
				let protoSelection = Proto_AuxheatConfigure.Selection(rawValue: timeSelection) {
				$0.timeSelection = protoSelection
			}
		}
	}
	
	private func doorsUnlock(pin: String) -> Proto_DoorsUnlock {
		return Proto_DoorsUnlock.with {
			$0.pin = pin
		}
	}
	
	private func engineStart(pin: String) -> Proto_EngineStart {
		return Proto_EngineStart.with {
			$0.pin = pin
		}
	}
	
	private func sunroofOpen(pin: String) -> Proto_SunroofOpen {
		return Proto_SunroofOpen.with {
			$0.pin = pin
		}
	}
	
	private func windowsOpen(pin: String) -> Proto_WindowsOpen {
		return Proto_WindowsOpen.with {
			$0.pin = pin
		}
	}
}


// MARK: - CommandVehicleApiRequest

/// Representation of a vehicle api based command request
public class CommandVehicleApiRequest: NSObject {
	
	public enum `Type` {
		case auxheatConfigure(time1: Int?, time2: Int?, time3: Int?, timeSelection: AuxheatTimeSelectionState?)
		case auxheatStart
		case auxheatStop
		case batteryCharge(program: BatteryChargeProgram)
		case batteryMaxSoc(value: Int)
		case chargeOptimizationConfigure(weekdays: [TariffModel], weekends: [TariffModel])
		case chargeOptimizationStart
		case chargeOptimizationStop
		case doorsLock
		case doorsUnlock
		case engineStart
		case engineStop
        case sigposStart(hornRepeat: Int, hornType: HornType, lightType: LightType, duration: Int, sigposType: SigposType)
		case speedAlertStart(alertEndTime: Int, thresholdValue: Int)
		case speedAlertStop
		case sunroofClose
		case sunroofLift
		case sunroofOpen
		case temperatureConfigure(temperaturePoints: [TemperaturePointModel])
		case theftAlarmConfirmDamageDetection
		case theftAlarmDeselectDamageDetection
		case theftAlarmDeselectInterior
		case theftAlarmDeselectTow
		case theftAlarmSelectDamageDetection
		case theftAlarmSelectInterior
		case theftAlarmSelectTow
		case theftAlarmStart(durationTimeInSeconds: Int)
		case theftAlarmStop
		case weekProfileConfigure(dayTimes: [DayTimeModel])
		case windowsClose
		case windowsOpen
		case zevPreconditioningConfigure(departureTime: Int, departureTimeMode: DepartureTimeModeConfiguration)
		case zevPreconditioningConfigureSeats(frontLeft: Bool, frontRight: Bool, rearLeft: Bool, rearRight: Bool)
		case zevPreconditioningStart(departureTime: Int, type: PreconditioningType)
		case zevPreconditioningStop(type: PreconditioningType)
		
		
		fileprivate var needsPin: Bool {
			switch self {
			case .auxheatConfigure:						return false
			case .auxheatStart:							return false
			case .auxheatStop:							return false
			case .batteryCharge:						return false
			case .batteryMaxSoc:						return false
			case .chargeOptimizationConfigure:			return false
			case .chargeOptimizationStart:				return false
			case .chargeOptimizationStop:				return false
			case .doorsLock:							return false
			case .doorsUnlock:							return true
			case .engineStart:							return true
			case .engineStop:							return false
			case .sigposStart:                      	return false
			case .speedAlertStart:         				return false
			case .speedAlertStop:           			return false
			case .sunroofClose:							return false
			case .sunroofLift:							return false
			case .sunroofOpen:							return true
			case .temperatureConfigure:					return false
			case .theftAlarmConfirmDamageDetection:		return false
			case .theftAlarmDeselectDamageDetection:	return false
			case .theftAlarmDeselectInterior:			return false
			case .theftAlarmDeselectTow:				return false
			case .theftAlarmSelectDamageDetection:		return false
			case .theftAlarmSelectInterior:				return false
			case .theftAlarmSelectTow:					return false
			case .theftAlarmStart:						return false
			case .theftAlarmStop:						return false
			case .weekProfileConfigure:					return false
			case .windowsClose:							return false
			case .windowsOpen:							return true
			case .zevPreconditioningConfigure:			return false
			case .zevPreconditioningConfigureSeats:		return false
			case .zevPreconditioningStart:				return false
			case .zevPreconditioningStop:				return false
			}
		}
	}
	
	// MARK: - Properties
	public var pinProvider: PinProviding?
	private (set) var type: Type
	
	
	// MARK: - Init
	
	public init(type: Type) {
		self.type = type
	}
	
	
	// MARK: - Methods
	
    func create(complete: @escaping (Proto_CommandRequest) -> Void, onCancel: @escaping () -> Void) {
        
		self.getPin(complete: { (pin) in
			
			var commandRequest = self.commandRequest
			switch self.type {
			case .auxheatConfigure(let time1, let time2, let time3, let timeSelection):
				MBTrackingManager.track(event: MyCarTrackingEvent.configureAuxHeat(fin: commandRequest.vin, state: CommandStateType.created, condition: CommandConditionType.none))
				commandRequest.auxheatConfigure = self.auxheatConfigure(time1: time1, time2: time2, time3: time3, timeSelection: timeSelection?.toInt)
				
			case .auxheatStart:
				MBTrackingManager.track(event: MyCarTrackingEvent.startAuxHeat(fin: commandRequest.vin, state: CommandStateType.created, condition: CommandConditionType.none))
				commandRequest.auxheatStart = Proto_AuxheatStart()
				
			case .auxheatStop:
				MBTrackingManager.track(event: MyCarTrackingEvent.stopAuxHeat(fin: commandRequest.vin, state: CommandStateType.created, condition: CommandConditionType.none))
				commandRequest.auxheatStop = Proto_AuxheatStop()
				
			case .batteryCharge(let program):
				commandRequest.batteryChargeProgram = self.batteryCharge(program: program.rawValue)
				
			case .batteryMaxSoc(let value):
				commandRequest.batteryMaxSoc = self.batteryMaxSoc(value: value)
				
			case .chargeOptimizationConfigure(let weekdays, let weekends):
				commandRequest.chargeOptConfigure = self.chargeOptimizationConfigure(weekdays: weekdays, weekends: weekends)
				
			case .chargeOptimizationStart:
				commandRequest.chargeOptStart = Proto_ChargeOptStart()
				
			case .chargeOptimizationStop:
				commandRequest.chargeOptStop = Proto_ChargeOptStop()
				
			case .doorsLock:
				MBTrackingManager.track(event: MyCarTrackingEvent.doorLock(fin: commandRequest.vin, state: CommandStateType.created, condition: CommandConditionType.none))
				commandRequest.doorsLock = Proto_DoorsLock()
				
			case .doorsUnlock:
				MBTrackingManager.track(event: MyCarTrackingEvent.doorUnlock(fin: commandRequest.vin, state: CommandStateType.created, condition: CommandConditionType.none))
				commandRequest.doorsUnlock = self.doorsUnlock(pin: pin)

			case .engineStart:
				MBTrackingManager.track(event: MyCarTrackingEvent.engineStart(fin: commandRequest.vin, state: CommandStateType.created, condition: CommandConditionType.none))
				commandRequest.engineStart = self.engineStart(pin: pin)
				
			case .engineStop:
				MBTrackingManager.track(event: MyCarTrackingEvent.engineStop(fin: commandRequest.vin, state: CommandStateType.created, condition: CommandConditionType.none))
				commandRequest.engineStop = Proto_EngineStop()
				
			case .sigposStart(let hornRepeat, let hornType, let lightType, let duration, let sigposType):
				commandRequest.sigposStart = self.sigposStart(hornRepeat: hornRepeat, hornType: hornType, lightType: lightType, duration: duration, sigposType: sigposType)

			case .speedAlertStart(let alertEndTime, let thresholdValue):
				commandRequest.speedalertStart = self.speedAlertStart(alertEndTime: alertEndTime, thresholdValue: thresholdValue)
				
			case .speedAlertStop:
				commandRequest.speedalertStop = Proto_SpeedalertStop()
				
			case .sunroofClose:
				MBTrackingManager.track(event: MyCarTrackingEvent.closeSunroof(fin: commandRequest.vin, state: CommandStateType.created, condition: CommandConditionType.none))
				commandRequest.sunroofClose = Proto_SunroofClose()
				
			case .sunroofLift:
				MBTrackingManager.track(event: MyCarTrackingEvent.liftSunroof(fin: commandRequest.vin, state: CommandStateType.created, condition: CommandConditionType.none))
				commandRequest.sunroofLift = Proto_SunroofLift()
				
			case .sunroofOpen:
				MBTrackingManager.track(event: MyCarTrackingEvent.openSunroof(fin: commandRequest.vin, state: CommandStateType.created, condition: CommandConditionType.none))
				commandRequest.sunroofOpen = self.sunroofOpen(pin: pin)
				
			case .temperatureConfigure(let temperaturePoints):
				commandRequest.temperatureConfigure = self.temperatureConfigure(temperaturePoints: temperaturePoints)
				
			case .theftAlarmConfirmDamageDetection:
                MBTrackingManager.track(event: MyCarTrackingEvent.theftAlarmConfirmDamageDetection(fin: commandRequest.vin, state: CommandStateType.created, condition: CommandConditionType.none))
				commandRequest.theftalarmStop = Proto_TheftalarmStop()
				
			case .theftAlarmDeselectDamageDetection:
                MBTrackingManager.track(event: MyCarTrackingEvent.theftAlarmDeselectDamageDetection(fin: commandRequest.vin, state: CommandStateType.created, condition: CommandConditionType.none))
				commandRequest.theftalarmDeselectDamagedetection = Proto_TheftalarmDeselectDamagedetection()
				
			case .theftAlarmDeselectInterior:
                MBTrackingManager.track(event: MyCarTrackingEvent.theftAlarmDeselectInterior(fin: commandRequest.vin, state: CommandStateType.created, condition: CommandConditionType.none))
				commandRequest.theftalarmDeselectInterior = Proto_TheftalarmDeselectInterior()
				
			case .theftAlarmDeselectTow:
                MBTrackingManager.track(event: MyCarTrackingEvent.theftAlarmDeselectTow(fin: commandRequest.vin, state: CommandStateType.created, condition: CommandConditionType.none))
				commandRequest.theftalarmDeselectTow = Proto_TheftalarmDeselectTow()
				
			case .theftAlarmSelectDamageDetection:
                MBTrackingManager.track(event: MyCarTrackingEvent.theftAlarmSelectDamageDetection(fin: commandRequest.vin, state: CommandStateType.created, condition: CommandConditionType.none))
				commandRequest.theftalarmSelectDamagedetection = Proto_TheftalarmSelectDamagedetection()
				
			case .theftAlarmSelectInterior:
                MBTrackingManager.track(event: MyCarTrackingEvent.theftAlarmSelectInterior(fin: commandRequest.vin, state: CommandStateType.created, condition: CommandConditionType.none))
				commandRequest.theftalarmSelectInterior = Proto_TheftalarmSelectInterior()
				
			case .theftAlarmSelectTow:
                MBTrackingManager.track(event: MyCarTrackingEvent.theftAlarmSelectTow(fin: commandRequest.vin, state: CommandStateType.created, condition: CommandConditionType.none))
				commandRequest.theftalarmSelectTow = Proto_TheftalarmSelectTow()
				
			case .theftAlarmStart(let durationTimeInSeconds):
                MBTrackingManager.track(event: MyCarTrackingEvent.theftAlarmStart(fin: commandRequest.vin, state: CommandStateType.created, condition: CommandConditionType.none))
				commandRequest.theftalarmStart = self.theftAlarmStart(durationTimeInSeconds: durationTimeInSeconds)
				
			case .theftAlarmStop:
                MBTrackingManager.track(event: MyCarTrackingEvent.theftAlarmStop(fin: commandRequest.vin, state: CommandStateType.created, condition: CommandConditionType.none))
				commandRequest.theftalarmStop = Proto_TheftalarmStop()
				
			case .weekProfileConfigure(let dayTimes):
				commandRequest.weekProfileConfigure = self.weekProfileConfigure(dayTimes: dayTimes)
				
			case .windowsClose:
				MBTrackingManager.track(event: MyCarTrackingEvent.closeWindow(fin: commandRequest.vin, state: CommandStateType.created, condition: CommandConditionType.none))
				commandRequest.windowsClose = Proto_WindowsClose()
				
			case .windowsOpen:
				MBTrackingManager.track(event: MyCarTrackingEvent.openWindow(fin: commandRequest.vin, state: CommandStateType.created, condition: CommandConditionType.none))
				commandRequest.windowsOpen = self.windowsOpen(pin: pin)
				
			case .zevPreconditioningConfigure(let departureTime, let departureTimeMode):
				commandRequest.zevPreconditionConfigure = self.zevPreconditioningConfigure(departureTime: departureTime, departureTimeMode: departureTimeMode.rawValue)
				
			case .zevPreconditioningConfigureSeats(let frontLeft, let frontRight, let rearLeft, let rearRight):
				commandRequest.zevPreconditionConfigureSeats = self.zevPreconditioningConfigureSeats(frontLeft: frontLeft, frontRight: frontRight, rearLeft: rearLeft, rearRight: rearRight)
				
			case .zevPreconditioningStart(let departureTime, let type):
				commandRequest.zevPreconditioningStart = self.zevPreconditioningStart(departureTime: departureTime, type: type.rawValue)
				
			case .zevPreconditioningStop(let type):
				commandRequest.zevPreconditioningStop = self.zevPreconditioningStop(type: type.rawValue)
			}
			
			complete(commandRequest)
		}, onCancel: onCancel)
    }
}

// MARK: - Extension

extension CommandVehicleApiRequest {
	
	private var commandRequest: Proto_CommandRequest {
		return Proto_CommandRequest.with {
			
			$0.backend   = .vehicleApi
			$0.requestID = UUID().uuidString
			$0.vin       = DatabaseService.selectedFinOrVin
		}
	}
	
	private func getPin(complete: @escaping PinProviding.PinProvidingCompletion, onCancel: @escaping PinProviding.CancelPinProvidingCompletion) {
		
		guard self.type.needsPin else {
			complete("")
			return
		}
		
		let provider: PinProviding? = self.pinProvider ?? MBCarKit.pinProvider
		guard let pinProvider = provider else {
			fatalError("This command needs a pin provider. Please implement the pin provider protocol before.")
		}
		
		pinProvider.requestPin(forReason: nil, preventFromUsageAlert: false, onSuccess: { (pin) in
			complete(pin)
		}, onCancel: onCancel)
	}
	
	
	// MAKR: - Commands
	
	private func auxheatConfigure(time1: Int?, time2: Int?, time3: Int?, timeSelection: Int?) -> Proto_AuxheatConfigure {
		return Proto_AuxheatConfigure.with {
			
			if let time1 = time1 {
				$0.time1 = Int32(time1)
			}
			
			if let time2 = time2 {
				$0.time2 = Int32(time2)
			}
			
			if let time3 = time3 {
				$0.time3 = Int32(time3)
			}
			
			if let timeSelection = timeSelection,
				let protoSelection = Proto_AuxheatConfigure.Selection(rawValue: timeSelection) {
				$0.timeSelection = protoSelection
			}
		}
	}
	
	private func batteryCharge(program: Int) -> Proto_BatteryChargeProgramConfigure {
		return Proto_BatteryChargeProgramConfigure.with {
			$0.chargeProgram = Proto_BatteryChargeProgramConfigure.ChargeProgram(rawValue: program) ?? .default
		}
	}
	
	private func batteryMaxSoc(value: Int) -> Proto_BatteryMaxSocConfigure {
		return Proto_BatteryMaxSocConfigure.with {
			$0.maxSoc = Int32(value)
		}
	}
	
	private func chargeOptimizationConfigure(weekdays: [TariffModel], weekends: [TariffModel]) -> Proto_ChargeOptConfigure {
		return Proto_ChargeOptConfigure.with {
			
			$0.weekdayTariff = weekdays.compactMap { (tariffModel) -> Proto_ChargeOptConfigure.Tariff? in
				
				guard let rate = Proto_ChargeOptConfigure.Tariff.Rate(rawValue: tariffModel.rate.rawValue) else {
					return nil
				}
				
				return Proto_ChargeOptConfigure.Tariff.with {
					
					$0.rate = rate
					$0.time = Int32(tariffModel.time)
				}
			}
			
			$0.weekendTariff = weekends.compactMap { (tariffModel) -> Proto_ChargeOptConfigure.Tariff? in
				
				guard let rate = Proto_ChargeOptConfigure.Tariff.Rate(rawValue: tariffModel.rate.rawValue) else {
					return nil
				}
				
				return Proto_ChargeOptConfigure.Tariff.with {
					
					$0.rate = rate
					$0.time = Int32(tariffModel.time)
				}
			}
		}
	}
	
	private func doorsUnlock(pin: String) -> Proto_DoorsUnlock {
		return Proto_DoorsUnlock.with {
			$0.pin = pin
		}
	}
	
	private func engineStart(pin: String) -> Proto_EngineStart {
		return Proto_EngineStart.with {
			$0.pin = pin
		}
	}
	
    private func sigposStart(hornRepeat: Int, hornType: HornType, lightType: LightType, duration: Int, sigposType: SigposType) -> Proto_SigPosStart {
        return Proto_SigPosStart.with {
			
            $0.hornRepeat = Int32(hornRepeat)
            $0.hornType = Proto_SigPosStart.HornType(rawValue: hornType.rawValue) ?? .hornOff
            $0.lightType = Proto_SigPosStart.LightType(rawValue: lightType.rawValue) ?? .dippedHeadLight
            $0.sigposDuration = Int32(duration)
            $0.sigposType = Proto_SigPosStart.SigposType(rawValue: sigposType.rawValue) ?? .lightOnly
        }
    }

	private func speedAlertStart(alertEndTime: Int, thresholdValue: Int) -> Proto_SpeedalertStart {
		return Proto_SpeedalertStart.with {
			
			$0.alertEndTime = Int32(alertEndTime)
			$0.threshold    = Int32(thresholdValue)
		}
	}
	
	private func sunroofOpen(pin: String) -> Proto_SunroofOpen {
		return Proto_SunroofOpen.with {
			$0.pin = pin
		}
	}
	
	private func temperatureConfigure(temperaturePoints: [TemperaturePointModel]) -> Proto_TemperatureConfigure {
		return Proto_TemperatureConfigure.with {
			$0.temperaturePoints = temperaturePoints.map { (temperaturePoint) -> Proto_TemperatureConfigure.TemperaturePoint in
				
				let zone: Proto_TemperatureConfigure.TemperaturePoint.Zone = {
					switch temperaturePoint.zone {
					case .frontCenter:	return .frontCenter
					case .frontLeft:	return .frontLeft
					case .frontRight:	return .frontRight
					case .rear2center:	return .rear2Center
					case .rear2left:	return .rear2Left
					case .rear2right:	return .rear2Right
					case .rearCenter:	return .rearCenter
					case .rearLeft:		return .rearLeft
					case .rearRight:	return .rearRight
					}
				}()
				
				return Proto_TemperatureConfigure.TemperaturePoint.with {
					
					$0.temperature = Int32(temperaturePoint.temperature)
					$0.zone        = zone
				}
			}
		}
	}
	
	private func theftAlarmStart(durationTimeInSeconds: Int) -> Proto_TheftalarmStart {
		return Proto_TheftalarmStart.with {
			$0.alarmDurationInSeconds = Int32(durationTimeInSeconds)
		}
	}
	
	private func weekProfileConfigure(dayTimes: [DayTimeModel]) -> Proto_WeekProfileConfigure {
		return Proto_WeekProfileConfigure.with {
			$0.weeklySetHu = dayTimes.compactMap { (dayTimeModel) -> Proto_WeekProfileConfigure.WeeklySetHU? in
				
				guard let day = Proto_WeekProfileConfigure.WeeklySetHU.Day(rawValue: dayTimeModel.day.rawValue) else {
					return nil
				}
				
				return Proto_WeekProfileConfigure.WeeklySetHU.with {
					
					$0.day  = day
					$0.time = Int32(dayTimeModel.time)
				}
			}
		}
	}
	
	private func windowsOpen(pin: String) -> Proto_WindowsOpen {
		return Proto_WindowsOpen.with {
			$0.pin = pin
		}
	}
	
	private func zevPreconditioningConfigure(departureTime: Int, departureTimeMode: Int) -> Proto_ZEVPreconditioningConfigure {
		return Proto_ZEVPreconditioningConfigure.with {
			
			$0.departureTime     = Int32(departureTime)
			$0.departureTimeMode = Proto_ZEVPreconditioningConfigure.DepartureTimeMode(rawValue: departureTimeMode) ?? .disabled
		}
	}
	
	private func zevPreconditioningConfigureSeats(frontLeft: Bool, frontRight: Bool, rearLeft: Bool, rearRight: Bool) -> Proto_ZEVPreconditioningConfigureSeats {
		return Proto_ZEVPreconditioningConfigureSeats.with {
			
			$0.frontLeft  = frontLeft
			$0.frontRight = frontRight
			$0.rearLeft   = rearLeft
			$0.rearRight  = rearRight
		}
	}
	
	private func zevPreconditioningStart(departureTime: Int, type: Int) -> Proto_ZEVPreconditioningStart {
		return Proto_ZEVPreconditioningStart.with {
			
			$0.departureTime = Int32(departureTime)
			$0.type          = Proto_ZEVPreconditioningType(rawValue: type) ?? .unknownZevPreconditioningCommandType
		}
	}
	
	private func zevPreconditioningStop(type: Int) -> Proto_ZEVPreconditioningStop {
		return Proto_ZEVPreconditioningStop.with {
			$0.type = Proto_ZEVPreconditioningType(rawValue: type) ?? .unknownZevPreconditioningCommandType
		}
	}
}

// swiftlint:enable function_body_length

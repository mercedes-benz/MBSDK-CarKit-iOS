//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation


extension Command.AuxHeatConfigure: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		
		commandRequest.auxheatConfigure = Proto_AuxheatConfigure.with {
			
			$0.time1 = Int32(time1)
			$0.time2 = Int32(time2)
			$0.time3 = Int32(time3)
			$0.timeSelection = timeSelection.proto()
		}
	}
}

extension Command.AuxHeatStart: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.auxheatStart = Proto_AuxheatStart()
	}
}

extension Command.AuxHeatStop: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.auxheatStop = Proto_AuxheatStop()
	}
}

extension Command.BatteryMaxStateOfChargeConfigure: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.batteryMaxSoc = Proto_BatteryMaxSocConfigure.with {
			$0.maxSoc = Int32(self.maxStateOfCharge)
		}
	}
}

extension Command.ChargeOptimizationConfigure: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.chargeOptConfigure = Proto_ChargeOptConfigure.with {
			
			$0.weekdayTariff = self.weekdays.compactMap { $0.proto() }
			$0.weekendTariff = self.weekends.compactMap { $0.proto() }
		}
	}
}


extension Command.ChargeOptimizationStart: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.chargeOptStart = Proto_ChargeOptStart()
	}
}

extension Command.ChargeOptimizationStop: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.chargeOptStop = Proto_ChargeOptStop()
	}
}

extension Command.DoorsLock: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.doorsLock = Proto_DoorsLock()
	}
}

extension Command.DoorsUnlock: CommandPinSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest, pin: String) {
		commandRequest.doorsUnlock = Proto_DoorsUnlock.with {
			$0.pin = pin
		}
	}
}

extension Command.EngineStart: CommandPinSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest, pin: String) {
		commandRequest.engineStart = Proto_EngineStart.with {
			$0.pin = pin
		}
	}
}

extension Command.EngineStop: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.engineStop = Proto_EngineStop()
	}
}

extension Command.SignalPosition: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.sigposStart = Proto_SigPosStart.with {
			$0.hornRepeat = Int32(self.hornRepeat)
			$0.hornType = self.hornType.proto()
			$0.lightType = self.lightType.proto()
			$0.sigposType = self.sigPosType.proto()
		}
	}
}

extension Command.SpeedAlertStart: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.speedalertStart = Proto_SpeedalertStart.with {
			$0.alertEndTime = Int32(self.alertEndTime)
			$0.threshold = Int32(self.threshold)
		}
	}
}

extension Command.SpeedAlertStop: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.speedalertStop = Proto_SpeedalertStop()
	}
}

extension Command.SunroofClose: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.sunroofClose = Proto_SunroofClose()
	}
}

extension Command.SunroofLift: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.sunroofLift = Proto_SunroofLift()
	}
}

extension Command.SunroofOpen: CommandPinSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest, pin: String) {
		commandRequest.sunroofOpen = Proto_SunroofOpen.with {
			$0.pin = pin
		}
	}
}

extension Command.TemperatureConfigure: CommandSerializable {
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.temperatureConfigure = Proto_TemperatureConfigure.with {
			$0.temperaturePoints = self.temperaturePoints.compactMap { $0.proto() }
		}
	}
}

extension Command.TheftAlarmConfirmDamageDetection: CommandPinSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest, pin: String) {
		commandRequest.theftalarmConfirmDamagedetection = Proto_TheftalarmConfirmDamagedetection()
	}
}

extension Command.TheftAlarmDeselectDamageDetection: CommandPinSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest, pin: String) {
		commandRequest.theftalarmDeselectDamagedetection = Proto_TheftalarmDeselectDamagedetection()
	}
}

extension Command.TheftAlarmDeselectInterior: CommandPinSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest, pin: String) {
		commandRequest.theftalarmDeselectInterior = Proto_TheftalarmDeselectInterior()
	}
}

extension Command.TheftAlarmDeselectTow: CommandPinSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest, pin: String) {
		commandRequest.theftalarmDeselectTow = Proto_TheftalarmDeselectTow()
	}
}

extension Command.TheftAlarmSelectDamageDetection: CommandPinSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest, pin: String) {
		commandRequest.theftalarmSelectDamagedetection = Proto_TheftalarmSelectDamagedetection()
	}
}

extension Command.TheftAlarmSelectInterior: CommandPinSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest, pin: String) {
		commandRequest.theftalarmSelectInterior = Proto_TheftalarmSelectInterior()
	}
}

extension Command.TheftAlarmSelectTow: CommandPinSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest, pin: String) {
		commandRequest.theftalarmSelectTow = Proto_TheftalarmSelectTow()
	}
}

extension Command.TheftAlarmStart: CommandPinSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest, pin: String) {
		commandRequest.theftalarmStart = Proto_TheftalarmStart.with {
			$0.alarmDurationInSeconds = Int32(self.durationInSeconds)
		}
	}
}

extension Command.TheftAlarmStop: CommandPinSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest, pin: String) {
		commandRequest.theftalarmStop = Proto_TheftalarmStop()
	}
}

extension Command.WeekProfileConfigure: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.weekProfileConfigure = Proto_WeekProfileConfigure.with {
			$0.weeklySetHu = self.dayTimes.compactMap { $0.proto() }
		}
	}
}

extension Command.WindowsClose: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.windowsClose = Proto_WindowsClose()
	}
}

extension Command.WindowsOpen: CommandPinSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest, pin: String) {
		commandRequest.windowsOpen = Proto_WindowsOpen.with {
			$0.pin = pin
		}
	}
}

extension Command.ZevPreconditioningConfigure: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.zevPreconditionConfigure = Proto_ZEVPreconditioningConfigure.with {
			
			if self.departureTimeMode != .weekly {
				$0.departureTime = Int32(self.departureTime)
			}
			
			$0.departureTimeMode = self.departureTimeMode.proto()
		}
	}
}

extension Command.ZevPreconditioningConfigureSeats: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.zevPreconditionConfigureSeats = Proto_ZEVPreconditioningConfigureSeats.with {
			$0.frontLeft = self.frontLeft
			$0.frontRight = self.frontRight
			$0.rearLeft = self.rearLeft
			$0.rearRight = self.rearRight
		}
	}
}

extension Command.ZevPreconditioningStart: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.zevPreconditioningStart = Proto_ZEVPreconditioningStart.with {
			$0.departureTime = Int32(self.departureTime)
			$0.type = self.type.proto()
		}
	}
}

extension Command.ZevPreconditioningStop: CommandSerializable {
	
	func populate(commandRequest: inout Proto_CommandRequest) {
		commandRequest.zevPreconditioningStop = Proto_ZEVPreconditioningStop.with {
			$0.type = self.type.proto()
		}
	}
}

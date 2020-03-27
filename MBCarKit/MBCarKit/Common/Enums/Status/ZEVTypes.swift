//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - BatteryChargeProgram

/// State for battery charging program

public enum BatteryChargeProgram: Int, CaseIterable {
	case `default` = 0
	case instant = 1
}

// MARK: - ChargingError

/// State for charging error attribute
public enum ChargingError: Int, CaseIterable {
	case none = 0
	case cable = 1
	case chargingDisorder = 2
	case chargingStation = 3
	case chargingType = 4
}

extension ChargingError {
	
	public var toString: String {
		switch self {
		case .cable:			return "cable"
		case .chargingDisorder:	return "charging disorder"
		case .chargingStation:	return "charging station"
		case .chargingType:		return "charging type"
		case .none:				return "no message"
		}
	}
}


// MARK: - ChargingMode

/// State for charging mode attribute
public enum ChargingMode: Int, CaseIterable {
	case none = 0
	case conductiveAC = 1
	case inductive = 2
	case conductiveACInductive = 3
	case conductiveDC = 4
}

extension ChargingMode {
	
	public var toString: String {
		switch self {
		case .conductiveAC:				return "conductive ac"
		case .conductiveACInductive:	return "conductive ac + inductive"
		case .conductiveDC:				return "conductive dc"
		case .inductive:				return "inductive"
		case .none:						return "none"
		}
	}
}


// MARK: - ChargingProgram

/// State for charging program attribute
public enum ChargingProgram: Int, CaseIterable {
	case `default` = 0
	case ìnstant = 1
	case home = 2
	case work = 3
}

extension ChargingProgram {
	
	public var toString: String {
		switch self {
		case .`default`:	return "default"
		case .home:			return "home"
		case .ìnstant:		return "instant"
		case .work:			return "work"
		}
	}
}


// MARK: - ChargingStatus

/// State for charging status attribute
public enum ChargingStatus: Int, CaseIterable {
	case charging = 0
	case chargingEnds = 1
	case chargeBreak = 2
	case unplugged = 3
	case failure = 4
	case slow = 5
	case fast = 6
	case discharging = 7
}

extension ChargingStatus {
	
	public var toString: String {
		switch self {
		case .chargeBreak:	return "charge break"
		case .charging:		return "charging"
		case .chargingEnds:	return "end of charge"
		case .discharging:	return "discharging"
		case .failure:		return "charging failure"
		case .fast:			return "fast charging"
		case .slow:			return "slow charging"
		case .unplugged:	return "charge cable unplugged"
		}
	}
}


// MARK: - Day

/// State for day
public enum Day: Int, CaseIterable, Encodable, Decodable {
	case monday = 0
	case tuesday = 1
	case wednesday = 2
	case thursday = 3
	case friday = 4
	case saturday = 5
	case sunday = 6
}

extension Day {
	
	public var toString: String {
		switch self {
		case .friday:		return "Friday"
		case .monday:		return "Monday"
		case .saturday:		return "Saturday"
		case .sunday:		return "Sunday"
		case .thursday:		return "Thursday"
		case .tuesday:		return "Tuesday"
		case .wednesday:	return "Wednesday"
		}
	}
    
    public static func mapShifftedMinusOneDay(_ day: Int) -> Day? {

        let shifftedDay = day - 1
        return Day(rawValue: shifftedDay)
    }
    
    public func mapShifteddPlusOneDay() -> Int {
        
        return self.rawValue + 1
    }
}


// MARK: - DepartureTimeMode

/// State for departure time mode for zev
public enum DepartureTimeMode: Int, CaseIterable {
	case inactive = 0
	case active = 1
	case weekly = 2
}

extension DepartureTimeMode {
	
	public var toString: String {
		switch self {
		case .active:	return "adhoc active"
		case .inactive:	return "inactive"
		case .weekly:	return "weeklyset active"
		}
	}
}


// MARK: - DepartureTimeModeConfiguration

/// State for departure time mode for preconditioning configuration
public enum DepartureTimeModeConfiguration: Int, CaseIterable {
	case disabled = 0
	case single = 1
	case weekly = 2
}

/// State for departure time mode for preconditioning configuration
public enum DepartureTimeConfiguration: Int, CaseIterable {
	case disabled = 0
	case once = 1
	case weekly = 2
}

// MARK: - HybridWarningState

/// State for hybrid warning state
public enum HybridWarningState: Int, CaseIterable {
	case none = 0
	case seekServiceWithoutEngineStop = 1
	case highVoltagePowernetFault = 2
	case powertrainFault = 3
	case starterBattery = 4
	case stopVehicleChargeBattery = 5
	case pluginOnlyEmodePossible = 6
	case pluginVehicleStillActive = 7
	case powerReduce = 8
	case stopEngineOff = 9
}

extension HybridWarningState {
	
	public var toString: String {
		switch self {
		case .highVoltagePowernetFault:		return "high voltage powernet fault"
		case .none:							return "no request"
		case .pluginOnlyEmodePossible:		return "plugin: only e-mode possible"
		case .pluginVehicleStillActive:		return "plugin: vehicle still active"
		case .powerReduce:					return "power reduced"
		case .powertrainFault:				return "powertrain fault"
		case .seekServiceWithoutEngineStop:	return "seek service without engine stop"
		case .starterBattery:				return "starter battery"
		case .stopEngineOff:				return "stop, engine off"
		case .stopVehicleChargeBattery:		return "stop vehicle and charge battery"
		}
	}
}


// MARK: - PrecondError

/// State for the zev preconditioning error
public enum PrecondError: Int, CaseIterable {
	case noRequest = 0
	case batteryFuelLow = 1
	case restartEngine = 2
	case notFinished = 3
	case general = 4
}

extension PrecondError {
	
	public var toString: String {
		switch self {
		case .batteryFuelLow:	return "battery or fuel low"
		case .general:			return "general error"
		case .noRequest:		return "no request"
		case .notFinished:		return "not possible, charging not finished"
		case .restartEngine:	return "available after restart engine"
		}
	}
}

// MARK: - PreconditioningType

/// State for the zev preconditioning command
public enum PreconditioningType: Int, CaseIterable {
	case unknown = 0
	case immediate = 1
	case departure = 2
	case now = 3
	case departureWeekly = 4
}

// MARK: - SmartCharging

/// State for smart charging
public enum SmartCharging: Int, CaseIterable {
	case wallbox = 0
	case smartCharge = 1
	case peakSetting = 2
}

extension SmartCharging {
	
	public var toString: String {
		switch self {
		case .peakSetting:	return "peak setting"
		case .smartCharge:	return "smart charge"
		case .wallbox:		return "wallbox"
		}
	}
}


// MARK: - SmartChargingDeparture

/// State for smart charging departure
public enum SmartChargingDeparture: Bool, CaseIterable {
	case inactive = 0
	case requested = 1
}

extension SmartChargingDeparture {
	
	public var toString: String {
		switch self {
		case .inactive:		return "inactive"
		case .requested:	return "requested"
		}
	}
}


// MARK: - TariffRate

/// State for tariff rate
public enum TariffRate: Int, CaseIterable {
	case invalidPrice = 0
	case lowPrice = 33
	case normalPrice = 44
	case highPrice = 66
}

// MARK: - TariffType

enum TariffType {
	case weekday
	case weekend
}

// THIS FILE IS GENERATED - DO NOT EDIT!
// The generator can be found at $WORKSPACE/golang/src/git.daimler.com/risingstars/commons-go-lib/gen
//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//
// swiftlint:disable all

import Foundation
import SwiftProtobuf

/// GenericCommandError represents errors that are relevant to all commands
public enum GenericCommandError: CustomStringConvertible, CommandErrorProtocol {
    
    /// Command failed. Normally, there should be additional business errors detailing what exactly went wrong
    case commandFailed
    
    /// The command is not available for the specified vehicle
    case commandUnavailable
    
    /// a general error and the `message` field of the VehicleAPIError struct should be checked for more information
    case couldNotSendCommand
    
    /// returned if the service(s) for the requested command are not active
	/// - serviceId: The id of the service which needs to be activated. 
    case inactiveServices(serviceId: Int)
    
    /// Received an invalid condition
    case invalidCondition
    
    /// Should never happen due to migration guide
    case invalidStatus
    
    /// The client does not have an internet connection and therefore the command could not be sent.
    case noInternetConnection
    
    /// No vehicle was selected
    case noVehicleSelected
    
    /// Command was overwritten in queue
    case overwritten
    
    /// The user cancelled the PIN input. The command is therefore not transmitted and not executed.
    case pinInputCancelled
    
    /// returned if the given PIN does not match the one saved in CPD
	/// - attempt: Count of the attempt to enter the valid user PIN. Will be set to zero if the user has provided a valid PIN. 
    case pinInvalid(attempt: Int)
    
    /// The pin provider was not configured, but a PIN is needed for this command.
    case pinProviderMissing
    
    /// returned if the user tried to send a sensitive command that requires a PIN but didn't provide one
    case pinRequired
    
    /// Command was rejected due to a blocked command queue. This can happen if another user is executing a similar command.
    case rejectedByQueue
    
    /// Command was forcefully terminated
    case terminated
    
    /// Failed due to timeout
    case timeout
    
    /// returned if an unknown error has occurred. Should never happen, so let us know if you see this error
	/// - message: A message which might have more details 
    case unknownError(message: String)
    
    /// The status of the command is unknown. returned if the state of a given command could not be polled. When polling for the state of a command only the last running or currently running command status is returned. If the app is interested in the status of a previous command for any reason and the state cannot be determined this error is returned
    case unknownStatus
    
    /// is returned if there was an error in polling the command state. E.g. 4xx/5xx response codes from the vehicleAPI
    case unknownStatusDueToPollError
    
    /// returned if the command request contains a command type that is not yet supported by the AppTwin
    case unsupportedCommand
    
    /// command is not supported by the currently selected stage
    case unsupportedStage
    
    /// returned if the CIAM ID is currently blocked from sending sensitive commands e.g. Doors Unlock due to too many PIN attempts
	/// - attempt: Count of the attempt to enter the valid user PIN. Will be set to zero if the user has provided a valid PIN. 
	/// - blockedUntil: Unix timestamp in seconds indicating the moment in time from when the user is allowed to try another PIN. 
    case userBlocked(attempt: Int, blockedUntil: Int)
    
    /// returned if a command request is received for a VIN that is not assigned to the ciam id of the current user
    case vehicleNotAssigned
    
	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> GenericCommandError {
	    switch code { 
        case "CMD_FAILED": return .commandFailed
        case "CMD_INVALID_CONDITION": return .invalidCondition
        case "CMD_INVALID_STATUS": return .invalidStatus
        case "CMD_OVERWRITTEN": return .overwritten
        case "CMD_REJECTED_BY_QUEUE": return .rejectedByQueue
        case "CMD_TERMINATED": return .terminated
        case "CMD_TIMEOUT": return .timeout
        case "COMMAND_UNAVAILABLE": return .commandUnavailable
        case "NO_INTERNET_CONNECTION": return .noInternetConnection
        case "NO_VEHICLE_SELECTED": return .noVehicleSelected
        case "PIN_INPUT_CANCELLED": return .pinInputCancelled
        case "PIN_PROVIDER_MISSING": return .pinProviderMissing
        case "RIS_CIAM_ID_BLOCKED": return .userBlocked(attempt: Int(attributes["attempt"]?.numberValue ?? 0), blockedUntil: Int(attributes["blocked_until"]?.numberValue ?? 0))
        case "RIS_COULD_NOT_SEND_COMMAND": return .couldNotSendCommand
        case "RIS_EMPTY_VEHICLE_API_QUEUE": return .unknownStatus
        case "RIS_FORBIDDEN_VIN": return .vehicleNotAssigned
        case "RIS_INACTIVE_SERVICES": return .inactiveServices(serviceId: Int(attributes["serviceId"]?.numberValue ?? 0))
        case "RIS_PIN_INVALID": return .pinInvalid(attempt: Int(attributes["attempt"]?.numberValue ?? 0))
        case "RIS_PIN_REQUIRED": return .pinRequired
        case "RIS_UNKNOWN_ERROR": return .unknownError(message: attributes["message"]?.stringValue ?? "")
        case "RIS_UNSUPPORTED_COMMAND": return .unsupportedCommand
        case "RIS_UNSUPPORTED_STAGE": return .unsupportedStage
        case "RIS_VEHICLE_API_POLLING": return .unknownStatusDueToPollError
        default: return .unknownError(message: message)
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		return self
	}

	public var description: String {
		switch self { 
        case .commandFailed: return "commandFailed"
        case .commandUnavailable: return "commandUnavailable"
        case .couldNotSendCommand: return "couldNotSendCommand"
        case .inactiveServices(_): return "inactiveServices"
        case .invalidCondition: return "invalidCondition"
        case .invalidStatus: return "invalidStatus"
        case .noInternetConnection: return "noInternetConnection"
        case .noVehicleSelected: return "noVehicleSelected"
        case .overwritten: return "overwritten"
        case .pinInputCancelled: return "pinInputCancelled"
        case .pinInvalid(_): return "pinInvalid"
        case .pinProviderMissing: return "pinProviderMissing"
        case .pinRequired: return "pinRequired"
        case .rejectedByQueue: return "rejectedByQueue"
        case .terminated: return "terminated"
        case .timeout: return "timeout"
        case .unknownError(_): return "unknownError"
        case .unknownStatus: return "unknownStatus"
        case .unknownStatusDueToPollError: return "unknownStatusDueToPollError"
        case .unsupportedCommand: return "unsupportedCommand"
        case .unsupportedStage: return "unsupportedStage"
        case .userBlocked(_, _): return "userBlocked"
        case .vehicleNotAssigned: return "vehicleNotAssigned"
        }
	}
}


/// All possible error codes for the AuxHeatConfigure command version v1
public enum AuxHeatConfigureError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Processing of auxheat command failed
    case auxheatCommandFailed

    /// Fastpath timeout
    case fastpathTimeout

    /// Incomplete values
    case incompleteValues

    /// NULL/INF values
    case nullOrInfiniteValues

    /// Service not authorized
    case serviceNotAuthorized

    /// Syntax error
    case syntaxError

    /// Value out of range
    case valueOutOfRange

    /// Value overflow
    case valueOverflow

    /// Wrong data type
    case wrongDataType

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> AuxHeatConfigureError {
	    switch code { 
        case "100": return .valueOutOfRange
        case "105": return .wrongDataType
        case "110": return .valueOverflow
        case "115": return .incompleteValues
        case "120": return .syntaxError
        case "125": return .nullOrInfiniteValues
        case "4061": return .auxheatCommandFailed
        case "4062": return .serviceNotAuthorized
        case "42": return .fastpathTimeout
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .auxheatCommandFailed: return "auxheatCommandFailed"
        case .fastpathTimeout: return "fastpathTimeout"
        case .incompleteValues: return "incompleteValues"
        case .nullOrInfiniteValues: return "nullOrInfiniteValues"
        case .serviceNotAuthorized: return "serviceNotAuthorized"
        case .syntaxError: return "syntaxError"
        case .valueOutOfRange: return "valueOutOfRange"
        case .valueOverflow: return "valueOverflow"
        case .wrongDataType: return "wrongDataType"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.AuxHeatConfigure: BaseCommandProtocol {

	public typealias Error = AuxHeatConfigureError

	public func createGenericError(error: GenericCommandError) -> AuxHeatConfigureError {
		return AuxHeatConfigureError.genericError(error: error)
	}
}

extension Command.AuxHeatConfigure: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the AuxHeatStart command version v1
public enum AuxHeatStartError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Processing of auxheat command failed
    case auxheatCommandFailed

    /// Fastpath timeout
    case fastpathTimeout

    /// Service not authorized
    case serviceNotAuthorized

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> AuxHeatStartError {
	    switch code { 
        case "4061": return .auxheatCommandFailed
        case "4062": return .serviceNotAuthorized
        case "42": return .fastpathTimeout
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .auxheatCommandFailed: return "auxheatCommandFailed"
        case .fastpathTimeout: return "fastpathTimeout"
        case .serviceNotAuthorized: return "serviceNotAuthorized"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.AuxHeatStart: BaseCommandProtocol {

	public typealias Error = AuxHeatStartError

	public func createGenericError(error: GenericCommandError) -> AuxHeatStartError {
		return AuxHeatStartError.genericError(error: error)
	}
}

extension Command.AuxHeatStart: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the AuxHeatStop command version v1
public enum AuxHeatStopError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Processing of auxheat command failed
    case auxheatCommandFailed

    /// Fastpath timeout
    case fastpathTimeout

    /// Service not authorized
    case serviceNotAuthorized

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> AuxHeatStopError {
	    switch code { 
        case "4061": return .auxheatCommandFailed
        case "4062": return .serviceNotAuthorized
        case "42": return .fastpathTimeout
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .auxheatCommandFailed: return "auxheatCommandFailed"
        case .fastpathTimeout: return "fastpathTimeout"
        case .serviceNotAuthorized: return "serviceNotAuthorized"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.AuxHeatStop: BaseCommandProtocol {

	public typealias Error = AuxHeatStopError

	public func createGenericError(error: GenericCommandError) -> AuxHeatStopError {
		return AuxHeatStopError.genericError(error: error)
	}
}

extension Command.AuxHeatStop: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the BatteryMaxStateOfChargeConfigure command version v1
public enum BatteryMaxStateOfChargeConfigureError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Charge Configuration failed
    case chargeConfigurationFailed

    /// Charge Configuration failed because passed max soc value is below vehicle threshold
    case chargeConfigurationFailedSocBelowTreshold

    /// Charge Configuration not authorized
    case chargeConfigurationNotAuthorized

    /// Charge Configuration not possible since INSTANT CHARGING is already activated
    case chargeConfigurationNotPossibleSinceInstantChargingIsActive

    /// Fastpath timeout
    case fastpathTimeout

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> BatteryMaxStateOfChargeConfigureError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "7401": return .chargeConfigurationFailed
        case "7402": return .chargeConfigurationFailedSocBelowTreshold
        case "7403": return .chargeConfigurationNotAuthorized
        case "7404": return .chargeConfigurationNotPossibleSinceInstantChargingIsActive
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .chargeConfigurationFailed: return "chargeConfigurationFailed"
        case .chargeConfigurationFailedSocBelowTreshold: return "chargeConfigurationFailedSocBelowTreshold"
        case .chargeConfigurationNotAuthorized: return "chargeConfigurationNotAuthorized"
        case .chargeConfigurationNotPossibleSinceInstantChargingIsActive: return "chargeConfigurationNotPossibleSinceInstantChargingIsActive"
        case .fastpathTimeout: return "fastpathTimeout"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.BatteryMaxStateOfChargeConfigure: BaseCommandProtocol {

	public typealias Error = BatteryMaxStateOfChargeConfigureError

	public func createGenericError(error: GenericCommandError) -> BatteryMaxStateOfChargeConfigureError {
		return BatteryMaxStateOfChargeConfigureError.genericError(error: error)
	}
}

extension Command.BatteryMaxStateOfChargeConfigure: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the ChargeOptimizationConfigure command version v1
public enum ChargeOptimizationConfigureError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Charge optimization failed
    case chargeOptimizationFailed

    /// Charge optimization not authorized
    case chargeOptimizationNotAuthorized

    /// Charge optimization not possible since either INSTANT CHARGING is already activated or INSTANT CHARGING ACP command is currently in progress
    case chargeOptimizationNotPossible

    /// Charge optimization overwritten
    case chargeOptimizationOverwritten

    /// Fastpath timeout
    case fastpathTimeout

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> ChargeOptimizationConfigureError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "5015": return .chargeOptimizationFailed
        case "5016": return .chargeOptimizationOverwritten
        case "5017": return .chargeOptimizationNotAuthorized
        case "5018": return .chargeOptimizationNotPossible
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .chargeOptimizationFailed: return "chargeOptimizationFailed"
        case .chargeOptimizationNotAuthorized: return "chargeOptimizationNotAuthorized"
        case .chargeOptimizationNotPossible: return "chargeOptimizationNotPossible"
        case .chargeOptimizationOverwritten: return "chargeOptimizationOverwritten"
        case .fastpathTimeout: return "fastpathTimeout"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.ChargeOptimizationConfigure: BaseCommandProtocol {

	public typealias Error = ChargeOptimizationConfigureError

	public func createGenericError(error: GenericCommandError) -> ChargeOptimizationConfigureError {
		return ChargeOptimizationConfigureError.genericError(error: error)
	}
}

extension Command.ChargeOptimizationConfigure: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the ChargeOptimizationStart command version v1
public enum ChargeOptimizationStartError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Fastpath timeout
    case fastpathTimeout

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> ChargeOptimizationStartError {
	    switch code { 
        case "42": return .fastpathTimeout
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .fastpathTimeout: return "fastpathTimeout"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.ChargeOptimizationStart: BaseCommandProtocol {

	public typealias Error = ChargeOptimizationStartError

	public func createGenericError(error: GenericCommandError) -> ChargeOptimizationStartError {
		return ChargeOptimizationStartError.genericError(error: error)
	}
}

extension Command.ChargeOptimizationStart: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the ChargeOptimizationStop command version v1
public enum ChargeOptimizationStopError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Fastpath timeout
    case fastpathTimeout

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> ChargeOptimizationStopError {
	    switch code { 
        case "42": return .fastpathTimeout
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .fastpathTimeout: return "fastpathTimeout"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.ChargeOptimizationStop: BaseCommandProtocol {

	public typealias Error = ChargeOptimizationStopError

	public func createGenericError(error: GenericCommandError) -> ChargeOptimizationStopError {
		return ChargeOptimizationStopError.genericError(error: error)
	}
}

extension Command.ChargeOptimizationStop: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the DoorsLock command version v1
public enum DoorsLockError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Failed due to central locking disabled
    case centralLockingDisabled

    /// Failed due to decklid not closed
    case decklidNotClosed

    /// Failed due to decklid not locked
    case decklidNotLocked

    /// Failed due to front left door not closed
    case doorFrontLeftNotClosed

    /// Failed due to front left door not locked
    case doorFrontLeftNotLocked

    /// Failed due to front right door not closed
    case doorFrontRightNotClosed

    /// Failed due to front right door not locked
    case doorFrontRightNotLocked

    /// Failed due to one or more doors not closed
    case doorNotClosed

    /// Failed due to door is open
    case doorOpen

    /// Failed due to rear left door not closed
    case doorRearLeftNotClosed

    /// Failed due to rear left door not locked
    case doorRearLeftNotLocker

    /// Failed due to rear right door not closed
    case doorRearRightNotClosed

    /// Failed due to rear right door not locked
    case doorRearRightNotLocked

    /// Failed due to one or more doors not locked
    case doorsNotLocked

    /// Failed due to driver door open
    case driverDoorOpen

    /// Failed due to driver in vehicle
    case driverIsInVehicle

    /// Failed due to vehicle already external locked
    case externallyLocked

    /// Failed
    case failed

    /// Fastpath timeout
    case fastpathTimeout

    /// Failed due to flip window not closed
    case flipWindowNotClosed

    /// Failed due to flip window not locked
    case flipWindowNotLocked

    /// Failed due to fuel flap not closed
    case fuelFlapNotClosed

    /// Failed due to fuel flap not locked
    case fuelFlapNotLocked

    /// Failed due to gas alarm active
    case gasAlarmActive

    /// Failed due to general error in charge coupler system
    case generalErrorChargeCoupler

    /// Failed due to general error in charge flap system
    case generalErrorChargeFlap

    /// Failed due to general error in locking system
    case generalErrorLocking

    /// Failed due to HOLD-function active
    case holdActive

    /// Failed due to ignition state active
    case ignitionActive

    /// Failed due to ignition is on
    case ignitionIsOn

    /// Failed due to ignition is on
    case ignitionOn

    /// Lock request not authorized
    case lockNotAuthorized

    /// Failed due to request to central locking system cancelled
    case lockingRequestCancelled

    /// Energy level in Battery is too low
    case lowBatteryLevel

    /// Failed due to low battery level 1
    case lowBatteryLevel1

    /// Failed due to low battery level 2
    case lowBatteryLevel2

    /// Failed due to vehicle not external locked
    case notExternallyLocked

    /// Failed due to vehicle not in parking gear selection
    case notInPark

    /// Failed due to parallel request to central locking system
    case parallelRequestToLocking

    /// Failed due to parameter not allowed
    case parameterNotAllowed

    /// Failed due to RDL inactive
    case rdlInactive

    /// Failed due to RDU decklid inactive
    case rduDecklidInactive

    /// Failed due to RDU fuel flap inactive
    case rduFuelFlapInactive

    /// Failed due to RDU global inactive
    case rduGlobalInactive

    /// Failed due to RDU selective inactive
    case rduSelectionInactive

    /// Failed due to rear charge flap not closed
    case rearChargeFlapNotClosed

    /// Failed due to remote engine start is active
    case remoteEngineStartIsActive

    /// Failed due to request not allowed
    case requestNotAllowed

    /// Failed due to restricted info parameter
    case restrictedInfoParameter

    /// Service not authorized
    case serviceNotAuthorized

    /// Failed due to side charge flap not closed
    case sideChargeFlapNotClosed

    /// Failed due to too many requests to central locking system
    case tooManyRequestsToLocking

    /// Failed due to transport mode active
    case transportModeActive

    /// Failed due to unknown reason
    case unknownReason

    /// Failed due to unlock error in charge coupler system
    case unlockErrorChargeCoupler

    /// Failed due to valet parking active
    case valetParkingActive

    /// Failed due to vehicle in ready state
    case vehicleReady

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> DoorsLockError {
	    switch code { 
        case "21": return .lowBatteryLevel
        case "4001": return .failed
        case "4002": return .doorOpen
        case "4003": return .ignitionOn
        case "4004": return .lockNotAuthorized
        case "4100": return .serviceNotAuthorized
        case "4101": return .ignitionIsOn
        case "4102": return .remoteEngineStartIsActive
        case "4103": return .driverIsInVehicle
        case "4104": return .notExternallyLocked
        case "4105": return .lowBatteryLevel1
        case "4106": return .lowBatteryLevel2
        case "4107": return .doorsNotLocked
        case "4108": return .doorFrontLeftNotLocked
        case "4109": return .doorFrontRightNotLocked
        case "4110": return .doorRearLeftNotLocker
        case "4111": return .doorRearRightNotLocked
        case "4112": return .decklidNotLocked
        case "4113": return .flipWindowNotLocked
        case "4114": return .fuelFlapNotLocked
        case "4115": return .driverDoorOpen
        case "4116": return .ignitionActive
        case "4117": return .parallelRequestToLocking
        case "4118": return .tooManyRequestsToLocking
        case "4119": return .holdActive
        case "4120": return .externallyLocked
        case "4121": return .valetParkingActive
        case "4122": return .generalErrorLocking
        case "4123": return .notInPark
        case "4124": return .vehicleReady
        case "4125": return .generalErrorChargeFlap
        case "4126": return .unlockErrorChargeCoupler
        case "4127": return .generalErrorChargeCoupler
        case "4128": return .doorNotClosed
        case "4129": return .doorFrontLeftNotClosed
        case "4130": return .doorFrontRightNotClosed
        case "4131": return .doorRearLeftNotClosed
        case "4132": return .doorRearRightNotClosed
        case "4133": return .decklidNotClosed
        case "4134": return .flipWindowNotClosed
        case "4135": return .sideChargeFlapNotClosed
        case "4136": return .rearChargeFlapNotClosed
        case "4137": return .fuelFlapNotClosed
        case "4138": return .lockingRequestCancelled
        case "4139": return .rduGlobalInactive
        case "4140": return .rduSelectionInactive
        case "4141": return .rdlInactive
        case "4142": return .rduDecklidInactive
        case "4143": return .rduFuelFlapInactive
        case "4144": return .requestNotAllowed
        case "4145": return .parameterNotAllowed
        case "4146": return .restrictedInfoParameter
        case "4147": return .transportModeActive
        case "4148": return .centralLockingDisabled
        case "4149": return .gasAlarmActive
        case "4150": return .unknownReason
        case "42": return .fastpathTimeout
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .centralLockingDisabled: return "centralLockingDisabled"
        case .decklidNotClosed: return "decklidNotClosed"
        case .decklidNotLocked: return "decklidNotLocked"
        case .doorFrontLeftNotClosed: return "doorFrontLeftNotClosed"
        case .doorFrontLeftNotLocked: return "doorFrontLeftNotLocked"
        case .doorFrontRightNotClosed: return "doorFrontRightNotClosed"
        case .doorFrontRightNotLocked: return "doorFrontRightNotLocked"
        case .doorNotClosed: return "doorNotClosed"
        case .doorOpen: return "doorOpen"
        case .doorRearLeftNotClosed: return "doorRearLeftNotClosed"
        case .doorRearLeftNotLocker: return "doorRearLeftNotLocker"
        case .doorRearRightNotClosed: return "doorRearRightNotClosed"
        case .doorRearRightNotLocked: return "doorRearRightNotLocked"
        case .doorsNotLocked: return "doorsNotLocked"
        case .driverDoorOpen: return "driverDoorOpen"
        case .driverIsInVehicle: return "driverIsInVehicle"
        case .externallyLocked: return "externallyLocked"
        case .failed: return "failed"
        case .fastpathTimeout: return "fastpathTimeout"
        case .flipWindowNotClosed: return "flipWindowNotClosed"
        case .flipWindowNotLocked: return "flipWindowNotLocked"
        case .fuelFlapNotClosed: return "fuelFlapNotClosed"
        case .fuelFlapNotLocked: return "fuelFlapNotLocked"
        case .gasAlarmActive: return "gasAlarmActive"
        case .generalErrorChargeCoupler: return "generalErrorChargeCoupler"
        case .generalErrorChargeFlap: return "generalErrorChargeFlap"
        case .generalErrorLocking: return "generalErrorLocking"
        case .holdActive: return "holdActive"
        case .ignitionActive: return "ignitionActive"
        case .ignitionIsOn: return "ignitionIsOn"
        case .ignitionOn: return "ignitionOn"
        case .lockNotAuthorized: return "lockNotAuthorized"
        case .lockingRequestCancelled: return "lockingRequestCancelled"
        case .lowBatteryLevel: return "lowBatteryLevel"
        case .lowBatteryLevel1: return "lowBatteryLevel1"
        case .lowBatteryLevel2: return "lowBatteryLevel2"
        case .notExternallyLocked: return "notExternallyLocked"
        case .notInPark: return "notInPark"
        case .parallelRequestToLocking: return "parallelRequestToLocking"
        case .parameterNotAllowed: return "parameterNotAllowed"
        case .rdlInactive: return "rdlInactive"
        case .rduDecklidInactive: return "rduDecklidInactive"
        case .rduFuelFlapInactive: return "rduFuelFlapInactive"
        case .rduGlobalInactive: return "rduGlobalInactive"
        case .rduSelectionInactive: return "rduSelectionInactive"
        case .rearChargeFlapNotClosed: return "rearChargeFlapNotClosed"
        case .remoteEngineStartIsActive: return "remoteEngineStartIsActive"
        case .requestNotAllowed: return "requestNotAllowed"
        case .restrictedInfoParameter: return "restrictedInfoParameter"
        case .serviceNotAuthorized: return "serviceNotAuthorized"
        case .sideChargeFlapNotClosed: return "sideChargeFlapNotClosed"
        case .tooManyRequestsToLocking: return "tooManyRequestsToLocking"
        case .transportModeActive: return "transportModeActive"
        case .unknownReason: return "unknownReason"
        case .unlockErrorChargeCoupler: return "unlockErrorChargeCoupler"
        case .valetParkingActive: return "valetParkingActive"
        case .vehicleReady: return "vehicleReady"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.DoorsLock: BaseCommandProtocol {

	public typealias Error = DoorsLockError

	public func createGenericError(error: GenericCommandError) -> DoorsLockError {
		return DoorsLockError.genericError(error: error)
	}
}

extension Command.DoorsLock: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the DoorsUnlock command version v1
public enum DoorsUnlockError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Failed due to central locking disabled
    case centralLockingDisabled

    /// Failed due to decklid not closed
    case decklidNotClosed

    /// Failed due to decklid not locked
    case decklidNotLocked

    /// Failed due to front left door not closed
    case doorFrontLeftNotClosed

    /// Failed due to front left door not locked
    case doorFrontLeftNotLocked

    /// Failed due to front right door not closed
    case doorFrontRightNotClosed

    /// Failed due to front right door not locked
    case doorFrontRightNotLocked

    /// Failed due to one or more doors not closed
    case doorNotClosed

    /// Failed due to rear left door not closed
    case doorRearLeftNotClosed

    /// Failed due to rear left door not locked
    case doorRearLeftNotLocker

    /// Failed due to rear right door not closed
    case doorRearRightNotClosed

    /// Failed due to rear right door not locked
    case doorRearRightNotLocked

    /// Failed due to one or more doors not locked
    case doorsNotLocked

    /// Failed due to driver door open
    case driverDoorOpen

    /// Failed due to driver in vehicle
    case driverIsInVehicle

    /// Failed due to vehicle already external locked
    case externallyLocked

    /// Failed
    case failed

    /// Fastpath timeout
    case fastpathTimeout

    /// Failed due to flip window not closed
    case flipWindowNotClosed

    /// Failed due to flip window not locked
    case flipWindowNotLocked

    /// Failed due to fuel flap not closed
    case fuelFlapNotClosed

    /// Failed due to fuel flap not locked
    case fuelFlapNotLocked

    /// Failed due to gas alarm active
    case gasAlarmActive

    /// Failed due to general error in charge coupler system
    case generalErrorChargeCoupler

    /// Failed due to general error in charge flap system
    case generalErrorChargeFlap

    /// Failed due to general error in locking system
    case generalErrorLocking

    /// Failed due to HOLD-function active
    case holdActive

    /// Failed due to ignition state active
    case ignitionActive

    /// Failed due to ignition transition
    case ignitionInTransition

    /// Failed due to ignition is on
    case ignitionIsOn

    /// Failed due to invalid SMS time
    case invalidSmsTime

    /// Failed due to request to central locking system cancelled
    case lockingRequestCancelled

    /// Energy level in Battery is too low
    case lowBatteryLevel

    /// Failed due to low battery level 1
    case lowBatteryLevel1

    /// Failed due to low battery level 2
    case lowBatteryLevel2

    /// Failed due to vehicle not external locked
    case notExternallyLocked

    /// Failed due to vehicle not in parking gear selection
    case notInPark

    /// Failed due to parallel request to central locking system
    case parallelRequestToLocking

    /// Failed due to parameter not allowed
    case parameterNotAllowed

    /// Failed due to RDL inactive
    case rdlInactive

    /// Failed due to RDU decklid inactive
    case rduDecklidInactive

    /// Failed due to RDU fuel flap inactive
    case rduFuelFlapInactive

    /// Failed due to RDU global inactive
    case rduGlobalInactive

    /// Failed due to RDU selective inactive
    case rduSelectionInactive

    /// Failed due to rear charge flap not closed
    case rearChargeFlapNotClosed

    /// Failed due to remote engine start is active
    case remoteEngineStartIsActive

    /// Failed due to request not allowed
    case requestNotAllowed

    /// Failed due to restricted info parameter
    case restrictedInfoParameter

    /// Service not authorized
    case serviceNotAuthorized

    /// Failed due to side charge flap not closed
    case sideChargeFlapNotClosed

    /// Failed due to timeout
    case timeout

    /// Failed due to too many requests to central locking system
    case tooManyRequestsToLocking

    /// Failed due to transport mode active
    case transportModeActive

    /// Failed due to unknown reason
    case unknownReason

    /// Failed due to unlock error in charge coupler system
    case unlockErrorChargeCoupler

    /// Unlock request not authorized
    case unlockNotAuthorized

    /// Failed due to valet parking active
    case valetParkingActive

    /// Failed because vehicle is in motion
    case vehicleInMotion

    /// Failed due to vehicle in ready state
    case vehicleReady

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> DoorsUnlockError {
	    switch code { 
        case "21": return .lowBatteryLevel
        case "4011": return .failed
        case "4012": return .timeout
        case "4013": return .invalidSmsTime
        case "4014": return .vehicleInMotion
        case "4015": return .ignitionInTransition
        case "4016": return .unlockNotAuthorized
        case "4100": return .serviceNotAuthorized
        case "4101": return .ignitionIsOn
        case "4102": return .remoteEngineStartIsActive
        case "4103": return .driverIsInVehicle
        case "4104": return .notExternallyLocked
        case "4105": return .lowBatteryLevel1
        case "4106": return .lowBatteryLevel2
        case "4107": return .doorsNotLocked
        case "4108": return .doorFrontLeftNotLocked
        case "4109": return .doorFrontRightNotLocked
        case "4110": return .doorRearLeftNotLocker
        case "4111": return .doorRearRightNotLocked
        case "4112": return .decklidNotLocked
        case "4113": return .flipWindowNotLocked
        case "4114": return .fuelFlapNotLocked
        case "4115": return .driverDoorOpen
        case "4116": return .ignitionActive
        case "4117": return .parallelRequestToLocking
        case "4118": return .tooManyRequestsToLocking
        case "4119": return .holdActive
        case "4120": return .externallyLocked
        case "4121": return .valetParkingActive
        case "4122": return .generalErrorLocking
        case "4123": return .notInPark
        case "4124": return .vehicleReady
        case "4125": return .generalErrorChargeFlap
        case "4126": return .unlockErrorChargeCoupler
        case "4127": return .generalErrorChargeCoupler
        case "4128": return .doorNotClosed
        case "4129": return .doorFrontLeftNotClosed
        case "4130": return .doorFrontRightNotClosed
        case "4131": return .doorRearLeftNotClosed
        case "4132": return .doorRearRightNotClosed
        case "4133": return .decklidNotClosed
        case "4134": return .flipWindowNotClosed
        case "4135": return .sideChargeFlapNotClosed
        case "4136": return .rearChargeFlapNotClosed
        case "4137": return .fuelFlapNotClosed
        case "4138": return .lockingRequestCancelled
        case "4139": return .rduGlobalInactive
        case "4140": return .rduSelectionInactive
        case "4141": return .rdlInactive
        case "4142": return .rduDecklidInactive
        case "4143": return .rduFuelFlapInactive
        case "4144": return .requestNotAllowed
        case "4145": return .parameterNotAllowed
        case "4146": return .restrictedInfoParameter
        case "4147": return .transportModeActive
        case "4148": return .centralLockingDisabled
        case "4149": return .gasAlarmActive
        case "4150": return .unknownReason
        case "42": return .fastpathTimeout
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .centralLockingDisabled: return "centralLockingDisabled"
        case .decklidNotClosed: return "decklidNotClosed"
        case .decklidNotLocked: return "decklidNotLocked"
        case .doorFrontLeftNotClosed: return "doorFrontLeftNotClosed"
        case .doorFrontLeftNotLocked: return "doorFrontLeftNotLocked"
        case .doorFrontRightNotClosed: return "doorFrontRightNotClosed"
        case .doorFrontRightNotLocked: return "doorFrontRightNotLocked"
        case .doorNotClosed: return "doorNotClosed"
        case .doorRearLeftNotClosed: return "doorRearLeftNotClosed"
        case .doorRearLeftNotLocker: return "doorRearLeftNotLocker"
        case .doorRearRightNotClosed: return "doorRearRightNotClosed"
        case .doorRearRightNotLocked: return "doorRearRightNotLocked"
        case .doorsNotLocked: return "doorsNotLocked"
        case .driverDoorOpen: return "driverDoorOpen"
        case .driverIsInVehicle: return "driverIsInVehicle"
        case .externallyLocked: return "externallyLocked"
        case .failed: return "failed"
        case .fastpathTimeout: return "fastpathTimeout"
        case .flipWindowNotClosed: return "flipWindowNotClosed"
        case .flipWindowNotLocked: return "flipWindowNotLocked"
        case .fuelFlapNotClosed: return "fuelFlapNotClosed"
        case .fuelFlapNotLocked: return "fuelFlapNotLocked"
        case .gasAlarmActive: return "gasAlarmActive"
        case .generalErrorChargeCoupler: return "generalErrorChargeCoupler"
        case .generalErrorChargeFlap: return "generalErrorChargeFlap"
        case .generalErrorLocking: return "generalErrorLocking"
        case .holdActive: return "holdActive"
        case .ignitionActive: return "ignitionActive"
        case .ignitionInTransition: return "ignitionInTransition"
        case .ignitionIsOn: return "ignitionIsOn"
        case .invalidSmsTime: return "invalidSmsTime"
        case .lockingRequestCancelled: return "lockingRequestCancelled"
        case .lowBatteryLevel: return "lowBatteryLevel"
        case .lowBatteryLevel1: return "lowBatteryLevel1"
        case .lowBatteryLevel2: return "lowBatteryLevel2"
        case .notExternallyLocked: return "notExternallyLocked"
        case .notInPark: return "notInPark"
        case .parallelRequestToLocking: return "parallelRequestToLocking"
        case .parameterNotAllowed: return "parameterNotAllowed"
        case .rdlInactive: return "rdlInactive"
        case .rduDecklidInactive: return "rduDecklidInactive"
        case .rduFuelFlapInactive: return "rduFuelFlapInactive"
        case .rduGlobalInactive: return "rduGlobalInactive"
        case .rduSelectionInactive: return "rduSelectionInactive"
        case .rearChargeFlapNotClosed: return "rearChargeFlapNotClosed"
        case .remoteEngineStartIsActive: return "remoteEngineStartIsActive"
        case .requestNotAllowed: return "requestNotAllowed"
        case .restrictedInfoParameter: return "restrictedInfoParameter"
        case .serviceNotAuthorized: return "serviceNotAuthorized"
        case .sideChargeFlapNotClosed: return "sideChargeFlapNotClosed"
        case .timeout: return "timeout"
        case .tooManyRequestsToLocking: return "tooManyRequestsToLocking"
        case .transportModeActive: return "transportModeActive"
        case .unknownReason: return "unknownReason"
        case .unlockErrorChargeCoupler: return "unlockErrorChargeCoupler"
        case .unlockNotAuthorized: return "unlockNotAuthorized"
        case .valetParkingActive: return "valetParkingActive"
        case .vehicleInMotion: return "vehicleInMotion"
        case .vehicleReady: return "vehicleReady"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.DoorsUnlock: BaseCommandProtocol {

	public typealias Error = DoorsUnlockError

	public func createGenericError(error: GenericCommandError) -> DoorsUnlockError {
		return DoorsUnlockError.genericError(error: error)
	}
}

extension Command.DoorsUnlock: CommandPinProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String, pin: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self, pin: pin)
	}
}


/// All possible error codes for the EngineStart command version v1
public enum EngineStartError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Accelerator pressed
    case acceleratorPressed

    /// Alarm, panic alarm and/or warning blinker active
    case alarmActive

    /// theft alarm /panic alarm / emergency flashers got triggered
    case alarmTriggered

    /// Charge cable is plugged
    case chargeCablePlugged

    /// Check engine light is on
    case checkEngineLightOn

    /// cryptologic error, no response from SLV server
    case cryptoError

    /// Failed due to one or more doors not locked
    case doorsNotLocked

    /// Doors open
    case doorsOpen

    /// doors were opened
    case doorsOpened

    /// Engine control module unexpecedely shuts off
    case engineControlShutsOff

    /// Engine Hood open
    case engineHoodOpen

    /// engine hood was opened
    case engineHoodOpened

    /// engine unexpected shut off
    case engineShutOff

    /// engine shut off - doors became unlocked
    case engineShutOffByDoorsUnlocked

    /// engine shut off - either by timeout or by user request
    case engineShutOffByTimeoutOrUser

    /// engine successfully started
    case engineSuccessfullyStarted

    /// Fastpath timeout
    case fastpathTimeout

    /// FBS general error for challengeResponse generation
    case fsbChallengeResponseError

    /// FBS is not able to create a valid challengeResponse for the given VIN
    case fsbUnableToCreateChallengeResponse

    /// FBS is not reachable due to maintenance
    case fsbUnreachable

    /// fuel got low
    case fuelLow

    /// Fuel tank too low (less than 25% volume)
    case fuelTankTooLow

    /// gas pedal was pressed
    case gasPedalPressed

    /// The gear is not in Parking position
    case gearNotInPark

    /// vehicle key plugged in the ignition mechanism
    case keyPluggedIn

    /// Vehicle key plugged in while engine is running
    case keyPluggedInWhileEngineIsRunning

    /// new RS requested within operational timewindow (default 15 min.)
    case newRsRequested

    /// DaiVB does not receive asynchronous callback within MAX_RES_CALLBACK_TIME
    case noCallbackReceived

    /// Remote start is blocked due to parallel FBS workflow
    case remoteStartBlocked

    /// request received and processed twice by EIS, within the same IGN cycle rsAbortedRequestRefus
    case requestReceivedTwice

    /// TCU exhausted all retries on CAN and did not get a valid response from EIS
    case tcuCanError

    /// TCU has remote start service deauthorized
    case tcuNoRemoteService

    /// Windows and/or roof open
    case windowsOrRoofOpen

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> EngineStartError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "6801": return .engineSuccessfullyStarted
        case "6802": return .engineShutOffByTimeoutOrUser
        case "6803": return .engineShutOffByDoorsUnlocked
        case "6804": return .doorsOpened
        case "6805": return .engineHoodOpened
        case "6806": return .alarmTriggered
        case "6807": return .fuelLow
        case "6808": return .gasPedalPressed
        case "6809": return .keyPluggedInWhileEngineIsRunning
        case "6810": return .engineControlShutsOff
        case "6811": return .keyPluggedIn
        case "6812": return .gearNotInPark
        case "6813": return .doorsNotLocked
        case "6814": return .doorsOpen
        case "6815": return .windowsOrRoofOpen
        case "6816": return .engineHoodOpen
        case "6817": return .alarmActive
        case "6818": return .fuelTankTooLow
        case "6819": return .acceleratorPressed
        case "6820": return .newRsRequested
        case "6821": return .cryptoError
        case "6822": return .requestReceivedTwice
        case "6823": return .engineShutOff
        case "6824": return .tcuCanError
        case "6825": return .tcuNoRemoteService
        case "6826": return .chargeCablePlugged
        case "6827": return .fsbUnableToCreateChallengeResponse
        case "6828": return .fsbUnreachable
        case "6829": return .noCallbackReceived
        case "6830": return .fsbChallengeResponseError
        case "6831": return .remoteStartBlocked
        case "6832": return .checkEngineLightOn
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .acceleratorPressed: return "acceleratorPressed"
        case .alarmActive: return "alarmActive"
        case .alarmTriggered: return "alarmTriggered"
        case .chargeCablePlugged: return "chargeCablePlugged"
        case .checkEngineLightOn: return "checkEngineLightOn"
        case .cryptoError: return "cryptoError"
        case .doorsNotLocked: return "doorsNotLocked"
        case .doorsOpen: return "doorsOpen"
        case .doorsOpened: return "doorsOpened"
        case .engineControlShutsOff: return "engineControlShutsOff"
        case .engineHoodOpen: return "engineHoodOpen"
        case .engineHoodOpened: return "engineHoodOpened"
        case .engineShutOff: return "engineShutOff"
        case .engineShutOffByDoorsUnlocked: return "engineShutOffByDoorsUnlocked"
        case .engineShutOffByTimeoutOrUser: return "engineShutOffByTimeoutOrUser"
        case .engineSuccessfullyStarted: return "engineSuccessfullyStarted"
        case .fastpathTimeout: return "fastpathTimeout"
        case .fsbChallengeResponseError: return "fsbChallengeResponseError"
        case .fsbUnableToCreateChallengeResponse: return "fsbUnableToCreateChallengeResponse"
        case .fsbUnreachable: return "fsbUnreachable"
        case .fuelLow: return "fuelLow"
        case .fuelTankTooLow: return "fuelTankTooLow"
        case .gasPedalPressed: return "gasPedalPressed"
        case .gearNotInPark: return "gearNotInPark"
        case .keyPluggedIn: return "keyPluggedIn"
        case .keyPluggedInWhileEngineIsRunning: return "keyPluggedInWhileEngineIsRunning"
        case .newRsRequested: return "newRsRequested"
        case .noCallbackReceived: return "noCallbackReceived"
        case .remoteStartBlocked: return "remoteStartBlocked"
        case .requestReceivedTwice: return "requestReceivedTwice"
        case .tcuCanError: return "tcuCanError"
        case .tcuNoRemoteService: return "tcuNoRemoteService"
        case .windowsOrRoofOpen: return "windowsOrRoofOpen"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.EngineStart: BaseCommandProtocol {

	public typealias Error = EngineStartError

	public func createGenericError(error: GenericCommandError) -> EngineStartError {
		return EngineStartError.genericError(error: error)
	}
}

extension Command.EngineStart: CommandPinProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String, pin: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self, pin: pin)
	}
}


/// All possible error codes for the EngineStop command version v1
public enum EngineStopError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Accelerator pressed
    case acceleratorPressed

    /// Alarm, panic alarm and/or warning blinker active
    case alarmActive

    /// theft alarm /panic alarm / emergency flashers got triggered
    case alarmTriggered

    /// Charge cable is plugged
    case chargeCablePlugged

    /// Check engine light is on
    case checkEngineLightOn

    /// cryptologic error, no response from SLV server
    case cryptoError

    /// Failed due to one or more doors not locked
    case doorsNotLocked

    /// Doors open
    case doorsOpen

    /// doors were opened
    case doorsOpened

    /// Engine control module unexpecedely shuts off
    case engineControlShutsOff

    /// Engine Hood open
    case engineHoodOpen

    /// engine hood was opened
    case engineHoodOpened

    /// engine unexpected shut off
    case engineShutOff

    /// engine shut off - doors became unlocked
    case engineShutOffByDoorsUnlocked

    /// engine shut off - either by timeout or by user request
    case engineShutOffByTimeoutOrUser

    /// engine successfully started
    case engineSuccessfullyStarted

    /// Fastpath timeout
    case fastpathTimeout

    /// FBS general error for challengeResponse generation
    case fsbChallengeResponseError

    /// FBS is not able to create a valid challengeResponse for the given VIN
    case fsbUnableToCreateChallengeResponse

    /// FBS is not reachable due to maintenance
    case fsbUnreachable

    /// fuel got low
    case fuelLow

    /// Fuel tank too low (less than 25% volume)
    case fuelTankTooLow

    /// gas pedal was pressed
    case gasPedalPressed

    /// The gear is not in Parking position
    case gearNotInPark

    /// vehicle key plugged in the ignition mechanism
    case keyPluggedIn

    /// Vehicle key plugged in while engine is running
    case keyPluggedInWhileEngineIsRunning

    /// new RS requested within operational timewindow (default 15 min.)
    case newRsRequested

    /// DaiVB does not receive asynchronous callback within MAX_RES_CALLBACK_TIME
    case noCallbackReceived

    /// Remote start is blocked due to parallel FBS workflow
    case remoteStartBlocked

    /// request received and processed twice by EIS, within the same IGN cycle rsAbortedRequestRefus
    case requestReceivedTwice

    /// TCU exhausted all retries on CAN and did not get a valid response from EIS
    case tcuCanError

    /// TCU has remote start service deauthorized
    case tcuNoRemoteService

    /// Windows and/or roof open
    case windowsOrRoofOpen

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> EngineStopError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "6801": return .engineSuccessfullyStarted
        case "6802": return .engineShutOffByTimeoutOrUser
        case "6803": return .engineShutOffByDoorsUnlocked
        case "6804": return .doorsOpened
        case "6805": return .engineHoodOpened
        case "6806": return .alarmTriggered
        case "6807": return .fuelLow
        case "6808": return .gasPedalPressed
        case "6809": return .keyPluggedInWhileEngineIsRunning
        case "6810": return .engineControlShutsOff
        case "6811": return .keyPluggedIn
        case "6812": return .gearNotInPark
        case "6813": return .doorsNotLocked
        case "6814": return .doorsOpen
        case "6815": return .windowsOrRoofOpen
        case "6816": return .engineHoodOpen
        case "6817": return .alarmActive
        case "6818": return .fuelTankTooLow
        case "6819": return .acceleratorPressed
        case "6820": return .newRsRequested
        case "6821": return .cryptoError
        case "6822": return .requestReceivedTwice
        case "6823": return .engineShutOff
        case "6824": return .tcuCanError
        case "6825": return .tcuNoRemoteService
        case "6826": return .chargeCablePlugged
        case "6827": return .fsbUnableToCreateChallengeResponse
        case "6828": return .fsbUnreachable
        case "6829": return .noCallbackReceived
        case "6830": return .fsbChallengeResponseError
        case "6831": return .remoteStartBlocked
        case "6832": return .checkEngineLightOn
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .acceleratorPressed: return "acceleratorPressed"
        case .alarmActive: return "alarmActive"
        case .alarmTriggered: return "alarmTriggered"
        case .chargeCablePlugged: return "chargeCablePlugged"
        case .checkEngineLightOn: return "checkEngineLightOn"
        case .cryptoError: return "cryptoError"
        case .doorsNotLocked: return "doorsNotLocked"
        case .doorsOpen: return "doorsOpen"
        case .doorsOpened: return "doorsOpened"
        case .engineControlShutsOff: return "engineControlShutsOff"
        case .engineHoodOpen: return "engineHoodOpen"
        case .engineHoodOpened: return "engineHoodOpened"
        case .engineShutOff: return "engineShutOff"
        case .engineShutOffByDoorsUnlocked: return "engineShutOffByDoorsUnlocked"
        case .engineShutOffByTimeoutOrUser: return "engineShutOffByTimeoutOrUser"
        case .engineSuccessfullyStarted: return "engineSuccessfullyStarted"
        case .fastpathTimeout: return "fastpathTimeout"
        case .fsbChallengeResponseError: return "fsbChallengeResponseError"
        case .fsbUnableToCreateChallengeResponse: return "fsbUnableToCreateChallengeResponse"
        case .fsbUnreachable: return "fsbUnreachable"
        case .fuelLow: return "fuelLow"
        case .fuelTankTooLow: return "fuelTankTooLow"
        case .gasPedalPressed: return "gasPedalPressed"
        case .gearNotInPark: return "gearNotInPark"
        case .keyPluggedIn: return "keyPluggedIn"
        case .keyPluggedInWhileEngineIsRunning: return "keyPluggedInWhileEngineIsRunning"
        case .newRsRequested: return "newRsRequested"
        case .noCallbackReceived: return "noCallbackReceived"
        case .remoteStartBlocked: return "remoteStartBlocked"
        case .requestReceivedTwice: return "requestReceivedTwice"
        case .tcuCanError: return "tcuCanError"
        case .tcuNoRemoteService: return "tcuNoRemoteService"
        case .windowsOrRoofOpen: return "windowsOrRoofOpen"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.EngineStop: BaseCommandProtocol {

	public typealias Error = EngineStopError

	public func createGenericError(error: GenericCommandError) -> EngineStopError {
		return EngineStopError.genericError(error: error)
	}
}

extension Command.EngineStop: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the SunroofClose command version v1
public enum SunroofCloseError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Fastpath timeout
    case fastpathTimeout

    /// Energy level in Battery is too low
    case lowBatteryLevel

    /// Remote window/roof command completed successfully
    case windowRoofCommandCompletedSuccessfully

    /// Remote window/roof command failed
    case windowRoofCommandFailed

    /// Remote window/roof command failed (vehicle state in IGN)
    case windowRoofCommandFailedIgnState

    /// Remote window/roof command failed (service not activated in HERMES)
    case windowRoofCommandServiceNotActive

    /// Remote window/roof command failed (window not normed)
    case windowRoofCommandWindowNotNormed

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> SunroofCloseError {
	    switch code { 
        case "21": return .lowBatteryLevel
        case "42": return .fastpathTimeout
        case "6900": return .windowRoofCommandCompletedSuccessfully
        case "6901": return .windowRoofCommandFailed
        case "6902": return .windowRoofCommandFailedIgnState
        case "6903": return .windowRoofCommandWindowNotNormed
        case "6904": return .windowRoofCommandServiceNotActive
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .fastpathTimeout: return "fastpathTimeout"
        case .lowBatteryLevel: return "lowBatteryLevel"
        case .windowRoofCommandCompletedSuccessfully: return "windowRoofCommandCompletedSuccessfully"
        case .windowRoofCommandFailed: return "windowRoofCommandFailed"
        case .windowRoofCommandFailedIgnState: return "windowRoofCommandFailedIgnState"
        case .windowRoofCommandServiceNotActive: return "windowRoofCommandServiceNotActive"
        case .windowRoofCommandWindowNotNormed: return "windowRoofCommandWindowNotNormed"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.SunroofClose: BaseCommandProtocol {

	public typealias Error = SunroofCloseError

	public func createGenericError(error: GenericCommandError) -> SunroofCloseError {
		return SunroofCloseError.genericError(error: error)
	}
}

extension Command.SunroofClose: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the SunroofLift command version v1
public enum SunroofLiftError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Fastpath timeout
    case fastpathTimeout

    /// Energy level in Battery is too low
    case lowBatteryLevel

    /// Remote window/roof command completed successfully
    case windowRoofCommandCompletedSuccessfully

    /// Remote window/roof command failed
    case windowRoofCommandFailed

    /// Remote window/roof command failed (vehicle state in IGN)
    case windowRoofCommandFailedIgnState

    /// Remote window/roof command failed (service not activated in HERMES)
    case windowRoofCommandServiceNotActive

    /// Remote window/roof command failed (window not normed)
    case windowRoofCommandWindowNotNormed

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> SunroofLiftError {
	    switch code { 
        case "21": return .lowBatteryLevel
        case "42": return .fastpathTimeout
        case "6900": return .windowRoofCommandCompletedSuccessfully
        case "6901": return .windowRoofCommandFailed
        case "6902": return .windowRoofCommandFailedIgnState
        case "6903": return .windowRoofCommandWindowNotNormed
        case "6904": return .windowRoofCommandServiceNotActive
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .fastpathTimeout: return "fastpathTimeout"
        case .lowBatteryLevel: return "lowBatteryLevel"
        case .windowRoofCommandCompletedSuccessfully: return "windowRoofCommandCompletedSuccessfully"
        case .windowRoofCommandFailed: return "windowRoofCommandFailed"
        case .windowRoofCommandFailedIgnState: return "windowRoofCommandFailedIgnState"
        case .windowRoofCommandServiceNotActive: return "windowRoofCommandServiceNotActive"
        case .windowRoofCommandWindowNotNormed: return "windowRoofCommandWindowNotNormed"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.SunroofLift: BaseCommandProtocol {

	public typealias Error = SunroofLiftError

	public func createGenericError(error: GenericCommandError) -> SunroofLiftError {
		return SunroofLiftError.genericError(error: error)
	}
}

extension Command.SunroofLift: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the SunroofOpen command version v1
public enum SunroofOpenError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Fastpath timeout
    case fastpathTimeout

    /// Energy level in Battery is too low
    case lowBatteryLevel

    /// Remote window/roof command completed successfully
    case windowRoofCommandCompletedSuccessfully

    /// Remote window/roof command failed
    case windowRoofCommandFailed

    /// Remote window/roof command failed (vehicle state in IGN)
    case windowRoofCommandFailedIgnState

    /// Remote window/roof command failed (service not activated in HERMES)
    case windowRoofCommandServiceNotActive

    /// Remote window/roof command failed (window not normed)
    case windowRoofCommandWindowNotNormed

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> SunroofOpenError {
	    switch code { 
        case "21": return .lowBatteryLevel
        case "42": return .fastpathTimeout
        case "6900": return .windowRoofCommandCompletedSuccessfully
        case "6901": return .windowRoofCommandFailed
        case "6902": return .windowRoofCommandFailedIgnState
        case "6903": return .windowRoofCommandWindowNotNormed
        case "6904": return .windowRoofCommandServiceNotActive
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .fastpathTimeout: return "fastpathTimeout"
        case .lowBatteryLevel: return "lowBatteryLevel"
        case .windowRoofCommandCompletedSuccessfully: return "windowRoofCommandCompletedSuccessfully"
        case .windowRoofCommandFailed: return "windowRoofCommandFailed"
        case .windowRoofCommandFailedIgnState: return "windowRoofCommandFailedIgnState"
        case .windowRoofCommandServiceNotActive: return "windowRoofCommandServiceNotActive"
        case .windowRoofCommandWindowNotNormed: return "windowRoofCommandWindowNotNormed"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.SunroofOpen: BaseCommandProtocol {

	public typealias Error = SunroofOpenError

	public func createGenericError(error: GenericCommandError) -> SunroofOpenError {
		return SunroofOpenError.genericError(error: error)
	}
}

extension Command.SunroofOpen: CommandPinProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String, pin: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self, pin: pin)
	}
}


/// All possible error codes for the SignalPosition command version v1
public enum SignalPositionError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Fastpath timeout
    case fastpathTimeout

    /// Energy level in Battery is too low
    case lowBatteryLevel

    /// RVF (sigpos) failed
    case rvfFailed

    /// RVF (sigpos) failed (not authorized)
    case rvfFailedNotAuthorized

    /// RVF (sigpos) failed (vehicle state in IGN)
    case rvfFailedVehicleStageInIgn

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> SignalPositionError {
	    switch code { 
        case "21": return .lowBatteryLevel
        case "42": return .fastpathTimeout
        case "6401": return .rvfFailed
        case "6402": return .rvfFailedVehicleStageInIgn
        case "6403": return .rvfFailedNotAuthorized
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .fastpathTimeout: return "fastpathTimeout"
        case .lowBatteryLevel: return "lowBatteryLevel"
        case .rvfFailed: return "rvfFailed"
        case .rvfFailedNotAuthorized: return "rvfFailedNotAuthorized"
        case .rvfFailedVehicleStageInIgn: return "rvfFailedVehicleStageInIgn"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.SignalPosition: BaseCommandProtocol {

	public typealias Error = SignalPositionError

	public func createGenericError(error: GenericCommandError) -> SignalPositionError {
		return SignalPositionError.genericError(error: error)
	}
}

extension Command.SignalPosition: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the SpeedAlertStart command version v2
public enum SpeedAlertStartError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Fastpath timeout
    case fastpathTimeout

    /// Speed alert not authorized
    case speedAlertNotAuthorized

    /// Unexpected respons
    case unexpectedResponse

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> SpeedAlertStartError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "6101": return .unexpectedResponse
        case "6102": return .speedAlertNotAuthorized
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .fastpathTimeout: return "fastpathTimeout"
        case .speedAlertNotAuthorized: return "speedAlertNotAuthorized"
        case .unexpectedResponse: return "unexpectedResponse"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.SpeedAlertStart: BaseCommandProtocol {

	public typealias Error = SpeedAlertStartError

	public func createGenericError(error: GenericCommandError) -> SpeedAlertStartError {
		return SpeedAlertStartError.genericError(error: error)
	}
}

extension Command.SpeedAlertStart: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the SpeedAlertStop command version v2
public enum SpeedAlertStopError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Speed alert not authorized
    case speedAlertNotAuthorized

    /// Unexpected respons
    case unexpectedResponse

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> SpeedAlertStopError {
	    switch code { 
        case "6101": return .unexpectedResponse
        case "6102": return .speedAlertNotAuthorized
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .speedAlertNotAuthorized: return "speedAlertNotAuthorized"
        case .unexpectedResponse: return "unexpectedResponse"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.SpeedAlertStop: BaseCommandProtocol {

	public typealias Error = SpeedAlertStopError

	public func createGenericError(error: GenericCommandError) -> SpeedAlertStopError {
		return SpeedAlertStopError.genericError(error: error)
	}
}

extension Command.SpeedAlertStop: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the TemperatureConfigure command version v1
public enum TemperatureConfigureError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Failed
    case failed

    /// failedCANCom
    case failedCanCom

    /// failedIgnOn
    case failedIgnOn

    /// Fastpath timeout
    case fastpathTimeout

    /// NotAuthorized
    case notAuthorized

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> TemperatureConfigureError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "6501": return .failed
        case "6502": return .failedCanCom
        case "6503": return .failedIgnOn
        case "6504": return .notAuthorized
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .failed: return "failed"
        case .failedCanCom: return "failedCanCom"
        case .failedIgnOn: return "failedIgnOn"
        case .fastpathTimeout: return "fastpathTimeout"
        case .notAuthorized: return "notAuthorized"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.TemperatureConfigure: BaseCommandProtocol {

	public typealias Error = TemperatureConfigureError

	public func createGenericError(error: GenericCommandError) -> TemperatureConfigureError {
		return TemperatureConfigureError.genericError(error: error)
	}
}

extension Command.TemperatureConfigure: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the TheftAlarmConfirmDamageDetection command version v3
public enum TheftAlarmConfirmDamageDetectionError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Fastpath timeout
    case fastpathTimeout

    /// Remote VTA failed
    case remoteVtaFailed

    /// Remote VTA ignition not locked
    case remoteVtaIgnitionLocked

    /// Remote VTA VVR not allowed
    case remoteVtaNotAllowed

    /// Remote VTA service not authorized
    case remoteVtaNotAuthorized

    /// Remote VTA VVR value not set
    case remoteVtaValueNotSet

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> TheftAlarmConfirmDamageDetectionError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "5301": return .remoteVtaFailed
        case "5302": return .remoteVtaNotAuthorized
        case "5303": return .remoteVtaIgnitionLocked
        case "5304": return .remoteVtaValueNotSet
        case "5305": return .remoteVtaNotAllowed
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .fastpathTimeout: return "fastpathTimeout"
        case .remoteVtaFailed: return "remoteVtaFailed"
        case .remoteVtaIgnitionLocked: return "remoteVtaIgnitionLocked"
        case .remoteVtaNotAllowed: return "remoteVtaNotAllowed"
        case .remoteVtaNotAuthorized: return "remoteVtaNotAuthorized"
        case .remoteVtaValueNotSet: return "remoteVtaValueNotSet"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.TheftAlarmConfirmDamageDetection: BaseCommandProtocol {

	public typealias Error = TheftAlarmConfirmDamageDetectionError

	public func createGenericError(error: GenericCommandError) -> TheftAlarmConfirmDamageDetectionError {
		return TheftAlarmConfirmDamageDetectionError.genericError(error: error)
	}
}

extension Command.TheftAlarmConfirmDamageDetection: CommandPinProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String, pin: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self, pin: pin)
	}
}


/// All possible error codes for the TheftAlarmDeselectDamageDetection command version v3
public enum TheftAlarmDeselectDamageDetectionError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Fastpath timeout
    case fastpathTimeout

    /// Remote VTA failed
    case remoteVtaFailed

    /// Remote VTA ignition not locked
    case remoteVtaIgnitionLocked

    /// Remote VTA VVR not allowed
    case remoteVtaNotAllowed

    /// Remote VTA service not authorized
    case remoteVtaNotAuthorized

    /// Remote VTA VVR value not set
    case remoteVtaValueNotSet

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> TheftAlarmDeselectDamageDetectionError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "5301": return .remoteVtaFailed
        case "5302": return .remoteVtaNotAuthorized
        case "5303": return .remoteVtaIgnitionLocked
        case "5304": return .remoteVtaValueNotSet
        case "5305": return .remoteVtaNotAllowed
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .fastpathTimeout: return "fastpathTimeout"
        case .remoteVtaFailed: return "remoteVtaFailed"
        case .remoteVtaIgnitionLocked: return "remoteVtaIgnitionLocked"
        case .remoteVtaNotAllowed: return "remoteVtaNotAllowed"
        case .remoteVtaNotAuthorized: return "remoteVtaNotAuthorized"
        case .remoteVtaValueNotSet: return "remoteVtaValueNotSet"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.TheftAlarmDeselectDamageDetection: BaseCommandProtocol {

	public typealias Error = TheftAlarmDeselectDamageDetectionError

	public func createGenericError(error: GenericCommandError) -> TheftAlarmDeselectDamageDetectionError {
		return TheftAlarmDeselectDamageDetectionError.genericError(error: error)
	}
}

extension Command.TheftAlarmDeselectDamageDetection: CommandPinProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String, pin: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self, pin: pin)
	}
}


/// All possible error codes for the TheftAlarmDeselectInterior command version v3
public enum TheftAlarmDeselectInteriorError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Fastpath timeout
    case fastpathTimeout

    /// Remote VTA failed
    case remoteVtaFailed

    /// Remote VTA ignition not locked
    case remoteVtaIgnitionLocked

    /// Remote VTA VVR not allowed
    case remoteVtaNotAllowed

    /// Remote VTA service not authorized
    case remoteVtaNotAuthorized

    /// Remote VTA VVR value not set
    case remoteVtaValueNotSet

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> TheftAlarmDeselectInteriorError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "5301": return .remoteVtaFailed
        case "5302": return .remoteVtaNotAuthorized
        case "5303": return .remoteVtaIgnitionLocked
        case "5304": return .remoteVtaValueNotSet
        case "5305": return .remoteVtaNotAllowed
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .fastpathTimeout: return "fastpathTimeout"
        case .remoteVtaFailed: return "remoteVtaFailed"
        case .remoteVtaIgnitionLocked: return "remoteVtaIgnitionLocked"
        case .remoteVtaNotAllowed: return "remoteVtaNotAllowed"
        case .remoteVtaNotAuthorized: return "remoteVtaNotAuthorized"
        case .remoteVtaValueNotSet: return "remoteVtaValueNotSet"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.TheftAlarmDeselectInterior: BaseCommandProtocol {

	public typealias Error = TheftAlarmDeselectInteriorError

	public func createGenericError(error: GenericCommandError) -> TheftAlarmDeselectInteriorError {
		return TheftAlarmDeselectInteriorError.genericError(error: error)
	}
}

extension Command.TheftAlarmDeselectInterior: CommandPinProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String, pin: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self, pin: pin)
	}
}


/// All possible error codes for the TheftAlarmDeselectTow command version v3
public enum TheftAlarmDeselectTowError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Fastpath timeout
    case fastpathTimeout

    /// Remote VTA failed
    case remoteVtaFailed

    /// Remote VTA ignition not locked
    case remoteVtaIgnitionLocked

    /// Remote VTA VVR not allowed
    case remoteVtaNotAllowed

    /// Remote VTA service not authorized
    case remoteVtaNotAuthorized

    /// Remote VTA VVR value not set
    case remoteVtaValueNotSet

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> TheftAlarmDeselectTowError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "5301": return .remoteVtaFailed
        case "5302": return .remoteVtaNotAuthorized
        case "5303": return .remoteVtaIgnitionLocked
        case "5304": return .remoteVtaValueNotSet
        case "5305": return .remoteVtaNotAllowed
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .fastpathTimeout: return "fastpathTimeout"
        case .remoteVtaFailed: return "remoteVtaFailed"
        case .remoteVtaIgnitionLocked: return "remoteVtaIgnitionLocked"
        case .remoteVtaNotAllowed: return "remoteVtaNotAllowed"
        case .remoteVtaNotAuthorized: return "remoteVtaNotAuthorized"
        case .remoteVtaValueNotSet: return "remoteVtaValueNotSet"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.TheftAlarmDeselectTow: BaseCommandProtocol {

	public typealias Error = TheftAlarmDeselectTowError

	public func createGenericError(error: GenericCommandError) -> TheftAlarmDeselectTowError {
		return TheftAlarmDeselectTowError.genericError(error: error)
	}
}

extension Command.TheftAlarmDeselectTow: CommandPinProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String, pin: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self, pin: pin)
	}
}


/// All possible error codes for the TheftAlarmSelectDamageDetection command version v3
public enum TheftAlarmSelectDamageDetectionError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Fastpath timeout
    case fastpathTimeout

    /// Remote VTA failed
    case remoteVtaFailed

    /// Remote VTA ignition not locked
    case remoteVtaIgnitionLocked

    /// Remote VTA VVR not allowed
    case remoteVtaNotAllowed

    /// Remote VTA service not authorized
    case remoteVtaNotAuthorized

    /// Remote VTA VVR value not set
    case remoteVtaValueNotSet

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> TheftAlarmSelectDamageDetectionError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "5301": return .remoteVtaFailed
        case "5302": return .remoteVtaNotAuthorized
        case "5303": return .remoteVtaIgnitionLocked
        case "5304": return .remoteVtaValueNotSet
        case "5305": return .remoteVtaNotAllowed
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .fastpathTimeout: return "fastpathTimeout"
        case .remoteVtaFailed: return "remoteVtaFailed"
        case .remoteVtaIgnitionLocked: return "remoteVtaIgnitionLocked"
        case .remoteVtaNotAllowed: return "remoteVtaNotAllowed"
        case .remoteVtaNotAuthorized: return "remoteVtaNotAuthorized"
        case .remoteVtaValueNotSet: return "remoteVtaValueNotSet"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.TheftAlarmSelectDamageDetection: BaseCommandProtocol {

	public typealias Error = TheftAlarmSelectDamageDetectionError

	public func createGenericError(error: GenericCommandError) -> TheftAlarmSelectDamageDetectionError {
		return TheftAlarmSelectDamageDetectionError.genericError(error: error)
	}
}

extension Command.TheftAlarmSelectDamageDetection: CommandPinProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String, pin: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self, pin: pin)
	}
}


/// All possible error codes for the TheftAlarmSelectInterior command version v3
public enum TheftAlarmSelectInteriorError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Fastpath timeout
    case fastpathTimeout

    /// Remote VTA failed
    case remoteVtaFailed

    /// Remote VTA ignition not locked
    case remoteVtaIgnitionLocked

    /// Remote VTA VVR not allowed
    case remoteVtaNotAllowed

    /// Remote VTA service not authorized
    case remoteVtaNotAuthorized

    /// Remote VTA VVR value not set
    case remoteVtaValueNotSet

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> TheftAlarmSelectInteriorError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "5301": return .remoteVtaFailed
        case "5302": return .remoteVtaNotAuthorized
        case "5303": return .remoteVtaIgnitionLocked
        case "5304": return .remoteVtaValueNotSet
        case "5305": return .remoteVtaNotAllowed
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .fastpathTimeout: return "fastpathTimeout"
        case .remoteVtaFailed: return "remoteVtaFailed"
        case .remoteVtaIgnitionLocked: return "remoteVtaIgnitionLocked"
        case .remoteVtaNotAllowed: return "remoteVtaNotAllowed"
        case .remoteVtaNotAuthorized: return "remoteVtaNotAuthorized"
        case .remoteVtaValueNotSet: return "remoteVtaValueNotSet"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.TheftAlarmSelectInterior: BaseCommandProtocol {

	public typealias Error = TheftAlarmSelectInteriorError

	public func createGenericError(error: GenericCommandError) -> TheftAlarmSelectInteriorError {
		return TheftAlarmSelectInteriorError.genericError(error: error)
	}
}

extension Command.TheftAlarmSelectInterior: CommandPinProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String, pin: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self, pin: pin)
	}
}


/// All possible error codes for the TheftAlarmSelectTow command version v3
public enum TheftAlarmSelectTowError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Fastpath timeout
    case fastpathTimeout

    /// Remote VTA failed
    case remoteVtaFailed

    /// Remote VTA ignition not locked
    case remoteVtaIgnitionLocked

    /// Remote VTA VVR not allowed
    case remoteVtaNotAllowed

    /// Remote VTA service not authorized
    case remoteVtaNotAuthorized

    /// Remote VTA VVR value not set
    case remoteVtaValueNotSet

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> TheftAlarmSelectTowError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "5301": return .remoteVtaFailed
        case "5302": return .remoteVtaNotAuthorized
        case "5303": return .remoteVtaIgnitionLocked
        case "5304": return .remoteVtaValueNotSet
        case "5305": return .remoteVtaNotAllowed
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .fastpathTimeout: return "fastpathTimeout"
        case .remoteVtaFailed: return "remoteVtaFailed"
        case .remoteVtaIgnitionLocked: return "remoteVtaIgnitionLocked"
        case .remoteVtaNotAllowed: return "remoteVtaNotAllowed"
        case .remoteVtaNotAuthorized: return "remoteVtaNotAuthorized"
        case .remoteVtaValueNotSet: return "remoteVtaValueNotSet"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.TheftAlarmSelectTow: BaseCommandProtocol {

	public typealias Error = TheftAlarmSelectTowError

	public func createGenericError(error: GenericCommandError) -> TheftAlarmSelectTowError {
		return TheftAlarmSelectTowError.genericError(error: error)
	}
}

extension Command.TheftAlarmSelectTow: CommandPinProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String, pin: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self, pin: pin)
	}
}


/// All possible error codes for the TheftAlarmStart command version v3
public enum TheftAlarmStartError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Fastpath timeout
    case fastpathTimeout

    /// Remote VTA failed
    case remoteVtaFailed

    /// Remote VTA ignition not locked
    case remoteVtaIgnitionLocked

    /// Remote VTA VVR not allowed
    case remoteVtaNotAllowed

    /// Remote VTA service not authorized
    case remoteVtaNotAuthorized

    /// Remote VTA VVR value not set
    case remoteVtaValueNotSet

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> TheftAlarmStartError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "5301": return .remoteVtaFailed
        case "5302": return .remoteVtaNotAuthorized
        case "5303": return .remoteVtaIgnitionLocked
        case "5304": return .remoteVtaValueNotSet
        case "5305": return .remoteVtaNotAllowed
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .fastpathTimeout: return "fastpathTimeout"
        case .remoteVtaFailed: return "remoteVtaFailed"
        case .remoteVtaIgnitionLocked: return "remoteVtaIgnitionLocked"
        case .remoteVtaNotAllowed: return "remoteVtaNotAllowed"
        case .remoteVtaNotAuthorized: return "remoteVtaNotAuthorized"
        case .remoteVtaValueNotSet: return "remoteVtaValueNotSet"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.TheftAlarmStart: BaseCommandProtocol {

	public typealias Error = TheftAlarmStartError

	public func createGenericError(error: GenericCommandError) -> TheftAlarmStartError {
		return TheftAlarmStartError.genericError(error: error)
	}
}

extension Command.TheftAlarmStart: CommandPinProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String, pin: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self, pin: pin)
	}
}


/// All possible error codes for the TheftAlarmStop command version v3
public enum TheftAlarmStopError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Fastpath timeout
    case fastpathTimeout

    /// Remote VTA failed
    case remoteVtaFailed

    /// Remote VTA ignition not locked
    case remoteVtaIgnitionLocked

    /// Remote VTA VVR not allowed
    case remoteVtaNotAllowed

    /// Remote VTA service not authorized
    case remoteVtaNotAuthorized

    /// Remote VTA VVR value not set
    case remoteVtaValueNotSet

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> TheftAlarmStopError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "5301": return .remoteVtaFailed
        case "5302": return .remoteVtaNotAuthorized
        case "5303": return .remoteVtaIgnitionLocked
        case "5304": return .remoteVtaValueNotSet
        case "5305": return .remoteVtaNotAllowed
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .fastpathTimeout: return "fastpathTimeout"
        case .remoteVtaFailed: return "remoteVtaFailed"
        case .remoteVtaIgnitionLocked: return "remoteVtaIgnitionLocked"
        case .remoteVtaNotAllowed: return "remoteVtaNotAllowed"
        case .remoteVtaNotAuthorized: return "remoteVtaNotAuthorized"
        case .remoteVtaValueNotSet: return "remoteVtaValueNotSet"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.TheftAlarmStop: BaseCommandProtocol {

	public typealias Error = TheftAlarmStopError

	public func createGenericError(error: GenericCommandError) -> TheftAlarmStopError {
		return TheftAlarmStopError.genericError(error: error)
	}
}

extension Command.TheftAlarmStop: CommandPinProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String, pin: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self, pin: pin)
	}
}


/// All possible error codes for the WeekProfileConfigure command version v1
public enum WeekProfileConfigureError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Fastpath timeout
    case fastpathTimeout

    /// ZEV WeekDeptSet not authorized
    case zevWeekDeptSetNotAuthorized

    /// ZEV WeekDeptSet not possible since either INSTANT CHARGING is already activated or INSTANT CHARGING ACP command is currently in progress
    case zevWeekDeptSetProcessingDeptSetNotPossible

    /// ZEV WeekDeptSet processing failed
    case zevWeekDeptSetProcessingFailed

    /// ZEV WeekDeptSet processing overwritten
    case zevWeekDeptSetProcessingOverwritten

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> WeekProfileConfigureError {
	    switch code { 
        case "42": return .fastpathTimeout
        case "6601": return .zevWeekDeptSetProcessingFailed
        case "6602": return .zevWeekDeptSetNotAuthorized
        case "6603": return .zevWeekDeptSetProcessingOverwritten
        case "6604": return .zevWeekDeptSetProcessingDeptSetNotPossible
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .fastpathTimeout: return "fastpathTimeout"
        case .zevWeekDeptSetNotAuthorized: return "zevWeekDeptSetNotAuthorized"
        case .zevWeekDeptSetProcessingDeptSetNotPossible: return "zevWeekDeptSetProcessingDeptSetNotPossible"
        case .zevWeekDeptSetProcessingFailed: return "zevWeekDeptSetProcessingFailed"
        case .zevWeekDeptSetProcessingOverwritten: return "zevWeekDeptSetProcessingOverwritten"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.WeekProfileConfigure: BaseCommandProtocol {

	public typealias Error = WeekProfileConfigureError

	public func createGenericError(error: GenericCommandError) -> WeekProfileConfigureError {
		return WeekProfileConfigureError.genericError(error: error)
	}
}

extension Command.WeekProfileConfigure: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the WindowsClose command version v1
public enum WindowsCloseError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Fastpath timeout
    case fastpathTimeout

    /// Energy level in Battery is too low
    case lowBatteryLevel

    /// Remote window/roof command completed successfully
    case windowRoofCommandCompletedSuccessfully

    /// Remote window/roof command failed
    case windowRoofCommandFailed

    /// Remote window/roof command failed (vehicle state in IGN)
    case windowRoofCommandFailedIgnState

    /// Remote window/roof command failed (service not activated in HERMES)
    case windowRoofCommandServiceNotActive

    /// Remote window/roof command failed (window not normed)
    case windowRoofCommandWindowNotNormed

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> WindowsCloseError {
	    switch code { 
        case "21": return .lowBatteryLevel
        case "42": return .fastpathTimeout
        case "6900": return .windowRoofCommandCompletedSuccessfully
        case "6901": return .windowRoofCommandFailed
        case "6902": return .windowRoofCommandFailedIgnState
        case "6903": return .windowRoofCommandWindowNotNormed
        case "6904": return .windowRoofCommandServiceNotActive
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .fastpathTimeout: return "fastpathTimeout"
        case .lowBatteryLevel: return "lowBatteryLevel"
        case .windowRoofCommandCompletedSuccessfully: return "windowRoofCommandCompletedSuccessfully"
        case .windowRoofCommandFailed: return "windowRoofCommandFailed"
        case .windowRoofCommandFailedIgnState: return "windowRoofCommandFailedIgnState"
        case .windowRoofCommandServiceNotActive: return "windowRoofCommandServiceNotActive"
        case .windowRoofCommandWindowNotNormed: return "windowRoofCommandWindowNotNormed"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.WindowsClose: BaseCommandProtocol {

	public typealias Error = WindowsCloseError

	public func createGenericError(error: GenericCommandError) -> WindowsCloseError {
		return WindowsCloseError.genericError(error: error)
	}
}

extension Command.WindowsClose: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the WindowsOpen command version v1
public enum WindowsOpenError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Fastpath timeout
    case fastpathTimeout

    /// Energy level in Battery is too low
    case lowBatteryLevel

    /// Remote window/roof command completed successfully
    case windowRoofCommandCompletedSuccessfully

    /// Remote window/roof command failed
    case windowRoofCommandFailed

    /// Remote window/roof command failed (vehicle state in IGN)
    case windowRoofCommandFailedIgnState

    /// Remote window/roof command failed (service not activated in HERMES)
    case windowRoofCommandServiceNotActive

    /// Remote window/roof command failed (window not normed)
    case windowRoofCommandWindowNotNormed

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> WindowsOpenError {
	    switch code { 
        case "21": return .lowBatteryLevel
        case "42": return .fastpathTimeout
        case "6900": return .windowRoofCommandCompletedSuccessfully
        case "6901": return .windowRoofCommandFailed
        case "6902": return .windowRoofCommandFailedIgnState
        case "6903": return .windowRoofCommandWindowNotNormed
        case "6904": return .windowRoofCommandServiceNotActive
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .fastpathTimeout: return "fastpathTimeout"
        case .lowBatteryLevel: return "lowBatteryLevel"
        case .windowRoofCommandCompletedSuccessfully: return "windowRoofCommandCompletedSuccessfully"
        case .windowRoofCommandFailed: return "windowRoofCommandFailed"
        case .windowRoofCommandFailedIgnState: return "windowRoofCommandFailedIgnState"
        case .windowRoofCommandServiceNotActive: return "windowRoofCommandServiceNotActive"
        case .windowRoofCommandWindowNotNormed: return "windowRoofCommandWindowNotNormed"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.WindowsOpen: BaseCommandProtocol {

	public typealias Error = WindowsOpenError

	public func createGenericError(error: GenericCommandError) -> WindowsOpenError {
		return WindowsOpenError.genericError(error: error)
	}
}

extension Command.WindowsOpen: CommandPinProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String, pin: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self, pin: pin)
	}
}


/// All possible error codes for the ZevPreconditioningConfigure command version v1
public enum ZevPreconditioningConfigureError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> ZevPreconditioningConfigureError {
	    switch code { 
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.ZevPreconditioningConfigure: BaseCommandProtocol {

	public typealias Error = ZevPreconditioningConfigureError

	public func createGenericError(error: GenericCommandError) -> ZevPreconditioningConfigureError {
		return ZevPreconditioningConfigureError.genericError(error: error)
	}
}

extension Command.ZevPreconditioningConfigure: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the ZevPreconditioningConfigureSeats command version v1
public enum ZevPreconditioningConfigureSeatsError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> ZevPreconditioningConfigureSeatsError {
	    switch code { 
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.ZevPreconditioningConfigureSeats: BaseCommandProtocol {

	public typealias Error = ZevPreconditioningConfigureSeatsError

	public func createGenericError(error: GenericCommandError) -> ZevPreconditioningConfigureSeatsError {
		return ZevPreconditioningConfigureSeatsError.genericError(error: error)
	}
}

extension Command.ZevPreconditioningConfigureSeats: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the ZevPreconditioningStart command version v1
public enum ZevPreconditioningStartError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

    /// Fastpath timeout
    case fastpathTimeout

    /// Precond not possible since either INSTANT CHARGING is already activated or INSTANT CHARGING command is currently in progress
    case instantChargingActiveOrInProgress

    /// Processing of zev command failed
    case processingFailed

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> ZevPreconditioningStartError {
	    switch code { 
        case "4051": return .processingFailed
        case "4054": return .instantChargingActiveOrInProgress
        case "42": return .fastpathTimeout
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .fastpathTimeout: return "fastpathTimeout"
        case .instantChargingActiveOrInProgress: return "instantChargingActiveOrInProgress"
        case .processingFailed: return "processingFailed"
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.ZevPreconditioningStart: BaseCommandProtocol {

	public typealias Error = ZevPreconditioningStartError

	public func createGenericError(error: GenericCommandError) -> ZevPreconditioningStartError {
		return ZevPreconditioningStartError.genericError(error: error)
	}
}

extension Command.ZevPreconditioningStart: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


/// All possible error codes for the ZevPreconditioningStop command version v1
public enum ZevPreconditioningStopError: CustomStringConvertible, CommandErrorProtocol {

    /// A generic command error that can occur for long list of commands.
	case genericError(error: GenericCommandError) 

	public static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> ZevPreconditioningStopError {
	    switch code { 
        default: return .genericError(error: GenericCommandError.fromErrorCode(code: code, message: message, attributes: attributes))
	    }
	}

	public func unwrapGenericError() -> GenericCommandError? {
		switch self {
		case .genericError(let genericError): return genericError
		default: return nil
		}
	}

	public var description: String {
		switch self { 
        case .genericError(let genericError): return "\(genericError)"
        }
	}
}

extension Command.ZevPreconditioningStop: BaseCommandProtocol {

	public typealias Error = ZevPreconditioningStopError

	public func createGenericError(error: GenericCommandError) -> ZevPreconditioningStopError {
		return ZevPreconditioningStopError.genericError(error: error)
	}
}

extension Command.ZevPreconditioningStop: CommandProtocol {

	public func serialize(with selectedFinOrVin: String, requestId: String) -> Data? {
		return CommandSerializer(vin: selectedFinOrVin, requestId: requestId).serialize(command: self)
	}
}


// swiftlint:enable all

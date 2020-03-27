// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


import MBCommonKit

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable identifier_name line_length nesting type_body_length type_name function_body_length

// MARK: - MyCarTrackingEvent

enum MyCarTrackingEvent: TrackingEvent {
	case doorLock(fin: String, state: CommandState, condition: String)
	case doorUnlock(fin: String, state: CommandState, condition: String)
	case startAuxHeat(fin: String, state: CommandState, condition: String)
	case stopAuxHeat(fin: String, state: CommandState, condition: String)
	case configureAuxHeat(fin: String, state: CommandState, condition: String)
	case engineStart(fin: String, state: CommandState, condition: String)
	case engineStop(fin: String, state: CommandState, condition: String)
	case openSunroof(fin: String, state: CommandState, condition: String)
	case closeSunroof(fin: String, state: CommandState, condition: String)
	case liftSunroof(fin: String, state: CommandState, condition: String)
	case openWindow(fin: String, state: CommandState, condition: String)
	case closeWindow(fin: String, state: CommandState, condition: String)
	case sendToCar(fin: String, routeType: HuCapability, state: CommandState, condition: String)
	case sendToCarBluetooth(fin: String, routeType: SendToCarCapability, state: CommandState, condition: String)
	case locateMe(fin: String, state: CommandState, condition: String)
	case locateVehicle(fin: String, state: CommandState, condition: String)
	case theftAlarmConfirmDamageDetection(fin: String, state: CommandState, condition: String)
	case theftAlarmDeselectDamageDetection(fin: String, state: CommandState, condition: String)
	case theftAlarmDeselectInterior(fin: String, state: CommandState, condition: String)
	case theftAlarmDeselectTow(fin: String, state: CommandState, condition: String)
	case theftAlarmSelectDamageDetection(fin: String, state: CommandState, condition: String)
	case theftAlarmSelectInterior(fin: String, state: CommandState, condition: String)
	case theftAlarmSelectTow(fin: String, state: CommandState, condition: String)
	case theftAlarmStart(fin: String, state: CommandState, condition: String)
	case theftAlarmStop(fin: String, state: CommandState, condition: String)


	// MARK: - Methods
	// map enum cases to convenient protocol functions
	func track(trackingService: TrackingService) {

		guard let service = trackingService as? MyCarTrackingService else {
			return
		}

		switch self {
		case .doorLock(let fin, let state, let condition):
			service.doorLock(fin: fin, state: state, condition: condition)

		case .doorUnlock(let fin, let state, let condition):
			service.doorUnlock(fin: fin, state: state, condition: condition)

		case .startAuxHeat(let fin, let state, let condition):
			service.startAuxHeat(fin: fin, state: state, condition: condition)

		case .stopAuxHeat(let fin, let state, let condition):
			service.stopAuxHeat(fin: fin, state: state, condition: condition)

		case .configureAuxHeat(let fin, let state, let condition):
			service.configureAuxHeat(fin: fin, state: state, condition: condition)

		case .engineStart(let fin, let state, let condition):
			service.engineStart(fin: fin, state: state, condition: condition)

		case .engineStop(let fin, let state, let condition):
			service.engineStop(fin: fin, state: state, condition: condition)

		case .openSunroof(let fin, let state, let condition):
			service.openSunroof(fin: fin, state: state, condition: condition)

		case .closeSunroof(let fin, let state, let condition):
			service.closeSunroof(fin: fin, state: state, condition: condition)

		case .liftSunroof(let fin, let state, let condition):
			service.liftSunroof(fin: fin, state: state, condition: condition)

		case .openWindow(let fin, let state, let condition):
			service.openWindow(fin: fin, state: state, condition: condition)

		case .closeWindow(let fin, let state, let condition):
			service.closeWindow(fin: fin, state: state, condition: condition)

		case .sendToCar(let fin, let routeType, let state, let condition):
			service.sendToCar(fin: fin, routeType: routeType, state: state, condition: condition)

		case .sendToCarBluetooth(let fin, let routeType, let state, let condition):
			service.sendToCarBluetooth(fin: fin, routeType: routeType, state: state, condition: condition)

		case .locateMe(let fin, let state, let condition):
			service.locateMe(fin: fin, state: state, condition: condition)

		case .locateVehicle(let fin, let state, let condition):
			service.locateVehicle(fin: fin, state: state, condition: condition)

		case .theftAlarmConfirmDamageDetection(let fin, let state, let condition):
			service.theftAlarmConfirmDamageDetection(fin: fin, state: state, condition: condition)

		case .theftAlarmDeselectDamageDetection(let fin, let state, let condition):
			service.theftAlarmDeselectDamageDetection(fin: fin, state: state, condition: condition)

		case .theftAlarmDeselectInterior(let fin, let state, let condition):
			service.theftAlarmDeselectInterior(fin: fin, state: state, condition: condition)

		case .theftAlarmDeselectTow(let fin, let state, let condition):
			service.theftAlarmDeselectTow(fin: fin, state: state, condition: condition)

		case .theftAlarmSelectDamageDetection(let fin, let state, let condition):
			service.theftAlarmSelectDamageDetection(fin: fin, state: state, condition: condition)

		case .theftAlarmSelectInterior(let fin, let state, let condition):
			service.theftAlarmSelectInterior(fin: fin, state: state, condition: condition)

		case .theftAlarmSelectTow(let fin, let state, let condition):
			service.theftAlarmSelectTow(fin: fin, state: state, condition: condition)

		case .theftAlarmStart(let fin, let state, let condition):
			service.theftAlarmStart(fin: fin, state: state, condition: condition)

		case .theftAlarmStop(let fin, let state, let condition):
			service.theftAlarmStop(fin: fin, state: state, condition: condition)
		}
	}
}

// swiftlint:enable identifier_name line_length nesting type_body_length type_name function_body_length
// swiftlint:enable file_length
// swiftlint:enable superfluous_disable_command

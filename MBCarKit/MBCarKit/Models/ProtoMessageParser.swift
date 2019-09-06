//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import SwiftProtobuf
import MBCommonKit

// swiftlint:disable function_body_length
// swiftlint:disable type_body_length

class ProtoMessageParser {
	
	// MARK: Typealias
	typealias CommandRequestTriple = (data: Data?, requestId: String, vin: String)
	typealias ParseCompletion = (MessageType) -> Void
	
	// MARK: Constants
	struct ProtoMessageKey {
		static let active                         = "active" // zev is active
		static let auxheatActive                  = "auxheatActive"
		static let auxheatRuntime                 = "auxheatruntime"
		static let auxheatStatus                  = "auxheatstatus"
		static let auxheatTime1                   = "auxheattime1"
		static let auxheatTime2                   = "auxheattime2"
		static let auxheatTime3                   = "auxheattime3"
		static let auxheatTimeSelection           = "auxheattimeselection"
		static let auxheatWarnings                = "auxheatwarnings"
		static let averageSpeedReset              = "averageSpeedReset"
		static let averageSpeedStart              = "averageSpeedStart"
		static let chargingActive                 = "chargingactive"
		static let chargingErrorDetails           = "chargingErrorDetails"
		static let chargingMode                   = "chargingMode"
		static let chargingPower                  = "chargingPower"
		static let chargingStatus                 = "chargingstatus"
		static let decklidStatus                  = "decklidstatus"
		static let departureTime                  = "departuretime"
		static let departureTimeMode              = "departureTimeMode"
		static let departureTimeSoc               = "departuretimesoc"
		static let departureTimeWeekday           = "departureTimeWeekday"
		static let distanceElectricalReset        = "distanceElectricalReset"
		static let distanceElectricalStart        = "distanceElectricalStart"
		static let distanceGasReset               = "distanceGasReset"
		static let distanceGasStart               = "distanceGasStart"
		static let distanceReset                  = "distanceReset"
		static let distanceStart                  = "distanceStart"
		static let distanceZEReset                = "distanceZEReset"
		static let distanceZEStart                = "distanceZEStart"
		static let doorLockStatusDecklid          = "doorlockstatusdecklid"
		static let doorLockStatusFrontLeft        = "doorlockstatusfrontleft"
		static let doorLockStatusFrontRight       = "doorlockstatusfrontright"
		static let doorLockStatusGas              = "doorlockstatusgas"
		static let doorLockStatusOverall          = "doorLockStatusOverall"
		static let doorLockStatusRearLeft         = "doorlockstatusrearleft"
		static let doorLockStatusRearRight        = "doorlockstatusrearright"
		static let doorLockStatusVehicle          = "doorlockstatusvehicle"
		static let doorStatusFrontLeft            = "doorstatusfrontleft"
		static let doorStatusFrontRight           = "doorstatusfrontright"
		static let doorStatusOverall              = "doorStatusOverall"
		static let doorStatusRearLeft             = "doorstatusrearleft"
		static let doorStatusRearRight            = "doorstatusrearright"
		static let drivenTimeReset                = "drivenTimeReset"
		static let drivenTimeStart                = "drivenTimeStart"
		static let drivenTimeZEReset              = "drivenTimeZEReset"
		static let drivenTimeZEStart              = "drivenTimeZEStart"
		static let ecoScoreAccel                  = "ecoscoreaccel"
		static let ecoScoreBonusRange             = "ecoscorebonusrange"
		static let ecoScoreConst                  = "ecoscoreconst"
		static let ecoScoreFreeWhl                = "ecoscorefreewhl"
		static let ecoScoreTotal                  = "ecoscoretotal"
		static let electricConsumptionReset       = "electricconsumptionreset"
		static let electricConsumptionStart       = "electricconsumptionstart"
		static let electricalRangeSkipIndication  = "electricalRangeSkipIndication"
		static let endOfChargeTime                = "endofchargetime"
		static let endOfChargeTimeRelative        = "endOfChargeTimeRelative"
		static let endOfChargeTimeWeekday         = "endofChargeTimeWeekday"
		static let engineHoodStatus               = "engineHoodStatus"
		static let engineState                    = "engineState"
		static let eventTimestamp                 = "eventTimestamp"
		static let filterParticleLoading          = "filterParticleLoading"
		static let gasConsumptionReset            = "gasconsumptionreset"
		static let gasConsumptionStart            = "gasconsumptionstart"
		static let gasTankLevel                   = "gasTankLevel"
//		static let gasTankLevelPercent          = "gasTankLevelPercent"
		static let gasTankRange                   = "gasTankRange"
		static let hybridWarnings                 = "hybridWarnings"
		static let ignitionState                  = "ignitionstate"
		static let interiorProtectionSensorStatus = "interiorProtectionSensorStatus"
		static let languageHU                     = "languageHU"
        static let lastParkEvent                  = "lastParkEvent"
        static let lastTheftWarning               = "lastTheftWarning"
        static let lastTheftWarningReason         = "lastTheftWarningReason"
		static let liquidConsumptionReset         = "liquidconsumptionreset"
		static let liquidConsumptionStart         = "liquidconsumptionstart"
		static let liquidRangeSkipIndication      = "liquidRangeSkipIndication"
		static let maxRange                       = "maxrange"
		static let maxSoc                         = "maxSoc"
		static let maxSocLowerLimit               = "maxSocLowerLimit"
		static let odo                            = "odo"
		static let parkBrakeStatus                = "parkbrakestatus"
		static let parkEventLevel                 = "parkEventLevel"
		static let parkEventType                  = "parkEventType"
		static let positionErrorCode              = "vehiclePositionErrorCode"
		static let positionHeading                = "positionHeading"
		static let positionLat                    = "positionLat"
		static let positionLong                   = "positionLong"
		static let precondActive                  = "precondActive"
		static let precondAtDeparture             = "precondatdeparture"
		static let precondAtDepartureDisable      = "precondAtDepartureDisable"
		static let precondDuration                = "precondDuration"
		static let precondError                   = "precondError"
		static let precondNow                     = "precondNow"
		static let precondNowError                = "precondNowError"
		static let precondSeatFrontLeft           = "precondSeatFrontLeft"
		static let precondSeatFrontRight          = "precondSeatFrontRight"
		static let precondSeatRearLeft            = "precondSeatRearLeft"
		static let precondSeatRearRight           = "precondSeatRearRight"
		static let rangeElectric                  = "rangeelectric"
		static let rangeLiquid                    = "rangeliquid"
		static let remoteStartActive              = "remoteStartActive"
		static let remoteStartEndtime             = "remoteStartEndtime"
		static let remoteStartTemperature         = "remoteStartTemperature"
		static let roofTopStatus                  = "rooftopstatus"
		static let selectedChargeProgram          = "selectedChargeProgram"
		static let serviceIntervalDays            = "serviceintervaldays"
		static let serviceIntervalDistance        = "serviceintervaldistance"
		static let smartCharging                  = "smartCharging"
		static let smartChargingAtDeparture       = "smartChargingAtDeparture"
		static let smartChargingAtDeparture2      = "smartChargingAtDeparture2"
		static let soc                            = "soc"
		static let socProfile                     = "socprofile"
		static let speedUnitFromIC                = "speedUnitFromIC"
		static let starterBatteryState            = "starterBatteryState"
		static let sunroofEvent                   = "sunroofEvent"
		static let sunroofEventActive             = "sunroofEventActive"
		static let sunroofStatus                  = "sunroofstatus"
		static let tankLevelAdBlue                = "tankLevelAdBlue"
		static let tankLevelPercent               = "tanklevelpercent"
		static let temperaturePoints              = "temperaturePoints"
		static let temperatureUnitHU              = "temperatureUnitHU"
		static let theftAlarmActive               = "theftAlarmActive"
		static let theftSystemArmed               = "theftSystemArmed"
		static let timeFormatHU                   = "timeFormatHU"
		static let tireMarkerFrontLeft            = "tireMarkerFrontLeft"
		static let tireMarkerFrontRight           = "tireMarkerFrontRight"
		static let tireMarkerRearLeft             = "tireMarkerRearLeft"
		static let tireMarkerRearRight            = "tireMarkerRearRight"
		static let tirePressMeasTimestamp         = "tirePressMeasTimestamp"
		static let tirePressureFrontLeft          = "tirepressureFrontLeft"
		static let tirePressureFrontRight         = "tirepressureFrontRight"
		static let tirePressureRearLeft           = "tirepressureRearLeft"
		static let tirePressureRearRight          = "tirepressureRearRight"
		static let tireSensorAvailable            = "tireSensorAvailable"
		static let tireWarningLamp                = "tirewarninglamp"
		static let tireWarningLevelPrw            = "tireWarningLevelPrw"
		static let tireWarningSprw                = "tirewarningsprw"
		static let tireWarningSrdk                = "tirewarningsrdk"
		static let towProtectionSensorStatus      = "towProtectionSensorStatus"
		static let trackingStateHU                = "trackingStateHU"
		static let vehicleDataConnectionState     = "vehicleDataConnectionState"
		static let vehicleLockState               = "vehicleLockState"
		static let vTime                          = "vtime"
		static let warningBrakeFluid              = "warningbrakefluid"
		static let warningBrakeLiningWear         = "warningbrakeliningwear"
		static let warningCoolantLevelLow         = "warningcoolantlevellow"
		static let warningEngineLight             = "warningenginelight"
		static let warningWashWater               = "warningwashwater"
		static let weekdaytariff                  = "weekdaytariff"
		static let weekendtariff                  = "weekendtariff"
		static let weeklySetHU                    = "weeklySetHU"
		static let windowStatusFrontLeft          = "windowstatusfrontleft"
		static let windowStatusFrontRight         = "windowstatusfrontright"
		static let windowStatusOverall            = "windowStatusOverall"
		static let windowStatusRearLeft           = "windowstatusrearleft"
		static let windowStatusRearRight          = "windowstatusrearright"
	}
	
	// MARK: Enum
	enum MessageType {
		case commandStatusUpdate(model: CommandStatusUpdateModel)
		case commandStatusUpdateVehicleApi(model: CommandStatusUpdateVehicleApiModel)
		case vehicleCommandStatusUpdate(model: VehicleCommandStatusUpdateModel)
		case debugMessage(message: String)
		case pendingCommands(data: Data)
		case serviceUpdate(model: VehicleServicesStatusUpdateModel)
		case serviceUpdates(models: [VehicleServicesStatusUpdateModel])
		case vehicleUpdate(model: VehicleUpdatedModel)
		case vepUpdate(model: VehicleStatusDTO)
		case vepUpdates(models: [VehicleStatusDTO])
	}
	
	// MARK: Properties
	private var parseCompletion: ParseCompletion?

	
	// MARK: - Public
	
	@available(*, deprecated, message: "Use create(commandVehicleApiRequest:commandComplete:onCancel:) instead.")
	func create(commandRequest: CommandRequest, commandComplete: @escaping (CommandRequestTriple) -> Void, onCancel: @escaping () -> Void) {
		
		commandRequest.create(complete: { (commandRequestProto) in
			
			let commandData   = ProtoMessageParser.serialized(commandRequest: commandRequestProto)
			let commandTriple = (data: commandData, requestId: commandRequestProto.requestID, vin: commandRequestProto.vin)
			commandComplete(commandTriple)
		}, onCancel: onCancel)
	}
	
	func create(commandVehicleApiRequest: CommandVehicleApiRequest, commandComplete: @escaping (CommandRequestTriple) -> Void, onCancel: @escaping () -> Void) {
		
		commandVehicleApiRequest.create(complete: { (commandRequestProto) in
			
			let commandData   = ProtoMessageParser.serialized(commandRequest: commandRequestProto)
			let commandTriple = (data: commandData, requestId: commandRequestProto.requestID, vin: commandRequestProto.vin)
			commandComplete(commandTriple)
		}, onCancel: onCancel)
	}
	
	func createLogoutMessage() -> Data? {
		
		let clientMessage = Proto_ClientMessage.with {
			$0.logout = Proto_Logout()
		}
		
		return ProtoMessageParser.serialized(clientMessage: clientMessage)
	}
	
	func parse(data: Data, completion: ParseCompletion?) {
		
		self.parseCompletion = completion
		self.handle(message: try? Proto_PushMessage(serializedData: data))
	}
	
	
	// MARK: - Helper
	
	private func createAcknowledgeAbilityToGetVehicleMasterDataFromRestAPI(with sequenceNumber: Int32) -> Data? {
		
		let acknowledge = Proto_AcknowledgeAbilityToGetVehicleMasterDataFromRestAPI.with {
			$0.sequenceNumber = sequenceNumber
		}
		let clientMessage = Proto_ClientMessage.with {
			$0.acknowledgeAbilityToGetVehicleMasterDataFromRestApi = acknowledge
		}
		
		return ProtoMessageParser.serialized(clientMessage: clientMessage)
	}
	
	private func createAcknowledgeAppTwinCommandStatusUpdatesClientMessage(with sequenceNumber: Int32) -> Data? {
		
		let acknowledge = Proto_AcknowledgeAppTwinCommandStatusUpdatesByVIN.with {
			$0.sequenceNumber = sequenceNumber
		}
		let clientMessage = Proto_ClientMessage.with {
			$0.acknowledgeApptwinCommandStatusUpdateByVin = acknowledge
		}
		
		return ProtoMessageParser.serialized(clientMessage: clientMessage)
	}
	
	private func createAcknowledgeCommandStatusUpdateClientMessage(with sequenceNumber: Int32) -> Data? {
		
		let acknowledge = Proto_AcknowledgeCommandStatusUpdateRequest.with {
			$0.sequenceNumber = sequenceNumber
		}
		let clientMessage = Proto_ClientMessage.with {
			$0.acknowledgeCommandStatusUpdateRequest = acknowledge
		}
		
		return ProtoMessageParser.serialized(clientMessage: clientMessage)
	}
	
	private func createAcknowledgePreferredDealerChangeClientMessage(with sequenceNumber: Int32) -> Data? {
		
		let acknowledge = Proto_AcknowledgePreferredDealerChange.with {
			$0.sequenceNumber = sequenceNumber
		}
		let clientMessage = Proto_ClientMessage.with {
			$0.acknowledgePreferredDealerChange = acknowledge
		}
		
		return ProtoMessageParser.serialized(clientMessage: clientMessage)
	}
	
	private func createAcknowledgeServiceStatusUpdateClientMessage(with sequenceNumber: Int32) -> Data? {
		
		let acknowledge = Proto_AcknowledgeServiceStatusUpdate.with {
			$0.sequenceNumber = sequenceNumber
		}
		let clientMessage = Proto_ClientMessage.with {
			$0.acknowledgeServiceStatusUpdate = acknowledge
		}
		
		return ProtoMessageParser.serialized(clientMessage: clientMessage)
	}
	
	private func createAcknowledgeServiceStatusUpdatesClientMessage(with sequenceNumber: Int32) -> Data? {
		
		let acknowledge = Proto_AcknowledgeServiceStatusUpdatesByVIN.with {
			$0.sequenceNumber = sequenceNumber
		}
		let clientMessage = Proto_ClientMessage.with {
			$0.acknowledgeServiceStatusUpdatesByVin = acknowledge
		}
		
		return ProtoMessageParser.serialized(clientMessage: clientMessage)
	}
	
	private func createAcknowledgeVehicleUpdateClientMessage(with sequenceNumber: Int32) -> Data? {

		let acknowledge = Proto_AcknowledgeVehicleUpdated.with {
			$0.sequenceNumber = sequenceNumber
		}
		let clientMessage = Proto_ClientMessage.with {
			$0.acknowledgeVehicleUpdated = acknowledge
		}

		return ProtoMessageParser.serialized(clientMessage: clientMessage)
	}
	
	private func createAcknowledgeVEPClientMessage(with sequenceNumber: Int32) -> Data? {
		
		let acknowledge = Proto_AcknowledgeVEPRequest.with {
			$0.sequenceNumber = sequenceNumber
		}
		let clientMessage = Proto_ClientMessage.with {
			$0.acknowledgeVepRequest = acknowledge
		}
		
		return ProtoMessageParser.serialized(clientMessage: clientMessage)
	}
	
	private func createAcknowledgeVEPByVINClientMessage(with sequenceNumber: Int32) -> Data? {
		
		let acknowledge = Proto_AcknowledgeVEPUpdatesByVIN.with {
			$0.sequenceNumber = sequenceNumber
		}
		let clientMessage = Proto_ClientMessage.with {
			$0.acknowledgeVepUpdatesByVin = acknowledge
		}
		
		return ProtoMessageParser.serialized(clientMessage: clientMessage)
	}
	
	private func createDTO(clientMessageData: Data?, vepUpdate: Proto_VEPUpdate) -> VehicleStatusDTO {
		
		let statusUpdateModel = self.map(vepUpdate: vepUpdate, clientMessageData: clientMessageData)
		
		if DatabaseService.selectedFinOrVin == vepUpdate.vin {
			
			LOG.D(vepUpdate.attributes)
			LOG.D(statusUpdateModel)
		}
		
		return statusUpdateModel
	}
	
	private func handle(debugMessage: Proto_DebugMessage) {
		LOG.D("debug message: \(debugMessage.message)")
		
		self.parseCompletion?(.debugMessage(message: debugMessage.message))
	}
	
	private func handle(message: Proto_PushMessage?) {
		
		guard let msg = message?.msg else {
			LOG.D("no valid message type...")
			return
		}
		
		LOG.D("receive message...")
		
		switch msg {
		case .apptwinCommandStatusUpdatesByVin(let commandStatusUpdates):		self.handle(commandStatusUpdates: commandStatusUpdates)
		case .apptwinPendingCommandRequest(let pendingCommandsRequest):			self.handle(pendingCommandsRequest: pendingCommandsRequest)
		case .commandStatusUpdate(let commandStatusUpdate):						self.handle(commandStatusUpdate: commandStatusUpdate)
		case .commandStatusUpdates(let commandStatusUpdates):					self.handle(commandStatusUpdates: commandStatusUpdates)
		case .debugMessage(let debugMessage):									self.handle(debugMessage: debugMessage)
		case .preferredDealerChange(let preferredDealerChange):					self.handle(preferredDealerChange: preferredDealerChange)
		case .serviceStatusUpdate(let serviceStatusUpdate):						self.handle(serviceStatusUpdate: serviceStatusUpdate)
		case .serviceStatusUpdates(let serviceStatusUpdates):					self.handle(serviceStatusUpdates: serviceStatusUpdates)
		case .userDataUpdate(let userDataUpdate):								break
		case .userPictureUpdate(let userPictureUpdate):							break
		case .userPinUpdate(let userPINUpdate):									break
		case .userVehicleAuthChangedUpdate(let userVehicleAuthChangedUpdate):	self.handle(userVehicleAuthChangedUpdate: userVehicleAuthChangedUpdate)
		case .vehicleUpdated(let vehicleUpdate):								self.handle(vehicleUpdate: vehicleUpdate)
		case .vepUpdate(let vepUpdate):											self.handle(vepUpdate: vepUpdate)
		case .vepUpdates(let vepUpdates):										self.handle(vepUpdates: vepUpdates)
		}
	}
	
	private func handle(commandStatusUpdate: Proto_CommandStatusUpdate) {
		
		guard commandStatusUpdate.updates.isEmpty == false else {
			LOG.D("no command status updates for vin \(commandStatusUpdate.vin)")
			return
		}
		
		LOG.D("command status update")
		
		commandStatusUpdate.updates.forEach { (_, commandStatus: Proto_CommandStatus) in
			
			self.track(commandStatus: commandStatus, finOrVin: commandStatusUpdate.vin)
            
			if commandStatus.requestID.isEmpty {
				return
			}
			
			let savedCommandRequestModel = CommandRequestService.commandRequestModel(uuid: commandStatus.requestID)
			let commandRequestModel      = CommandRequestModel(completion: savedCommandRequestModel?.completion,
															   processId: commandStatus.processID,
															   requestId: commandStatus.requestID)
			CommandRequestService.set(commandRequestModel: commandRequestModel)
		}
		
		let clientMessageData = self.createAcknowledgeCommandStatusUpdateClientMessage(with: commandStatusUpdate.sequenceNumber)
		let commandStatusUpdateModel: CommandStatusUpdateModel = self.map(commandStatusUpdate: commandStatusUpdate, clientMessageData: clientMessageData)
        
		if DatabaseService.selectedFinOrVin == commandStatusUpdate.vin {
            
			LOG.D(commandStatusUpdate.updates)
			LOG.D(commandStatusUpdateModel)
		}
		
		self.parseCompletion?(.commandStatusUpdate(model: commandStatusUpdateModel))
	}
	
	private func handle(commandStatusUpdates: Proto_AppTwinCommandStatusUpdatesByPID, clientMessageData: Data?, sequenceNumber: Int32) {
		
		guard commandStatusUpdates.updatesByPid.isEmpty == false else {
			LOG.D("no vehicle api command status updates for vin \(commandStatusUpdates.vin)")
			return
		}
		
		LOG.D("vehicle api command status update")
		
		// updates that were triggered by the new commands API
		var newUpdates = Proto_AppTwinCommandStatusUpdatesByPID()
		
		// updates that were triggered by the old commands API
		var oldUpdates = Proto_AppTwinCommandStatusUpdatesByPID()
		
		commandStatusUpdates.updatesByPid.forEach { (pid, commandStatus: Proto_AppTwinCommandStatus) in
			
			if commandStatus.requestID.isEmpty {
				return
			}
			
			// New commands API
			if let savedRequestModel = VehicleCommandRequestService.commandRequestModelFor(uuid: commandStatus.requestID) {
				
				let newRequestModel = savedRequestModel.updateFullStatus(with: commandStatus)
				VehicleCommandRequestService.set(commandRequestModel: newRequestModel)
				
				newUpdates.updatesByPid[pid] = commandStatus
			}

			
			// Old commands API
			if let savedCommandVehicleApiRequestModel = CommandVehicleApiRequestService.commandVehicleApiRequestModel(uuid: commandStatus.requestID) {
				
				let commandVehicleApiRequestModel = CommandVehicleApiRequestModel(commandStatusRawValue: commandStatus.type.rawValue,
																				  completion: savedCommandVehicleApiRequestModel.completion,
																				  processId: commandStatus.processID,
																				  requestId: commandStatus.requestID,
																				  vin: savedCommandVehicleApiRequestModel.vin)
				CommandVehicleApiRequestService.set(commandVehicleApiRequestModel: commandVehicleApiRequestModel)
				oldUpdates.updatesByPid[pid] = commandStatus
			}
			
		}
		
		// New commands API
		if newUpdates.updatesByPid.count > 0 {
			
			let commandStatusUpdateModel = VehicleCommandStatusUpdateModel(requestIDs: newUpdates.updatesByPid.map { $1.requestID },
																		   clientMessageData: clientMessageData,
																		   sequenceNumber: sequenceNumber,
																		   vin: commandStatusUpdates.vin)
			
			self.parseCompletion?(.vehicleCommandStatusUpdate(model: commandStatusUpdateModel))
			
			if DatabaseService.selectedFinOrVin == commandStatusUpdates.vin {
				LOG.D(commandStatusUpdateModel)
			}
		}
		
		// Old commands API
		if oldUpdates.updatesByPid.count > 0 {

			let commandStatusUpdateVehicleApiModel: CommandStatusUpdateVehicleApiModel = self.map(commandStatusUpdate: oldUpdates,
																								  clientMessageData: clientMessageData,
																								  sequenceNumber: sequenceNumber)
			
			self.parseCompletion?(.commandStatusUpdateVehicleApi(model: commandStatusUpdateVehicleApiModel))
			
			if DatabaseService.selectedFinOrVin == commandStatusUpdates.vin {
				LOG.D(commandStatusUpdateVehicleApiModel)
			}
		}
		
		if DatabaseService.selectedFinOrVin == commandStatusUpdates.vin {
			LOG.D(commandStatusUpdates.updatesByPid)
		}
	}
	
	private func handle(commandStatusUpdates: Proto_AppTwinCommandStatusUpdatesByVIN) {
		LOG.D("vehicle api command status updates: \(commandStatusUpdates)")
		
		let clientMessageData = self.createAcknowledgeAppTwinCommandStatusUpdatesClientMessage(with: commandStatusUpdates.sequenceNumber)
		
		commandStatusUpdates.updatesByVin.forEach { (vin, updatesByPid) in
			
			if vin.isEmpty == false {
				self.handle(commandStatusUpdates: updatesByPid, clientMessageData: clientMessageData, sequenceNumber: commandStatusUpdates.sequenceNumber)
			}
		}
	}
	
	private func handle(commandStatusUpdates: Proto_CommandStatusUpdatesByVIN) {
		LOG.D("command status updates: \(commandStatusUpdates)")
		
		commandStatusUpdates.updates.forEach { (vin, commandStatusUpdate) in
			
			if vin.isEmpty == false {
				self.handle(commandStatusUpdate: commandStatusUpdate)
			}
		}
	}
	
	private func handle(pendingCommandsRequest: Proto_AppTwinPendingCommandsRequest) {
		LOG.D("pending commands request")
		
		let pendingCommands = CommandVehicleApiRequestService.all().map { (commandVehicleApiRequestModel) -> Proto_PendingCommand in
			return Proto_PendingCommand.with {
				
				$0.processID = commandVehicleApiRequestModel.processId
				$0.requestID = commandVehicleApiRequestModel.requestId
				$0.type      = Proto_ACP.CommandType(rawValue: commandVehicleApiRequestModel.commandStatusRawValue) ?? .unknowncommandtype
				$0.vin       = commandVehicleApiRequestModel.vin
			}
		}
		
		let message = Proto_AppTwinPendingCommandsResponse.with {
			$0.pendingCommands = pendingCommands
		}
		let clientMessage = Proto_ClientMessage.with {
			$0.apptwinPendingCommandsResponse = message
		}
		
		guard let data = ProtoMessageParser.serialized(clientMessage: clientMessage) else {
			return
		}
		self.parseCompletion?(.pendingCommands(data: data))
	}
	
	private func handle(preferredDealerChange: Proto_PreferredDealerChange) {
		LOG.D("preferred dealer change")
		
		let clientMessageData = self.createAcknowledgePreferredDealerChangeClientMessage(with: preferredDealerChange.sequenceNumber)
		let vehicleUpdatedModel = VehicleUpdatedModel(clientMessageData: clientMessageData,
													  eventTimestamp: preferredDealerChange.emitTimestampInMs,
													  sequenceNumber: preferredDealerChange.sequenceNumber)
		self.parseCompletion?(.vehicleUpdate(model: vehicleUpdatedModel))
	}
	
	private func handle(serviceStatusUpdate: Proto_ServiceStatusUpdate) {
		
		guard serviceStatusUpdate.updates.isEmpty == false else {
			LOG.D("no service status update attributes")
			return
		}
		
		LOG.D("service status update")
		let clientMessageData = self.createAcknowledgeServiceStatusUpdateClientMessage(with: serviceStatusUpdate.sequenceNumber)
		let serviceUpdateGroupModel = self.map(serviceStatusUpdate: serviceStatusUpdate, clientMessageData: clientMessageData)
		
		LOG.D(serviceStatusUpdate.updates)
		LOG.D(serviceUpdateGroupModel)
		
		self.parseCompletion?(.serviceUpdate(model: serviceUpdateGroupModel))
	}
	
	private func handle(serviceStatusUpdates: Proto_ServiceStatusUpdatesByVIN) {
		
		LOG.D("service status updates by vin")
		let clientMessageData = self.createAcknowledgeServiceStatusUpdatesClientMessage(with: serviceStatusUpdates.sequenceNumber)
		let serviceUpdateGroupModels = serviceStatusUpdates.updates.map { (_, serviceStatusUpdate) -> VehicleServicesStatusUpdateModel in
			return self.map(serviceStatusUpdate: serviceStatusUpdate, clientMessageData: clientMessageData)
		}
		
		LOG.D(serviceStatusUpdates.updates)
		LOG.D(serviceUpdateGroupModels)
		
		self.parseCompletion?(.serviceUpdates(models: serviceUpdateGroupModels))
	}
	
	private func handle(userVehicleAuthChangedUpdate: Proto_UserVehicleAuthChangedUpdate) {
		
		LOG.D("user vehicle auth changed update")
		let clientMessageData = self.createAcknowledgeAbilityToGetVehicleMasterDataFromRestAPI(with: userVehicleAuthChangedUpdate.sequenceNumber)
		let vehicleUpdatedModel = VehicleUpdatedModel(clientMessageData: clientMessageData,
													  eventTimestamp: userVehicleAuthChangedUpdate.emitTimestampInMs,
													  sequenceNumber: userVehicleAuthChangedUpdate.sequenceNumber)
		self.parseCompletion?(.vehicleUpdate(model: vehicleUpdatedModel))
	}
	
	private func handle(vehicleUpdate: Proto_VehicleUpdated) {
		
		LOG.D("vehicle update")
		let clientMessageData = self.createAcknowledgeVehicleUpdateClientMessage(with: vehicleUpdate.sequenceNumber)
		let vehicleUpdatedModel = VehicleUpdatedModel(clientMessageData: clientMessageData,
													  eventTimestamp: vehicleUpdate.emitTimestampInMs,
													  sequenceNumber: vehicleUpdate.sequenceNumber)
		self.parseCompletion?(.vehicleUpdate(model: vehicleUpdatedModel))
	}
	
	private func handle(vepUpdate: Proto_VEPUpdate) {
		
		guard vepUpdate.attributes.isEmpty == false else {
			LOG.D("no vep update attributes")
			return
		}
		
		LOG.D("vep update")
		let clientMessageData = self.createAcknowledgeVEPClientMessage(with: vepUpdate.sequenceNumber)
		let statusUpdateModel = self.createDTO(clientMessageData: clientMessageData, vepUpdate: vepUpdate)
		
		self.parseCompletion?(.vepUpdate(model: statusUpdateModel))
	}
	
	private func handle(vepUpdates: Proto_VEPUpdatesByVIN) {
		LOG.D("vep updates: \(vepUpdates)")
		
		let clientMessageData = self.createAcknowledgeVEPByVINClientMessage(with: vepUpdates.sequenceNumber)
		let statusUpdateModels: [VehicleStatusDTO] = vepUpdates.updates.compactMap { (vin, vepUpdate) -> VehicleStatusDTO? in
			
			guard vin.isEmpty == false,
				vepUpdate.attributes.isEmpty == false else {
					return nil
			}
			
			return self.createDTO(clientMessageData: clientMessageData, vepUpdate: vepUpdate)
		}
		
		self.parseCompletion?(.vepUpdates(models: statusUpdateModels))
	}
	
	private class func serialized(commandRequest: Proto_CommandRequest) -> Data? {
		
		let clientMessage = Proto_ClientMessage.with {
			$0.commandRequest = commandRequest
		}
		
		return ProtoMessageParser.serialized(clientMessage: clientMessage)
	}
	
	private class func serialized(clientMessage: Proto_ClientMessage) -> Data? {
		
		do {
			return try clientMessage.serializedData()
		} catch {
			LOG.E("error: serialized client message")
		}
		
		return nil
	}
	
	private func track(commandStatus: Proto_CommandStatus, finOrVin: String) {
		
		guard let type = commandStatus.type else {
			return
		}
		
		let commandStatusModel = self.map(commandStatus: commandStatus)
		let myCarTrackingEvent: MyCarTrackingEvent? = {
			switch type {
			case .auxheatConfigure:	return .configureAuxHeat(fin: finOrVin, state: commandStatusModel.stateType, condition: commandStatusModel.conditionType)
			case .auxheatStart:		return .startAuxHeat(fin: finOrVin, state: commandStatusModel.stateType, condition: commandStatusModel.conditionType)
			case .auxheatStop:		return .stopAuxHeat(fin: finOrVin, state: commandStatusModel.stateType, condition: commandStatusModel.conditionType)
			case .doorsLock:		return .doorLock(fin: finOrVin, state: commandStatusModel.stateType, condition: commandStatusModel.conditionType)
			case .doorsUnlock:		return .doorUnlock(fin: finOrVin, state: commandStatusModel.stateType, condition: commandStatusModel.conditionType)
			case .engineStart:		return .engineStart(fin: finOrVin, state: commandStatusModel.stateType, condition: commandStatusModel.conditionType)
			case .engineStop:		return .engineStop(fin: finOrVin, state: commandStatusModel.stateType, condition: commandStatusModel.conditionType)
			case .sunroofClose:		return .closeSunroof(fin: finOrVin, state: commandStatusModel.stateType, condition: commandStatusModel.conditionType)
			case .sunroofLift:		return .liftSunroof(fin: finOrVin, state: commandStatusModel.stateType, condition: commandStatusModel.conditionType)
			case .sunroofOpen:		return .openSunroof(fin: finOrVin, state: commandStatusModel.stateType, condition: commandStatusModel.conditionType)
			case .windowsClose:		return .closeWindow(fin: finOrVin, state: commandStatusModel.stateType, condition: commandStatusModel.conditionType)
			case .windowsOpen:		return .openWindow(fin: finOrVin, state: commandStatusModel.stateType, condition: commandStatusModel.conditionType)
			}
		}()
		
		guard let trackingEvent = myCarTrackingEvent else {
			return
		}
		
		MBTrackingManager.track(event: trackingEvent)
	}
	
	
	// MARK: - BusinessModel
	
	private func dayTime<T: RawRepresentable>(for attributeStatus: Proto_VehicleAttributeStatus?) -> VehicleStatusAttributeModel<[DayTimeModel], T>? where T.RawValue == Int {
		
		guard let attribute = attributeStatus else {
			return nil
		}
		
		let dayTimeArray: [DayTimeModel] = attribute.weeklySettingsHeadUnitValue.weeklySettings.compactMap {
			
			guard let day = Day(rawValue: Int($0.day)) else {
				return nil
			}
			return DayTimeModel(day: day, time: Int($0.minutesSinceMidnight))
		}
		
		return VehicleStatusAttributeModel<[DayTimeModel], T>(status: attribute.status,
															  timestampInMs: attribute.timestampInMs,
															  unit: nil,
															  value: dayTimeArray)
	}
	
	private func map(condition: Proto_CommandStatus.Condition) -> CommandConditionType {
		
		switch condition {
		case .accepted:				return .accepted
		case .duplicate:			return .duplicate
		case .failed:				return .failed
		case .none:					return .none
		case .overwritten:			return .overwritten
		case .rejected:				return .rejected
		case .success:				return .success
		case .terminate:			return .terminate
		case .timeout:				return .timeout
		case .unkownConditionType:	return .unknown
		case .UNRECOGNIZED:			return .unknown
		}
	}
	
	private func map(commandStatus: Proto_AppTwinCommandStatus) -> CommandStatusVehicleApiModel {
		return CommandStatusVehicleApiModel(errors: self.map(errors: commandStatus.errors),
											processId: commandStatus.processID,
											stateType: self.map(state: commandStatus.state),
											timestamp: commandStatus.timestampInMs)
	}
	
	private func map(commandStatus: Proto_CommandStatus) -> CommandStatusModel {
		return CommandStatusModel(conditionType: self.map(condition: commandStatus.condition),
								  errors: self.map(errors: commandStatus.errors,
												   attempts: Int(commandStatus.pinAttempts),
												   blockingTimeSeconds: commandStatus.blockingTimeSeconds),
								  processId: commandStatus.processID,
								  stateType: self.map(state: commandStatus.state),
								  timestamp: commandStatus.timestampInMs)
	}
	
	private func map(commandStatusUpdate: Proto_CommandStatusUpdate) -> [CommandStatusModel] {
		return commandStatusUpdate.updates.values.map { self.map(commandStatus: $0) }
	}
	
	private func map(error: Proto_CommandStatus.AcpError, attempts: Int, blockingTimeSeconds: Int64) -> CommandError {
		
		switch error {
		case .pinInvalid:		return .pinInvalid(attempts: attempts)
		case .ciamIDBlocked:	return .ciamIDBlocked(attempts: attempts, blockingTimeSeconds: blockingTimeSeconds)
		default: 				return .unknown(id: error.rawValue)
		}
	}
	
	private func map(error: Proto_VehicleAPIError) -> CommandVehicleApiError {
		
		let subErrors: [CommandVehicleApiError] = error.subErrors.isEmpty ? [] : self.map(errors: error.subErrors)
		return CommandVehicleApiError(code: error.code,
									  message: error.message,
									  subErrors: subErrors)
	}
	
	private func map(errors: [Proto_CommandStatus.AcpError], attempts: Int, blockingTimeSeconds: Int64) -> [CommandError] {
		return errors.compactMap { self.map(error: $0, attempts: attempts, blockingTimeSeconds: blockingTimeSeconds) }
	}
	
	private func map(errors: [Proto_VehicleAPIError]) -> [CommandVehicleApiError] {
		return errors.map { self.map(error: $0) }
	}
	
	private func map(serviceStatusUpdate: Proto_ServiceStatusUpdate, clientMessageData: Data?) -> VehicleServicesStatusUpdateModel {
		
		let services = serviceStatusUpdate.updates.map { (key, value) -> VehicleServiceStatusUpdateModel in
			return VehicleServiceStatusUpdateModel(id: Int(key),
												   status: self.map(status: value))
		}
		
		return VehicleServicesStatusUpdateModel(clientMessageData: clientMessageData,
													finOrVin: serviceStatusUpdate.vin,
													sequenceNumber: serviceStatusUpdate.sequenceNumber,
													services: services)
	}
	
	private func map(state: Proto_CommandStatus.State) -> CommandStateType {
		
		switch state {
		case .created:			return .created
		case .enqueued:			return .enqueued
		case .finished:			return .finished
		case .processing:		return .processing
		case .suspended:		return .suspended
		case .unkownStateType:	return .unknown
		case .UNRECOGNIZED:		return .unknown
		}
	}
	
	private func map(state: Proto_VehicleAPI.CommandState) -> CommandVehicleApiStateType {
		
		switch state {
		case .enqueued:				return .enqueued
		case .failed:				return .failed
		case .finished:				return .finished
		case .initiation:			return .initiation
		case .processing:			return .processing
		case .unknownCommandState:	return .unknown
		case .UNRECOGNIZED:			return .unknown
		case .waiting:				return .waiting
		}
	}
	
	private func map(status: Proto_ServiceStatus) -> ServiceActivationStatus {
		
		switch status {
		case .activationPending:	return .activationPending
		case .active:				return .active
		case .deactivationPending:	return .deactivationPending
		case .inactive:				return .inactive
		case .unknown:				return .unknown
		case .UNRECOGNIZED:			return .unknown
		}
	}
	
	private func map(vepUpdate: Proto_VEPUpdate, clientMessageData: Data?) -> VehicleStatusDTO {
		
		let dto = VehicleStatusDTO(sequenceNumber: vepUpdate.sequenceNumber,
								   vin: vepUpdate.vin)
		dto.auxheatActive = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.auxheatActive])
		dto.auxheatRuntime = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.auxheatRuntime])
		dto.auxheatState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.auxheatStatus])
		dto.auxheatTime1 = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.auxheatTime1])
		dto.auxheatTime2 = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.auxheatTime2])
		dto.auxheatTime3 = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.auxheatTime3])
		dto.auxheatTimeSelection = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.auxheatTimeSelection])
		dto.auxheatWarnings = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.auxheatWarnings])
		dto.averageSpeedReset = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.averageSpeedReset])
		dto.averageSpeedStart = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.averageSpeedStart])
		dto.chargingActive = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.chargingActive])
		dto.chargingError = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.chargingErrorDetails])
		dto.chargingMode = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.chargingMode])
		dto.chargingPower = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.chargingPower])
		dto.chargingStatus = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.chargingStatus])
		dto.clientMessageData = clientMessageData
		dto.decklidLockState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.doorLockStatusDecklid])
		dto.decklidState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.decklidStatus])
		dto.departureTime = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.departureTime])
		dto.departureTimeMode = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.departureTimeMode])
		dto.departureTimeSoc = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.departureTimeSoc])
		dto.departureTimeWeekday = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.departureTimeWeekday])
		dto.distanceElectricalReset = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.distanceElectricalReset])
		dto.distanceElectricalStart = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.distanceElectricalStart])
		dto.distanceGasReset = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.distanceGasReset])
		dto.distanceGasStart = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.distanceGasStart])
		dto.distanceReset = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.distanceReset])
		dto.distanceStart = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.distanceStart])
		dto.distanceZEReset = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.distanceZEReset])
		dto.distanceZEStart = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.distanceZEStart])
		dto.doorFrontLeftLockState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.doorLockStatusFrontLeft])
		dto.doorFrontLeftState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.doorStatusFrontLeft])
		dto.doorFrontRightLockState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.doorLockStatusFrontRight])
		dto.doorFrontRightState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.doorStatusFrontRight])
		dto.doorLockStatusGas = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.doorLockStatusGas])
		dto.doorLockStatusOverall = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.doorLockStatusOverall])
		dto.doorLockStatusVehicle = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.doorLockStatusVehicle])
		dto.doorRearLeftLockState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.doorLockStatusRearLeft])
		dto.doorRearLeftState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.doorStatusRearLeft])
		dto.doorRearRightLockState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.doorLockStatusRearRight])
		dto.doorRearRightState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.doorStatusRearRight])
		dto.doorStatusOverall = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.doorStatusOverall])
		dto.drivenTimeReset = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.drivenTimeReset])
		dto.drivenTimeStart = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.drivenTimeStart])
		dto.drivenTimeZEReset = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.drivenTimeZEReset])
		dto.drivenTimeZEStart = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.drivenTimeZEStart])
		dto.ecoScoreAccel = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.ecoScoreAccel])
		dto.ecoScoreBonusRange = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.ecoScoreBonusRange])
		dto.ecoScoreConst = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.ecoScoreConst])
		dto.ecoScoreFreeWhl = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.ecoScoreFreeWhl])
		dto.ecoScoreTotal = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.ecoScoreTotal])
		dto.electricConsumptionReset = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.electricConsumptionReset])
		dto.electricConsumptionStart = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.electricConsumptionStart])
		dto.electricalRangeSkipIndication = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.electricalRangeSkipIndication])
		dto.endOfChargeTime = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.endOfChargeTime])
		dto.endOfChargeTimeRelative = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.endOfChargeTimeRelative])
		dto.endOfChargeTimeWeekday = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.endOfChargeTimeWeekday])
		dto.engineHoodStatus = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.engineHoodStatus])
		dto.engineState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.engineState])
		dto.eventTimestamp = vepUpdate.emitTimestampInMs
		dto.filterParticleLoading = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.filterParticleLoading])
		dto.gasConsumptionReset = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.gasConsumptionReset])
		dto.gasConsumptionStart = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.gasConsumptionStart])
		dto.hybridWarnings = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.hybridWarnings])
		dto.ignitionState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.ignitionState])
		dto.interiorProtectionSensorStatus = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.interiorProtectionSensorStatus])
		dto.languageHU = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.languageHU])
		dto.lastParkEvent = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.lastParkEvent])
		dto.lastTheftWarning = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.lastTheftWarning])
		dto.lastTheftWarningReason = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.lastTheftWarningReason])
		dto.liquidConsumptionReset = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.liquidConsumptionReset])
		dto.liquidConsumptionStart = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.liquidConsumptionStart])
		dto.liquidRangeSkipIndication = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.liquidRangeSkipIndication])
		dto.maxRange = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.maxRange])
		dto.maxSoc = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.maxSoc])
		dto.maxSocLowerLimit = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.maxSocLowerLimit])
		dto.odo = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.odo])
		dto.parkBrakeStatus = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.parkBrakeStatus])
		dto.parkEventLevel = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.parkEventLevel])
		dto.parkEventType = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.parkEventType])
		dto.positionErrorCode = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.positionErrorCode])
		dto.positionHeading = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.positionHeading])
		dto.positionLat = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.positionLat])
		dto.positionLong = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.positionLong])
		dto.precondActive = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.precondActive])
		dto.precondAtDeparture = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.precondAtDeparture])
		dto.precondAtDepartureDisable = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.precondAtDepartureDisable])
		dto.precondDuration = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.precondDuration])
		dto.precondError = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.precondError])
		dto.precondNow = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.precondNow])
		dto.precondNowError = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.precondNowError])
		dto.precondSeatFrontLeft = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.precondSeatFrontLeft])
		dto.precondSeatFrontRight = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.precondSeatFrontRight])
		dto.precondSeatRearLeft = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.precondSeatRearLeft])
		dto.precondSeatRearRight = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.precondSeatRearRight])
		dto.remoteStartActive = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.remoteStartActive])
		dto.remoteStartEndtime = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.remoteStartEndtime])
		dto.remoteStartTemperature = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.remoteStartTemperature])
		dto.roofTopStatus = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.roofTopStatus])
		dto.selectedChargeProgram = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.selectedChargeProgram])
		dto.serviceIntervalDays = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.serviceIntervalDays])
		dto.serviceIntervalDistance = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.serviceIntervalDistance])
		dto.smartCharging = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.smartCharging])
		dto.smartChargingAtDeparture = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.smartChargingAtDeparture])
		dto.smartChargingAtDeparture2 = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.smartChargingAtDeparture2])
		dto.soc = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.soc])
		dto.socProfile = self.socProfile(for: vepUpdate.attributes[ProtoMessageKey.socProfile])
		dto.speedUnitFromIC = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.speedUnitFromIC])
		dto.starterBatteryState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.starterBatteryState])
		dto.sunroofEventState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.sunroofEvent])
		dto.sunroofEventActive = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.sunroofEventActive])
		dto.sunnroofState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.sunroofStatus])
		dto.tankAdBlueLevel = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.tankLevelAdBlue])
		dto.tankElectricLevel = nil
		dto.tankElectricRange = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.rangeElectric])
		dto.tankGasLevel = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.gasTankLevel])
		dto.tankGasRange = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.gasTankRange])
		dto.tankLiquidLevel = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.tankLevelPercent])
		dto.tankLiquidRange = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.rangeLiquid])
		dto.temperaturePointFrontCenter = self.temperaturePoints(for: vepUpdate.attributes[ProtoMessageKey.temperaturePoints], zone: .frontCenter)
		dto.temperaturePointFrontLeft = self.temperaturePoints(for: vepUpdate.attributes[ProtoMessageKey.temperaturePoints], zone: .frontLeft)
		dto.temperaturePointFrontRight = self.temperaturePoints(for: vepUpdate.attributes[ProtoMessageKey.temperaturePoints], zone: .frontRight)
		dto.temperaturePointRearCenter = self.temperaturePoints(for: vepUpdate.attributes[ProtoMessageKey.temperaturePoints], zone: .rearCenter)
		dto.temperaturePointRearCenter2 = self.temperaturePoints(for: vepUpdate.attributes[ProtoMessageKey.temperaturePoints], zone: .rear2center)
		dto.temperaturePointRearLeft = self.temperaturePoints(for: vepUpdate.attributes[ProtoMessageKey.temperaturePoints], zone: .rearLeft)
		dto.temperaturePointRearRight = self.temperaturePoints(for: vepUpdate.attributes[ProtoMessageKey.temperaturePoints], zone: .rearRight)
		dto.temperatureUnitHU = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.temperatureUnitHU])
		dto.theftSystemArmed = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.theftSystemArmed])
		dto.theftAlarmActive = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.theftAlarmActive])
		dto.timeFormatHU = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.timeFormatHU])
		dto.tireMarkerFrontLeft = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.tireMarkerFrontLeft])
		dto.tireMarkerFrontRight = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.tireMarkerFrontRight])
		dto.tireMarkerRearLeft = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.tireMarkerRearLeft])
		dto.tireMarkerRearRight = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.tireMarkerRearRight])
		dto.tirePressureFrontLeft = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.tirePressureFrontLeft])
		dto.tirePressureFrontRight = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.tirePressureFrontRight])
		dto.tirePressureMeasTimestamp = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.tirePressMeasTimestamp])
		dto.tirePressureRearLeft = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.tirePressureRearLeft])
		dto.tirePressureRearRight = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.tirePressureRearRight])
		dto.tireSensorAvailable = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.tireSensorAvailable])
		dto.towProtectionSensorStatus = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.towProtectionSensorStatus])
		dto.trackingStateHU = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.trackingStateHU])
		dto.vehicleDataConnectionState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.vehicleDataConnectionState])
		dto.vehicleLockState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.vehicleLockState])
        dto.vTime = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.vTime])
		dto.warningBreakFluid = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.warningBrakeFluid])
		dto.warningBrakeLiningWear = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.warningBrakeLiningWear])
		dto.warningCoolantLevelLow = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.warningCoolantLevelLow])
		dto.warningEngineLight = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.warningEngineLight])
		dto.warningTireLamp = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.tireWarningLamp])
		dto.warningTireLevelPrw = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.tireWarningLevelPrw])
		dto.warningTireSprw = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.tireWarningSprw])
		dto.warningTireSrdk = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.tireWarningSrdk])
		dto.warningWashWater = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.warningWashWater])
		dto.weekdaytariff = self.tariff(for: vepUpdate.attributes[ProtoMessageKey.weekdaytariff], type: .weekday)
		dto.weekendtariff = self.tariff(for: vepUpdate.attributes[ProtoMessageKey.weekendtariff], type: .weekend)
		dto.weeklySetHU = self.dayTime(for: vepUpdate.attributes[ProtoMessageKey.weeklySetHU])
		dto.windowFrontLeftState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.windowStatusFrontLeft])
		dto.windowFrontRightState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.windowStatusFrontRight])
		dto.windowRearLeftState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.windowStatusRearLeft])
		dto.windowRearRightState = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.windowStatusRearRight])
		dto.windowStatusOverall = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.windowStatusOverall])
		dto.zevActive = self.vehicleStatusUpdate(for: vepUpdate.attributes[ProtoMessageKey.active])
		return dto
	}
	
	private func map(commandStatusUpdate: Proto_AppTwinCommandStatusUpdatesByPID, clientMessageData: Data?, sequenceNumber: Int32) -> CommandStatusUpdateVehicleApiModel {
		return CommandStatusUpdateVehicleApiModel(commandStatusVehicleApiModels: commandStatusUpdate.updatesByPid.values.map(self.map),
												  clientMessageData: clientMessageData,
												  sequenceNumber: sequenceNumber,
												  vin: commandStatusUpdate.vin)
	}
	
	private func map(commandStatusUpdate: Proto_CommandStatusUpdate, clientMessageData: Data?) -> CommandStatusUpdateModel {
		return CommandStatusUpdateModel(commandStatusModels: commandStatusUpdate.updates.values.map(self.map),
										clientMessageData: clientMessageData,
										eventTimestamp: commandStatusUpdate.emitTimestampInMs,
										sequenceNumber: commandStatusUpdate.sequenceNumber,
										vin: commandStatusUpdate.vin)
	}
	
	private func attributeUnit<T: RawRepresentable>(for attribute: Proto_VehicleAttributeStatus) -> VehicleAttributeUnitModel<T>? where T.RawValue == Int {

		guard let displayUnit = attribute.displayUnit else {
			return nil
		}

		switch displayUnit {
		case .clockHourUnit(let unit):
			return VehicleAttributeUnitModel<T>(value: attribute.displayValue,
												unit: T(rawValue: unit.rawValue))

		case .combustionConsumptionUnit(let unit):
			return VehicleAttributeUnitModel<T>(value: attribute.displayValue,
												unit: T(rawValue: unit.rawValue))

		case .distanceUnit(let unit):
			return VehicleAttributeUnitModel<T>(value: attribute.displayValue,
												unit: T(rawValue: unit.rawValue))
			
		case .electricityConsumptionUnit(let unit):
			return VehicleAttributeUnitModel<T>(value: attribute.displayValue,
												unit: T(rawValue: unit.rawValue))

		case .gasConsumptionUnit(let unit):
			return VehicleAttributeUnitModel<T>(value: attribute.displayValue,
												unit: T(rawValue: unit.rawValue))
			
		case .pressureUnit(let unit):
			return VehicleAttributeUnitModel<T>(value: attribute.displayValue,
												unit: T(rawValue: unit.rawValue))

		case .ratioUnit(let unit):
			return VehicleAttributeUnitModel<T>(value: attribute.displayValue,
												unit: T(rawValue: unit.rawValue))

		case .speedDistanceUnit(let unit):
			return VehicleAttributeUnitModel<T>(value: attribute.displayValue,
												unit: T(rawValue: unit.rawValue))

		case .speedUnit(let unit):
			return VehicleAttributeUnitModel<T>(value: attribute.displayValue,
												unit: T(rawValue: unit.rawValue))
			
		case .temperatureUnit(let unit):
			return VehicleAttributeUnitModel<T>(value: attribute.displayValue,
												unit: T(rawValue: unit.rawValue))
		}
	}
	
	private func socProfile<T: RawRepresentable>(for attributeStatus: Proto_VehicleAttributeStatus?) -> VehicleStatusAttributeModel<[VehicleZEVSocProfileModel], T>? where T.RawValue == Int {
		
		guard let attribute = attributeStatus else {
			return nil
		}
		
		let value = attribute.stateOfChargeProfileValue.statesOfCharge.map { VehicleZEVSocProfileModel(soc: $0.stateOfCharge, time: $0.timestampInS)}
		
		return VehicleStatusAttributeModel<[VehicleZEVSocProfileModel], T>(status: attribute.status,
																		   timestampInMs: attribute.timestampInMs,
																		   unit: nil,
																		   value: value)
	}
	
	private func tariff<T: RawRepresentable>(for attributeStatus: Proto_VehicleAttributeStatus?, type: TariffType) -> VehicleStatusAttributeModel<[VehicleZEVTariffModel], T>? where T.RawValue == Int {
		
		guard let attribute = attributeStatus else {
			return nil
		}
		
		let value: [VehicleZEVTariffModel] = {
			switch type {
			case .weekday:	return attribute.weekdayTariffValue.tariffs.map { VehicleZEVTariffModel(rate: $0.rate, time: $0.time) }
			case .weekend:	return attribute.weekendTariffValue.tariffs.map { VehicleZEVTariffModel(rate: $0.rate, time: $0.time) }
			}
		}()
		
		return VehicleStatusAttributeModel<[VehicleZEVTariffModel], T>(status: attribute.status,
																	   timestampInMs: attribute.timestampInMs,
																	   unit: nil,
																	   value: value)
	}
	
	private func temperaturePoints<T: RawRepresentable>(for attributeStatus: Proto_VehicleAttributeStatus?, zone: TemperatureZone) -> VehicleStatusAttributeModel<Double, T>? where T.RawValue == Int {
		
		guard let attribute = attributeStatus,
			let temperaturePoint = attribute.temperaturePointsValue.temperaturePoints.first(where: { $0.zone == zone.rawValue }) else {
				return nil
		}
		
		return VehicleStatusAttributeModel<Double, T>(status: attribute.status,
													  timestampInMs: attribute.timestampInMs,
													  unit: nil,
													  value: temperaturePoint.temperature)
	}
	
	private func vehicleStatusUpdate<T: RawRepresentable>(for attributeStatus: Proto_VehicleAttributeStatus?) -> VehicleStatusAttributeModel<Bool, T>? where T.RawValue == Int {
		
		guard let attribute = attributeStatus else {
			return nil
		}
		
		let attributeUnit: VehicleAttributeUnitModel<T>? = self.attributeUnit(for: attribute)
		return VehicleStatusAttributeModel<Bool, T>(status: attribute.status,
													timestampInMs: attribute.timestampInMs,
													unit: attributeUnit,
													value: attribute.boolValue)
	}
	
	private func vehicleStatusUpdate<T: RawRepresentable>(for attributeStatus: Proto_VehicleAttributeStatus?) -> VehicleStatusAttributeModel<Double, T>? where T.RawValue == Int {

		guard let attribute = attributeStatus else {
			return nil
		}

		let attributeUnit: VehicleAttributeUnitModel<T>? = self.attributeUnit(for: attribute)
		return VehicleStatusAttributeModel<Double, T>(status: attribute.status,
													  timestampInMs: attribute.timestampInMs,
													  unit: attributeUnit,
													  value: attribute.doubleValue)
	}

	private func vehicleStatusUpdate<T: RawRepresentable>(for attributeStatus: Proto_VehicleAttributeStatus?) -> VehicleStatusAttributeModel<Int, T>? where T.RawValue == Int {

		guard let attribute = attributeStatus else {
			return nil
		}

		let attributeUnit: VehicleAttributeUnitModel<T>? = self.attributeUnit(for: attribute)
		let value: Int = {
			
			guard attribute.intValue == 0 else {
				return Int(attribute.intValue)
			}
			return Int(attribute.doubleValue)
		}()
		
		return VehicleStatusAttributeModel<Int, T>(status: attribute.status,
													 timestampInMs: attribute.timestampInMs,
													 unit: attributeUnit,
													 value: value)
	}
}

// swiftlint:enable function_body_length
// swiftlint:enable type_body_length

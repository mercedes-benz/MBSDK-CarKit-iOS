//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

// swiftlint:disable type_body_length

import Foundation
import MBCommonKit
import MBNetworkKit

public class SocketService: NSObject {
	
	// MARK: Lazy
	private lazy var vepRealmQueue: OperationQueue = {
		
		let queue = OperationQueue()
		queue.maxConcurrentOperationCount = 1
		queue.name = "vepRealmQueue"
		queue.qualityOfService = .background
		return queue
	}()
	
	// MARK: Structs
	private struct Constants {
		static let SendCommandTimeout: TimeInterval = 6.0
	}
	
	// MARK: Properties
	private var protoMessageParser = ProtoMessageParser()
	private var myCarSocketConnectionState: MyCarSocketConnectionState = .disconnected {
		didSet {
			self.notificationTokens.forEach {
				$0.notify(state: self.myCarSocketConnectionState)
			}
		}
	}
	private var notificationTokens: [MyCarSocketNotificationToken]
	private var socketObservable: SocketObservable
	private var socketConnectionToken: SocketConnectionToken?
	private var socketReceiveDataToken: SocketReceiveDataToken?
	
	
	// MARK: - Public
	
	/// Close the my car socket connection and remove all observables
	public func closeConnection() {
		
		Socket.service.unregisterAndDisconnectIfPossible(connectionToken: self.socketConnectionToken,
														 receiveDataToken: self.socketReceiveDataToken)
		self.notificationTokens     = []
		self.socketConnectionToken  = nil
		self.socketReceiveDataToken = nil
		
		Socket.service.close()
	}
	
	/// Connect the my car socket service with the socket
	///
	/// - Returns: A tuple consisting of MyCarSocketConnectionState and SocketObservableProtocol
	///	  - socketConnectionState: Status of the socket connection as MyCarSocketConnectionState
	///	  - socketObservable: Status of the observable based on the SocketObservableProtocol
	/// - Parameters:
	///   - notificationTokenCreated: A block that returns the token that you later remove from the socket status updates watcher list.
	///    The token should be saved until the end of session.
	///   - socketConnectionState: A block that is executed when a status of the connection changed
	public func connect(
		notificationTokenCreated: @escaping MyCarSocketNotificationToken.MyCarSocketNotificationTokenCreated,
		socketConnectionState: @escaping MyCarSocketNotificationToken.MyCarSocketConnectionObserver) -> (socketConnectionState: MyCarSocketConnectionState, socketObservable: SocketObservableProtocol) {
		
		MBCarKit.tokenProvider.requestToken { [weak self] token in
			
			if self?.socketConnectionToken == nil {
				self?.socketConnectionToken = Socket.service.connect(token: token.accessToken, tokenExpiration: token.accessExpirationDate, connectionState: { [weak self] (connectionState) in
					self?.handle(connectionState: connectionState)
				})
			}
			
			if self?.socketReceiveDataToken == nil {
				self?.socketReceiveDataToken = Socket.service.receiveData { [weak self] (data) in
					self?.handle(receiveData: data)
				}
			}
			
			let notificationToken = MyCarSocketNotificationToken(socketConnectionObserver: socketConnectionState)
			self?.notificationTokens.append(notificationToken)
			
			notificationTokenCreated(notificationToken)
		}
		
		return (socketConnectionState: self.myCarSocketConnectionState, socketObservable: self.socketObservable)
	}
	
	/// Connect the my car socket service with the socket
	///
	/// - Parameters:
	///   - notificationTokenCreated: A block that returns the token that you later remove from the socket status updates watcher list.
    ///    The token should be saved until the end of session.
	///   - socketStateUpdateReceived: A block that is executed when a status update occurs
	@available(*, deprecated, message: "Use connect(notificationTokenCreated:socketConnectionState:) instead.")
    public func connect(
		notificationTokenCreated: @escaping MyCarSocketNotificationToken.MyCarSocketNotificationTokenCreated,
		socketStateUpdateReceived: @escaping MyCarSocketNotificationToken.MyCarSocketStateObserver) {
		fatalError("This method is not supported anymore. Use connect(notificationTokenCreated:socketConnectionState:) instead.")
	}
	
	/// Disconnect the my car socket
	public func disconnect() {
		Socket.service.disconnect(forced: true)
	}
	
	/// Reconnect the my car socket
	///
	/// - Parameters: user-based interaction (true) to reconnect the socket connection
	public func reconnect(manually: Bool) {
		self.update(reconnectManually: manually)
	}
	
	/// Send some commands to the my car socket
	///
	/// - Parameters:
	///   - commandRequest: CommandRequest to be sent
	///   - completion: Closure of CommandResult to update the ui
	@available(*, deprecated, message: "Use send(commandVehicleApiRequest:completion:) instead.")
	public func send(commandRequest: CommandRequest, completion: @escaping MBCarKit.CommandResult) {
		
		guard DatabaseService.selectedFinOrVin.isEmpty == false else {
			completion(.error(commandProcessError: .noVehicleSelected))
			return
		}
		
		completion(.creating)
		self.protoMessageParser.create(commandRequest: commandRequest, commandComplete: { (commandRequestTriple) in
			
			guard let commandData = commandRequestTriple.data else {
				completion(.error(commandProcessError: .createCommand))
				return
			}
			
			guard Socket.service.isConnected == true else {
				completion(.error(commandProcessError: .socketDisconnect))
				return
			}
			
			let commandRequestModel = CommandRequestModel(completion: completion,
														  processId: -1,
														  requestId: commandRequestTriple.requestId,
                                                          request: commandRequest)
			
			let selector = #selector(self.commandProcessTimeout(commandRequestModel:))
			self.perform(selector,
						 with: commandRequestModel,
						 afterDelay: Constants.SendCommandTimeout)

			Socket.service.send(data: commandData, completion: { [weak self] in
				LOG.D("send command request: \(commandRequest.type)")
				
				CommandRequestService.set(commandRequestModel: commandRequestModel)
				
				DispatchQueue.main.async {
					NSObject.cancelPreviousPerformRequests(withTarget: self,
														   selector: selector,
														   object: commandRequestModel)
				}
			})
		}, onCancel: {
			completion(.cancel)
		})
	}
	
	/// Send some vehicle api based commands to the my car socket
	///
	/// - Parameters:
	///   - commandRequest: CommandVehicleApiRequest to be sent
	///   - completion: Closure of CommandVehicleApiResult to update the ui
	public func send(commandVehicleApiRequest: CommandVehicleApiRequest, completion: @escaping MBCarKit.CommandVehicleApiResult) {
		
		guard DatabaseService.selectedFinOrVin.isEmpty == false else {
			completion(.error(commandProcessError: .noVehicleSelected))
			return
		}
		
		completion(.creating)
		self.protoMessageParser.create(commandVehicleApiRequest: commandVehicleApiRequest, commandComplete: { (commandRequestTriple) in
			
			guard let commandData = commandRequestTriple.data else {
				completion(.error(commandProcessError: .createCommand))
				return
			}
			
			guard Socket.service.isConnected == true else {
				completion(.error(commandProcessError: .socketDisconnect))
				return
			}
			
			let commandVehicleApiRequestModel = CommandVehicleApiRequestModel(commandStatusRawValue: 0,
																			  completion: completion,
																			  processId: -1,
																			  requestId: commandRequestTriple.requestId,
																			  request: commandVehicleApiRequest,
																			  vin: commandRequestTriple.vin)
			
			let selector = #selector(self.commandProcessTimeout(commandVehicleApiRequestModel:))
			self.perform(selector,
						 with: commandVehicleApiRequestModel,
						 afterDelay: Constants.SendCommandTimeout)
			
			Socket.service.send(data: commandData, completion: {
				LOG.D("send command vehicle api request: \(commandVehicleApiRequest.type)")
				
				CommandVehicleApiRequestService.set(commandVehicleApiRequestModel: commandVehicleApiRequestModel)
				
				DispatchQueue.main.async {
					NSObject.cancelPreviousPerformRequests(withTarget: self,
														   selector: selector,
														   object: commandVehicleApiRequestModel)
				}
			})
		}, onCancel: {
			completion(.cancel)
		})
	}
	
	/// Send a command to the currently selected vehicle. Beware that the service for the specified command must be
	/// be activated. You can find valid commands as nested structs in the `Command`-struct.
	///
	/// - Parameters:
	///   - command: The command to be sent. All valid commands are nested under the `Command`-struct
	///   - completion: A completion callback that is called multiple times for every status update. The
	///                `failed` and `finished` states are final updates and the callback won't be called afterwards
	public func send<T: CommandProtocol>(command: T, completion: @escaping MBCarKit.CommandUpdateCallback<T.Error>) {
		
		let selectedFinOrVin = DatabaseService.selectedFinOrVin
		guard selectedFinOrVin.isEmpty == false else {
			completion(.failed(errors: [command.createGenericError(error: .noVehicleSelected)]), CommandProcessingMetaData(timestamp: Date()))
			return
		}
		
		let requestId = UUID().uuidString
		let commandData = command.serialize(with: selectedFinOrVin, requestId: requestId)
		
		self.send(command: command, serializedCommand: commandData, requestId: requestId, vin: selectedFinOrVin, completion: completion)
	}
	
	/// Send a command to the currently selected vehicle. Beware that the service for the specified command must be
	/// be activated. You can find valid commands as nested structs in the `Command`-struct.
	///
	/// - Parameters:
	///   - command: The command to be sent. All valid commands are nested under the `Command`-struct
	///   - completion: A completion callback that is called multiple times for every status update. The
	///                `failed` and `finished` states are final updates and the callback won't be called afterwards
	public func send<T: CommandPinProtocol>(command: T, completion: @escaping MBCarKit.CommandUpdateCallback<T.Error>) {
		
		let selectedFinOrVin = DatabaseService.selectedFinOrVin
		guard selectedFinOrVin.isEmpty == false else {
			completion(.failed(errors: [command.createGenericError(error: .noVehicleSelected)]), CommandProcessingMetaData(timestamp: Date()))
			return
		}
		
		
		guard let pinProvider = MBCarKit.pinProvider else {
			completion(.failed(errors: [command.createGenericError(error: .pinProviderMissing)]), CommandProcessingMetaData(timestamp: Date()))
			return
		}
		
		
		pinProvider.requestPin(forReason: nil, preventFromUsageAlert: false, onSuccess: { [weak self] (pin) in
			
			let requestId = UUID().uuidString
			let commandData = command.serialize(with: selectedFinOrVin, requestId: requestId, pin: pin)
			self?.send(command: command, serializedCommand: commandData, requestId: requestId, vin: selectedFinOrVin, completion: completion)
		}, onCancel: {
			completion(.failed(errors: [command.createGenericError(error: .pinInputCancelled)]), CommandProcessingMetaData(timestamp: Date()))
		})
	}
	
	
	/// Send logout message
	public func sendLogoutMessage() {
		
		guard let logoutMessage = protoMessageParser.createLogoutMessage() else {
			return
		}
		
		Socket.service.send(data: logoutMessage) {
			LOG.D("send logout message")
		}
	}
	
	/// Update the my car socket enviroment
	///
	/// - Parameters: user-based interaction (true) to reconnect the socket connection
	public func update(reconnectManually: Bool) {

        MBCarKit.tokenProvider.requestToken { token in
			Socket.service.update(token: token.accessToken,
								  tokenExpiredDate: token.accessExpirationDate,
								  needsReconnect: true,
								  reconnectManually: reconnectManually)
        }
	}
	
	/// Update the current my car observables
	public func updateObservables() {
		
		let vehicleStatusModel = CacheService.getCurrentStatus()
		self.updateObservables(vehicleStatusModel: vehicleStatusModel,
							   for: SocketUpdateType.allCases,
							   withNotification: true)
	}
    
    /// Update the current my car values without notify of observers
    public func updateObservablesWithoutNotifyObserver() {
		
        let vehicleStatusModel = CacheService.getCurrentStatus()
		self.updateObservables(vehicleStatusModel: vehicleStatusModel,
							   for: SocketUpdateType.allCases,
							   withNotification: false)
    }
	
	/// This method is used to unregister a my car socket connection token from the observation of the socket connection status
	///
	/// - Parameters: Optional MyCarSocketNotificationToken
	public func unregister(token: MyCarSocketNotificationToken?) {
		self.unregister(token: token, includesDisconnet: false)
	}
	
	/// This method is used to unregister a my car socket connection token from the observation of the socket connection status and try to disconnect the socket connection
	///
	/// - Parameters: Optional MyCarSocketNotificationToken
	public func unregisterAndDisconnectIfPossible(token: MyCarSocketNotificationToken?) {
		self.unregister(token: token, includesDisconnet: true)
	}
	
	
	// MARK: - Init
	
	override init() {
		
		self.notificationTokens = []
		self.socketObservable   = SocketObservable(vehicleStatusModel: CacheService.getCurrentStatus())
	}
	
	
	// MARK: - Helper
	
	private func ackServiceActivation(serviceStatusUpdate: VehicleServicesStatusUpdateModel) {
		
		guard let clientMessageData = serviceStatusUpdate.clientMessageData else {
			return
		}
		
		Socket.service.send(data: clientMessageData) {
			LOG.D("sent service activation ack with sequence number: \(serviceStatusUpdate.sequenceNumber)")
		}
	}
	
	private func addCacheOperation(with vehicleStatusDTO: VehicleStatusDTO) {
		
		let vepCacheOperation = VepCacheOperation(vehicleStatusDTO: vehicleStatusDTO, writeCompleted: { [weak self] (vehicleStatusTupel, updatedVin) in
			
			if DatabaseService.selectedFinOrVin == updatedVin {
				self?.updateObservables(vehicleStatusModel: vehicleStatusTupel.model,
										for: vehicleStatusTupel.updates,
										withNotification: true)
			}
		}, notifySocketHandler: { [weak self] (data, sequenceNumber) in
			self?.notifySocket(data: data, sequenceNumber: sequenceNumber)
		})
		
		self.vepRealmQueue.addOperation(vepCacheOperation)
	}
	
	private func addCacheOperations(with vehicleStatusDTOs: [VehicleStatusDTO]) {
		
		let vepCacheOperations: [VepCacheOperation] = vehicleStatusDTOs.map {
			return VepCacheOperation(vehicleStatusDTO: $0, writeCompleted: { [weak self] (vehicleStatusTupel, updatedVin) in
				
				if DatabaseService.selectedFinOrVin == updatedVin {
					self?.updateObservables(vehicleStatusModel: vehicleStatusTupel.model,
											for: vehicleStatusTupel.updates,
											withNotification: true)
				}
			}, notifySocketHandler: nil)
		}
		
		vepCacheOperations.last?.set(notifySocketHandler: { [weak self] (data, sequenceNumber) in
			self?.notifySocket(data: data, sequenceNumber: sequenceNumber)
		})
		
		self.vepRealmQueue.addOperations(vepCacheOperations, waitUntilFinished: false)
	}
	
	@available(*, deprecated, message: "Use commandProcessTimeout(commandVehicleApiRequestModel:) instead.")
	@objc private func commandProcessTimeout(commandRequestModel: CommandRequestModel) {
		commandRequestModel.completion?(.error(commandProcessError: .timeout))
	}
	
	@objc private func commandProcessTimeout(commandVehicleApiRequestModel: CommandVehicleApiRequestModel) {
		commandVehicleApiRequestModel.completion?(.error(commandProcessError: .timeout))
	}
	
	private func handle(authChangedUpdateModel: VehicleUpdatedModel) {

		MBCarKit.vehicleService.fetchVehicles(completion: {

            if let data = authChangedUpdateModel.clientMessageData {

                Socket.service.send(data: data) {
                    LOG.D("sent vehicle auth changed ack with sequence number: \(authChangedUpdateModel.sequenceNumber)")
                }
            }
		}, needsVehicleSelectionUpdate: { (selectedVin) in
			
			if DatabaseService.selectedFinOrVin != selectedVin {
				DatabaseService.update(finOrVin: selectedVin, completion: nil)
			}
		})
	}
	
	private func handle(commandStatusUpdate: CommandStatusUpdateModel) {
		
		commandStatusUpdate.commandStatusModels.forEach { (commandStatusModel: CommandStatusModel) in
			
			let commandRequestModel = CommandRequestService.commandRequestModel(processId: commandStatusModel.processId)
			
			switch commandStatusModel.stateType {
			case .created,
				 .enqueued,
				 .suspended,
				 .unknown:
				commandRequestModel?.completion?(.updated(commandStatusModel: commandStatusModel))
				
			case .finished:
				commandRequestModel?.completion?(.finished(commandStatusModel: commandStatusModel))
				CommandRequestService.remove(for: commandRequestModel?.requestId)
				
			case .processing:
				commandRequestModel?.completion?(.processing(commandStatusModel: commandStatusModel))
			}
			
			if commandStatusModel.conditionType == .failed {
				
				let errors = commandStatusModel.errors.map { "\($0.code)" }
				LOG.D("command failed with error message: \(errors.joined(separator: ", "))")

                MBCarKit.pinProvider?.handlePinFailure(with: commandStatusModel.errors,
                                                    object: commandRequestModel?.request,
                                                    transmittedBy: nil,
                                                    completion: commandRequestModel?.completion)
            }
		}
		
		if let data = commandStatusUpdate.clientMessageData {
			Socket.service.send(data: data) {
				LOG.D("sent command ack with sequence number: \(commandStatusUpdate.sequenceNumber)")
			}
		}
	}
	
	private func handle(commandStatusUpdateVehicleApi: CommandStatusUpdateVehicleApiModel) {
		
		commandStatusUpdateVehicleApi.commandStatusVehicleApiModels.forEach { (commandStatusVehicleApiModel) in
			
			let commandVehicleApiRequestModel = CommandVehicleApiRequestService.commandVehicleApiRequestModel(processId: commandStatusVehicleApiModel.processId)
			
			switch commandStatusVehicleApiModel.stateType {
			case .enqueued,
				 .initiation,
				 .unknown,
				 .waiting:
				commandVehicleApiRequestModel?.completion?(.updated(commandStatusVehicleApiModel: commandStatusVehicleApiModel))
				
			case .failed,
				 .finished:
				commandVehicleApiRequestModel?.completion?(.finished(commandStatusVehicleApiModel: commandStatusVehicleApiModel))
				CommandVehicleApiRequestService.remove(for: commandVehicleApiRequestModel?.requestId)
				
				if commandStatusVehicleApiModel.stateType == .failed {
					
					let errors = commandStatusVehicleApiModel.errors.map { "\($0.code) - \($0.message)" }
					LOG.D("vehicle api command failed with error message: \(errors.joined(separator: ", "))")
				}
				
			case .processing:
				commandVehicleApiRequestModel?.completion?(.processing(commandStatusVehicleApiModel: commandStatusVehicleApiModel))
			}
		}
		
		if let data = commandStatusUpdateVehicleApi.clientMessageData {
			Socket.service.send(data: data) {
				LOG.D("sent vehicle api command ack with sequence number: \(commandStatusUpdateVehicleApi.sequenceNumber)")
			}
		}
	}
	
	private func handle(newCommandStatus: VehicleCommandStatusUpdateModel) {
		
		newCommandStatus.requestIDs.forEach { (requestID) in
			
			defer {
				if let data = newCommandStatus.clientMessageData {
					Socket.service.send(data: data) {
						LOG.D("sent vehicle api command ack with sequence number: \(newCommandStatus.sequenceNumber)")
					}
				}
			}
			
			guard let savedCommandRequestModel = VehicleCommandRequestService.commandRequestModelFor(uuid: requestID) else {
				return
			}
			
			savedCommandRequestModel.callCompletion()
			
			guard let state = savedCommandRequestModel.commandState else {
				return
			}
			
			switch state {
			case .unknownCommandState, .finished, .failed, .UNRECOGNIZED:
				VehicleCommandRequestService.remove(for: savedCommandRequestModel.requestId)
				
			default:
				break
			}
		}
	}
	
	private func handle(connectionState: SocketConnectionState) {
		
		let newSocketConnectionState: MyCarSocketConnectionState = {
			switch connectionState {
			case .closed:								return .closed
			case .connected:							return .connected
			case .connecting:							return .connecting
			case .connectionLost(let needsTokenUpdate):	return .connectionLost(needsTokenUpdate: needsTokenUpdate)
			case .disconnected:							return .disconnected
			}
		}()
		
		self.myCarSocketConnectionState = newSocketConnectionState
	}
	
	private func handle(receiveData: Data) {
		
		LOG.D("my car module receive data")
		self.protoMessageParser.parse(data: receiveData) { [weak self] (messageType) in
			
			switch messageType {
			case .commandStatusUpdate(let model):			self?.handle(commandStatusUpdate: model)
			case .commandStatusUpdateVehicleApi(let model):	self?.handle(commandStatusUpdateVehicleApi: model)
			case .vehicleCommandStatusUpdate(let model): 		self?.handle(newCommandStatus: model)
			case .debugMessage(let message):				self?.socketObservable.debugMessage.value = message
			case .pendingCommands(let data):				self?.handle(pendingCommandsData: data)
			case .serviceUpdate(let model):					self?.handle(servicesStatusUpdate: [model])
			case .serviceUpdates(let models):				self?.handle(servicesStatusUpdate: models)
			case .vehicleUpdate(let model):					self?.handle(authChangedUpdateModel: model)
			case .vepUpdate(let model):						self?.addCacheOperation(with: model)
			case .vepUpdates(let models):					self?.addCacheOperations(with: models)
			}
		}
	}
	
	private func handle(pendingCommandsData: Data) {
		
		Socket.service.send(data: pendingCommandsData) {
			LOG.D("send pending commands response")
		}
	}
	
	private func handle(servicesStatusUpdate: [VehicleServicesStatusUpdateModel]) {
		
		DatabaseVehicleServicesService.setPendingType(services: servicesStatusUpdate) { [weak self] in
			
			let dispatchGroup = DispatchGroup()
			
			servicesStatusUpdate.forEach { (serviceStatusUpdate) in
				
				let requestedServices = serviceStatusUpdate.services.compactMap { (service) -> Int? in
					
					let relevantStatus: [ServiceActivationStatus] = [.active, .activationPending, .deactivationPending, .inactive]
					guard relevantStatus.contains(service.status) else {
						return nil
					}
					return service.id
				}
				
				guard requestedServices.isEmpty == false else {
					return
				}
				
				dispatchGroup.enter()
				MBCarKit.servicesService.fetchVehicleServices(finOrVin: serviceStatusUpdate.finOrVin, groupedOption: .categoryName, services: requestedServices, completion: { (_) in
					LOG.D("update service status after activation")
					
					dispatchGroup.leave()
				}, onError: { (error) in
					LOG.D("update service status error after activation: \(error)")
				})
			}
			
			dispatchGroup.notify(queue: .main, execute: { [weak self] in
				
				guard let serviceStatusUpdate = servicesStatusUpdate.first else {
					return
				}
				self?.ackServiceActivation(serviceStatusUpdate: serviceStatusUpdate)
			})
		}
	}
	
	private func trackCommand<T: BaseCommandProtocol>(command: T, vin: String) {
		switch command {
		case is Command.AuxHeatConfigure:
			MBTrackingManager.track(event: MyCarTrackingEvent.configureAuxHeat(fin: vin, state: .created, condition: .none))
		
		case is Command.AuxHeatStart:
			MBTrackingManager.track(event: MyCarTrackingEvent.startAuxHeat(fin: vin, state: .created, condition: .none))
		
		case is Command.AuxHeatStop:
			MBTrackingManager.track(event: MyCarTrackingEvent.stopAuxHeat(fin: vin, state: .created, condition: .none))

		case is Command.DoorsUnlock:
			MBTrackingManager.track(event: MyCarTrackingEvent.doorUnlock(fin: vin, state: .created, condition: .none))
		
		case is Command.EngineStart:
			MBTrackingManager.track(event: MyCarTrackingEvent.engineStart(fin: vin, state: .created, condition: .none))
		
		case is Command.EngineStop:
			MBTrackingManager.track(event: MyCarTrackingEvent.engineStop(fin: vin, state: .created, condition: .none))
		
		case is Command.SunroofOpen:
			MBTrackingManager.track(event: MyCarTrackingEvent.openSunroof(fin: vin, state: .created, condition: .none))
		
		case is Command.SunroofClose:
			MBTrackingManager.track(event: MyCarTrackingEvent.closeSunroof(fin: vin, state: .created, condition: .none))
		
		case is Command.SunroofLift:
			MBTrackingManager.track(event: MyCarTrackingEvent.liftSunroof(fin: vin, state: .created, condition: .none))
		
		case is Command.WindowsOpen:
			MBTrackingManager.track(event: MyCarTrackingEvent.openWindow(fin: vin, state: .created, condition: .none))
		
		case is Command.WindowsClose:
			MBTrackingManager.track(event: MyCarTrackingEvent.closeWindow(fin: vin, state: .created, condition: .none))
		
		case is Command.TheftAlarmConfirmDamageDetection:
			MBTrackingManager.track(event: MyCarTrackingEvent.theftAlarmConfirmDamageDetection(fin: vin, state: .created, condition: .none))
		
		case is Command.TheftAlarmDeselectDamageDetection:
			MBTrackingManager.track(event: MyCarTrackingEvent.theftAlarmDeselectDamageDetection(fin: vin, state: .created, condition: .none))
		
		case is Command.TheftAlarmDeselectInterior:
			MBTrackingManager.track(event: MyCarTrackingEvent.theftAlarmDeselectInterior(fin: vin, state: .created, condition: .none))
		
		case is Command.TheftAlarmDeselectTow:
			MBTrackingManager.track(event: MyCarTrackingEvent.theftAlarmDeselectTow(fin: vin, state: .created, condition: .none))
		
		case is Command.TheftAlarmSelectDamageDetection:
			MBTrackingManager.track(event: MyCarTrackingEvent.theftAlarmSelectDamageDetection(fin: vin, state: .created, condition: .none))
		
		case is Command.TheftAlarmSelectInterior:
			MBTrackingManager.track(event: MyCarTrackingEvent.theftAlarmSelectInterior(fin: vin, state: .created, condition: .none))
		
		case is Command.TheftAlarmSelectTow:
			MBTrackingManager.track(event: MyCarTrackingEvent.theftAlarmSelectTow(fin: vin, state: .created, condition: .none))
		
		case is Command.TheftAlarmStart:
			MBTrackingManager.track(event: MyCarTrackingEvent.theftAlarmStart(fin: vin, state: .created, condition: .none))
		
		case is Command.TheftAlarmStop:
			MBTrackingManager.track(event: MyCarTrackingEvent.theftAlarmStop(fin: vin, state: .created, condition: .none))
		
		default:
			print("No tracking for command \(command)")
		}
	}
	
	private func send<T: BaseCommandProtocol>(command: T, serializedCommand: Data?, requestId: String, vin: String, completion: @escaping MBCarKit.CommandUpdateCallback<T.Error>) {
		
		guard let serializeCommand = serializedCommand else {
			completion(.failed(errors: [command.createGenericError(error: .unknownError(message: "Command serialization failed"))]), CommandProcessingMetaData(timestamp: Date()))
			return
		}
		
		guard Socket.service.isConnected == true else {
			completion(.failed(errors: [command.createGenericError(error: .noInternetConnection)]), CommandProcessingMetaData(timestamp: Date()))
			return
		}
		
		self.trackCommand(command: command, vin: vin)
		
		let commandRequestModel = VehicleCommandRequestModel<T>(completion: completion,
																requestId: requestId,
																command: command,
																vin: vin,
																fullStatus: nil)
		
		let timeout = DispatchWorkItem(block: {
			commandRequestModel.handleTimeout()
		})
		
		DispatchQueue.main.asyncAfter(deadline: .now() + Constants.SendCommandTimeout, execute: timeout)
		
		Socket.service.send(data: serializeCommand, completion: {
			DispatchQueue.main.sync {
				
				LOG.D("send command vehicle api request: \(command)")
				
				VehicleCommandRequestService.set(commandRequestModel: commandRequestModel)
				
				timeout.cancel()
			}
		})
	}
	
	private func update<T>(observable: WriteObservable<T>, with model: T, notify: Bool) {
		
		if notify {
			observable.value = model
		} else {
			observable.updateWithoutNotifyObserver(value: model)
		}
	}
	
	private func updateObservables(vehicleStatusModel: VehicleStatusModel, for updateTypes: [SocketUpdateType], withNotification: Bool) {
		
		updateTypes.forEach {
			
			switch $0 {
			case .auxheat:		self.update(observable: self.socketObservable.vepAuxheat, with: vehicleStatusModel.auxheat, notify: withNotification)
			case .doors:		self.update(observable: self.socketObservable.vepDoors, with: vehicleStatusModel.doors, notify: withNotification)
			case .ecoScore:		self.update(observable: self.socketObservable.vepEcoScroe, with: vehicleStatusModel.ecoScore, notify: withNotification)
			case .engine:		self.update(observable: self.socketObservable.vepEngine, with: vehicleStatusModel.engine, notify: withNotification)
			case .eventTime:	self.update(observable: self.socketObservable.vepEventTime, with: vehicleStatusModel.eventTimestamp, notify: withNotification)
			case .hu:			self.update(observable: self.socketObservable.vepHu, with: vehicleStatusModel.hu, notify: withNotification)
			case .location:		self.update(observable: self.socketObservable.vepLocation, with: vehicleStatusModel.location, notify: withNotification)
			case .statistics:	self.update(observable: self.socketObservable.vepStatistics, with: vehicleStatusModel.statistics, notify: withNotification)
			case .status:		self.update(observable: self.socketObservable.vepStatus, with: vehicleStatusModel, notify: withNotification)
			case .tank:			self.update(observable: self.socketObservable.vepTank, with: vehicleStatusModel.tank, notify: withNotification)
			case .theft:		self.update(observable: self.socketObservable.vepTheft, with: vehicleStatusModel.theft, notify: withNotification)
			case .tires:		self.update(observable: self.socketObservable.vepTires, with: vehicleStatusModel.tires, notify: withNotification)
			case .vehicle:		self.update(observable: self.socketObservable.vepVehicle, with: vehicleStatusModel.vehicle, notify: withNotification)
			case .warnings:		self.update(observable: self.socketObservable.vepWarnings, with: vehicleStatusModel.warnings, notify: withNotification)
			case .windows:		self.update(observable: self.socketObservable.vepWindows, with: vehicleStatusModel.windows, notify: withNotification)
			case .zev:			self.update(observable: self.socketObservable.vepZEV, with: vehicleStatusModel.zev, notify: withNotification)
			}
		}
	}
	
	private func notifySocket(data: Data?, sequenceNumber: Int32?) {
		
		guard let data = data,
			let sequenceNumber = sequenceNumber else {
				return
		}
		
		Socket.service.send(data: data) { [weak self] in
			LOG.D("send sequence number: \(sequenceNumber)")
			
			self?.socketObservable.sequnce.value = sequenceNumber
		}
	}
	
	private func unregister(token: MyCarSocketNotificationToken?, includesDisconnet: Bool) {
		
		guard let token = token,
			let index = self.notificationTokens.firstIndex(where: { $0 == token }) else {
				return
		}
		
		self.notificationTokens.remove(at: index)
		
		if includesDisconnet {
			
			if self.notificationTokens.isEmpty {
				
				Socket.service.unregisterAndDisconnectIfPossible(connectionToken: self.socketConnectionToken,
																 receiveDataToken: self.socketReceiveDataToken)
				
				self.socketConnectionToken = nil
				self.socketReceiveDataToken = nil
			}
		}
	}
}

// swiftlint:enable type_body_length

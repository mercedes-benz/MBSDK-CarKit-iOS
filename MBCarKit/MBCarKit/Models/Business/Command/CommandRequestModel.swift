//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - CommandRequestModel

@available(*, deprecated, message: "Use CommandVehicleApiRequestModel instead.")
class CommandRequestModel: NSObject {
	
	let completion: MBCarKit.CommandResult?
	let processId: Int64
	let requestId: String
    var request: CommandRequest?
	
	
	// MARK: - Init
	
    init(completion: MBCarKit.CommandResult?, processId: Int64, requestId: String, request: CommandRequest? = nil) {
		
		self.completion = completion
		self.processId  = processId
		self.requestId  = requestId
        self.request    = request
	}
}


// MARK: - CommandVehicleApiRequestModel

class CommandVehicleApiRequestModel: NSObject {
	
	let commandStatusRawValue: Int
	let completion: MBCarKit.CommandVehicleApiResult?
	let processId: Int64
	let requestId: String
	var request: CommandVehicleApiRequest?
	let vin: String
	
	
	// MARK: - Init
	
	init(commandStatusRawValue: Int, completion: MBCarKit.CommandVehicleApiResult?, processId: Int64, requestId: String, request: CommandVehicleApiRequest? = nil, vin: String) {
		
		self.commandStatusRawValue = commandStatusRawValue
		self.completion            = completion
		self.processId             = processId
		self.requestId             = requestId
		self.request               = request
		self.vin                   = vin
	}
}


// MARK: - VehicleCommandRequestModel

class VehicleCommandRequestModel<T: BaseCommandProtocol>: NSObject {
	
	let completion: MBCarKit.CommandUpdateCallback<T.Error>?
	let requestId: String
	let command: T
	let vin: String
	let fullStatus: Proto_AppTwinCommandStatus?
	
	
	// MARK: - Init
	
	init(completion: MBCarKit.CommandUpdateCallback<T.Error>?, requestId: String, command: T, vin: String, fullStatus: Proto_AppTwinCommandStatus?) {
		
		self.completion   = completion
		self.requestId    = requestId
		self.command      = command
		self.vin          = vin
		self.fullStatus   = fullStatus
	}
}

extension VehicleCommandRequestModel: CommandRequestModelProtocol {
	
	var commandState: Proto_VehicleAPI.CommandState? {
		return self.fullStatus?.state
	}
	
	func callCompletion() {
		
		guard let fullStatus = self.fullStatus else {
			return
		}
		
		let timestamp = Date(timeIntervalSince1970: TimeInterval(fullStatus.timestampInMs) / 1000)
		let metaData = CommandProcessingMetaData(timestamp: timestamp)
		
		switch fullStatus.state {
		case .initiation:
			self.completion?(.updated(state: .accepted), metaData)
			
		case .enqueued:
			self.completion?(.updated(state: .enqueued), metaData)
			
		case .processing:
			self.completion?(.updated(state: .processing), metaData)
			
		case .waiting:
			self.completion?(.updated(state: .waiting), metaData)
			
		case .finished:
			self.completion?(.finished, metaData)
			
		case .failed, .unknownCommandState, .UNRECOGNIZED:
			
			let errors = fullStatus.errors.map { (error) -> T.Error in
				LOG.D("vehicle api command failed with error (code \(error.code)) and message  \"\(error.message)\"")
				return T.Error.fromErrorCode(code: error.code, message: error.message, attributes: error.attributes)
			}
			
			self.completion?(.failed(errors: errors), metaData)
		}
	}
	
	func handleTimeout() {
		
		let metaData = CommandProcessingMetaData(timestamp: Date())
		completion?(.failed(errors: [command.createGenericError(error: .noInternetConnection)]), metaData) // timeout error
	}
	
	func updateFullStatus(with fullStatus: Proto_AppTwinCommandStatus) -> CommandRequestModelProtocol {
		return VehicleCommandRequestModel(completion: completion,
									  requestId: requestId,
									  command: command,
									  vin: vin,
									  fullStatus: fullStatus)
	}
}

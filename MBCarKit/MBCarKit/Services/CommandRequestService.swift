//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - CommandRequestService

@available(*, deprecated, message: "Use CommandVehicleApiRequestService instead.")
class CommandRequestService {
	
	private static let shared = CommandRequestService()
	
	// MARK: Properties
	private var commands: [String: CommandRequestModel] = [:]
	
	
	// MARK: - Public
	
	static func commandRequestModel(processId: Int64) -> CommandRequestModel? {
		return self.shared.commands.values.first(where: { $0.processId == processId })
	}
	
	static func commandRequestModel(uuid: String) -> CommandRequestModel? {
		return self.shared.commands[uuid]
	}
	
	static func remove(for uuid: String?) {
		
		guard let uuid = uuid else {
			return
		}
		
		self.shared.commands.removeValue(forKey: uuid)
	}
	
	static func set(commandRequestModel: CommandRequestModel) {

        if let request = CommandRequestService.commandRequestModel(uuid: commandRequestModel.requestId) {
            commandRequestModel.request = request.request
        }
		self.remove(for: commandRequestModel.requestId)
		self.shared.commands[commandRequestModel.requestId] = commandRequestModel
	}
}


// MARK: - CommandVehicleApiRequestService

class CommandVehicleApiRequestService {
	
	private static let shared = CommandVehicleApiRequestService()
	
	// MARK: Properties
	private var commands: [String: CommandVehicleApiRequestModel] = [:]
	
	
	// MARK: - Public
	
	static func all() -> [CommandVehicleApiRequestModel] {
		return self.shared.commands.map { $0.value }
	}
	
	static func commandVehicleApiRequestModel(processId: Int64) -> CommandVehicleApiRequestModel? {
		return self.shared.commands.values.first(where: { $0.processId == processId })
	}
	
	static func commandVehicleApiRequestModel(uuid: String) -> CommandVehicleApiRequestModel? {
		return self.shared.commands[uuid]
	}
	
	static func remove(for uuid: String?) {
		
		guard let uuid = uuid else {
			return
		}
		
		self.shared.commands.removeValue(forKey: uuid)
	}
	
	static func set(commandVehicleApiRequestModel: CommandVehicleApiRequestModel) {
		
		if let request = CommandVehicleApiRequestService.commandVehicleApiRequestModel(uuid: commandVehicleApiRequestModel.requestId) {
			commandVehicleApiRequestModel.request = request.request
		}
		self.remove(for: commandVehicleApiRequestModel.requestId)
		self.shared.commands[commandVehicleApiRequestModel.requestId] = commandVehicleApiRequestModel
	}
}


// MARK: - VehicleCommandRequestService

class VehicleCommandRequestService {
	
	private static let shared = VehicleCommandRequestService()
	
	
	// MARK: Properties
	
	private var commands: [String: CommandRequestModelProtocol] = [:]
	
	
	// MARK: - Public
	
	static func all() -> [CommandRequestModelProtocol] {
		return self.shared.commands.map { $0.value }
	}
	
	static func commandRequestModelFor(uuid: String) -> CommandRequestModelProtocol? {
		return self.shared.commands[uuid]
	}
	
	static func remove(for uuid: String?) {
		
		guard let uuid = uuid else {
			return
		}
		
		self.shared.commands.removeValue(forKey: uuid)
	}
	
	static func set(commandRequestModel: CommandRequestModelProtocol) {
		
		self.remove(for: commandRequestModel.requestId)
		self.shared.commands[commandRequestModel.requestId] = commandRequestModel
	}
}

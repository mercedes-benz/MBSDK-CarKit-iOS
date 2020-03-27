//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: - Command capabilities

extension DatabaseModelMapper {
	
	// MARK: - BusinessModel
	
	static func map(dbVehicleCommandCapabilitiesModel: DBVehicleCommandCapabilitiesModel) -> CommandCapabilitiesModel {
		
		let capabilities = self.map(dbVehicleCommandCapabilityList: dbVehicleCommandCapabilitiesModel.capabilities)
		return CommandCapabilitiesModel(capabilities: capabilities,
										finOrVin: dbVehicleCommandCapabilitiesModel.finOrVin)
	}
	
	private static func map(dbVehicleCommandCapabilityModel: DBVehicleCommandCapabilityModel) -> CommandCapabilityModel {
		
		let additional = dbVehicleCommandCapabilityModel.additionalInformation.components(separatedBy: ",")
		let commandName = CommandName(rawValue: dbVehicleCommandCapabilityModel.commandName) ?? .unknown
		let parameters: [CommandParameterModel] = dbVehicleCommandCapabilityModel.parameters.map { self.map(dbVehicleCommandParameterModel: $0) }
		
		return CommandCapabilityModel(additionalInformation: additional,
									  commandName: commandName,
									  isAvailable: dbVehicleCommandCapabilityModel.isAvailable,
									  parameters: parameters)
	}
	
	private static func map(dbVehicleCommandCapabilityList: List<DBVehicleCommandCapabilityModel>) -> [CommandCapabilityModel] {
		return dbVehicleCommandCapabilityList.map { self.map(dbVehicleCommandCapabilityModel: $0) }
	}
	
	
	// MARK: - DatabaseModel

	static func map(commandCapabilitiesModel: CommandCapabilitiesModel, dbVehicleCommandCapabilitiesModel: DBVehicleCommandCapabilitiesModel) -> DBVehicleCommandCapabilitiesModel {
		
		dbVehicleCommandCapabilitiesModel.capabilities.removeAll()
		dbVehicleCommandCapabilitiesModel.capabilities.append(objectsIn: self.map(commandCapabilityModels: commandCapabilitiesModel.capabilities))
		
		return dbVehicleCommandCapabilitiesModel
	}
	
	
	// MARK: - Helper
	
	private static func map(commandCapabilityModel: CommandCapabilityModel) -> DBVehicleCommandCapabilityModel {
		
		let dbVehicleCommandCapabilityModel = DBVehicleCommandCapabilityModel()
		dbVehicleCommandCapabilityModel.additionalInformation = commandCapabilityModel.additionalInformation.joined(separator: ",")
		dbVehicleCommandCapabilityModel.commandName = commandCapabilityModel.commandName.rawValue
		dbVehicleCommandCapabilityModel.isAvailable = commandCapabilityModel.isAvailable
		
		dbVehicleCommandCapabilityModel.parameters.removeAll()
		dbVehicleCommandCapabilityModel.parameters.append(objectsIn: self.map(commandParameterModels: commandCapabilityModel.parameters))
		
		return dbVehicleCommandCapabilityModel
	}
	
	private static func map(commandCapabilityModels: [CommandCapabilityModel]) -> [DBVehicleCommandCapabilityModel] {
		return commandCapabilityModels.map { self.map(commandCapabilityModel: $0) }
	}
	
	private static func map(commandParameterModel: CommandParameterModel) -> DBVehicleCommandParameterModel {
		
		let dbVehicleCommandParameterModel = DBVehicleCommandParameterModel()
		dbVehicleCommandParameterModel.allowedBool = commandParameterModel.allowedBools.rawValue
		dbVehicleCommandParameterModel.allowedEnums = commandParameterModel.allowedEnums.map { $0.rawValue }.joined(separator: ",")
		dbVehicleCommandParameterModel.maxValue = commandParameterModel.maxValue
		dbVehicleCommandParameterModel.minValue = commandParameterModel.minValue
		dbVehicleCommandParameterModel.parameterName = commandParameterModel.parameterName.rawValue
		dbVehicleCommandParameterModel.steps = commandParameterModel.steps
		return dbVehicleCommandParameterModel
	}
	
	private static func map(commandParameterModels: [CommandParameterModel]) -> [DBVehicleCommandParameterModel] {
		return commandParameterModels.map { self.map(commandParameterModel: $0) }
	}
	
	private static func map(dbVehicleCommandParameterModel: DBVehicleCommandParameterModel) -> CommandParameterModel {
		
		let allowedBool = CommandAllowedBool(rawValue: dbVehicleCommandParameterModel.allowedBool) ?? .unknown
		let allowedEnums = dbVehicleCommandParameterModel.allowedEnums.components(separatedBy: ",").compactMap { CommandAllowedEnum(rawValue: $0) }
		let parameterName = CommandParameterName(rawValue: dbVehicleCommandParameterModel.parameterName) ?? .unknown
		
		return CommandParameterModel(allowedBools: allowedBool,
									 allowedEnums: allowedEnums,
									 maxValue: dbVehicleCommandParameterModel.maxValue,
									 minValue: dbVehicleCommandParameterModel.minValue,
									 parameterName: parameterName,
									 steps: dbVehicleCommandParameterModel.steps)
	}
}


// MARK: - SendToCar capabilities

extension DatabaseModelMapper {

    static func map(sendToCarCapabilitiesModel: SendToCarCapabilitiesModel) -> DBSendToCarCapabilitiesModel {
        let dbSendToCarCapabilitiesModel = DBSendToCarCapabilitiesModel()
        dbSendToCarCapabilitiesModel.capabilities.append(objectsIn: sendToCarCapabilitiesModel.capabilities.map { self.map(sendToCarCapabilityModel: $0) })
        return dbSendToCarCapabilitiesModel
    }

    private static func map(sendToCarCapabilityModel: SendToCarCapability) -> DBSendToCarCapabilityModel {
        let dbSendToCarCapabilityModel = DBSendToCarCapabilityModel()
        dbSendToCarCapabilityModel.capabilitiy = sendToCarCapabilityModel.rawValue
        return dbSendToCarCapabilityModel
    }


    static func map(dbSendToCarCapabilitiesModel: DBSendToCarCapabilitiesModel) -> SendToCarCapabilitiesModel {
        return SendToCarCapabilitiesModel(capabilities: dbSendToCarCapabilitiesModel.capabilities.compactMap { (SendToCarCapability(rawValue: $0.capabilitiy )) })
    }

}

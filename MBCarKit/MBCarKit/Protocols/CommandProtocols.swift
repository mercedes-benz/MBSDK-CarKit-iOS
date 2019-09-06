//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import SwiftProtobuf

// MARK: - CommandProtocol

public protocol CommandErrorProtocol {
	static func fromErrorCode(code: String, message: String, attributes: [String: SwiftProtobuf.Google_Protobuf_Value]) -> Self
	func unwrapGenericError() -> GenericCommandError?
}


// MARK: - BaseCommandProtocol

public protocol BaseCommandProtocol {

	associatedtype Error: CommandErrorProtocol
	
	func createGenericError(error: GenericCommandError) -> Error
}


// MARK: - CommandProtocol

public protocol CommandProtocol: BaseCommandProtocol {
	func serialize(with selectedFinOrVin: String, requestId: String) -> Data?
}


// MARK: - CommandPinProtocol

public protocol CommandPinProtocol: BaseCommandProtocol {
	func serialize(with selectedFinOrVin: String, requestId: String, pin: String) -> Data?
}


// MARK: - CommandSerializable

protocol CommandSerializable {
	func populate(commandRequest: inout Proto_CommandRequest)
}


// MARK: - CommandPinSerializable

protocol CommandPinSerializable {
	func populate(commandRequest: inout Proto_CommandRequest, pin: String)
}


// MARK: - CommandRequestModelProtocol

protocol CommandRequestModelProtocol {
	
	var commandState: Proto_VehicleAPI.CommandState? { get }
	var requestId: String { get }
	
	func callCompletion()
	func handleTimeout()
	func updateFullStatus(with fullStatus: Proto_AppTwinCommandStatus) -> CommandRequestModelProtocol
}

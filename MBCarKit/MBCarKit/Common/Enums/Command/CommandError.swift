//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - CommandError

/// Errors for vehicle commands
@available(*, deprecated, message: "Use CommandVehicleApiError instead.")
public enum CommandError: Error {
	case pinInvalid(attempts: Int)
	case ciamIDBlocked(attempts: Int, blockingTimeSeconds: Int64)
	case unknown(id: Int)
}

public extension CommandError {
	
	var code: Int {
		switch self {
		case .pinInvalid:		return 23
		case .ciamIDBlocked:	return 24
		case .unknown(let id):	return id
		}
	}
}

extension CommandError: Equatable {
	
	public static func == (lhs: CommandError, rhs: CommandError) -> Bool {
		return lhs.code == rhs.code
	}
}


// MARK: - CommandVehicleApiError

/// Errors for vehicle api based commands
public struct CommandVehicleApiError {
	
	public let code: String
	public let message: String
	public let subErrors: [CommandVehicleApiError]
}

//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - CommandStatusModel

/// Representation of the command status
@available(*, deprecated, message: "Use CommandStatusVehicleApiModel instead.")
public struct CommandStatusModel {
	
	public let conditionType: CommandConditionType
	public let errors: [CommandError]
	public let processId: Int64
	public let stateType: CommandStateType
	public let timestamp: Int64
}


// MARK: - CommandStatusVehicleApiModel

/// Representation of the vehicle api based command status
public struct CommandStatusVehicleApiModel {
	
	public let errors: [CommandVehicleApiError]
	public let processId: Int64
	public let stateType: CommandVehicleApiStateType
	public let timestamp: Int64
}

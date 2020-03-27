//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public struct CommandParameterModel {
	
	public let allowedBools: CommandAllowedBool
	public let allowedEnums: [CommandAllowedEnum]
	public let maxValue: Double
	public let minValue: Double
	public let parameterName: CommandParameterName
	public let steps: Double
}

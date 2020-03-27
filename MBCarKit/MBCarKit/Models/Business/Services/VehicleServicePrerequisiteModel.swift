//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of prerequisite for a vehicle service
public struct VehicleServicePrerequisiteModel {
	
	public let actions: [ServiceAction]
	public let missingFields: [ServiceMissingFields]
	public let name: PrerequisiteCheck
}

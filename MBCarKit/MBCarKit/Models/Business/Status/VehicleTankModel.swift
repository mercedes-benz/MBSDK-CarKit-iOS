//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of fuel related attributes
public struct VehicleTankModel {
	
	public let adBlueLevel: StatusAttributeType<Int, RatioUnit>
	public let electricLevel: StatusAttributeType<Double, RatioUnit>
	public let electricRange: StatusAttributeType<Int, DistanceUnit>
	public let gasLevel: StatusAttributeType<Double, RatioUnit>
	public let gasRange: StatusAttributeType<Double, DistanceUnit>
	public let liquidLevel: StatusAttributeType<Int, RatioUnit>
	public let liquidRange: StatusAttributeType<Int, DistanceUnit>
}

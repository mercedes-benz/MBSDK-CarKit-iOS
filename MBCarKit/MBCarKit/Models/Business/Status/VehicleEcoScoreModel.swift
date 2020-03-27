//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of eco score related attributes
public struct VehicleEcoScoreModel {
	
	public let accel: StatusAttributeType<Int, RatioUnit>
	public let bonusRange: StatusAttributeType<Double, DistanceUnit>
	public let const: StatusAttributeType<Int, RatioUnit>
	public let freeWhl: StatusAttributeType<Int, RatioUnit>
	public let total: StatusAttributeType<Int, RatioUnit>
}

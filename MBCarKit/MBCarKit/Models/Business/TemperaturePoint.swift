//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of temperature point
public struct TemperaturePointModel {
	
	public let temperature: Int
	public let zone: TemperatureZone
	
	
	// MARK: - Init
	
	public init(temperature: Int, zone: TemperatureZone) {
		
		self.temperature = temperature
		self.zone = zone
	}
}

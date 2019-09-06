//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// State for speed distance unit
@available(*, deprecated, message: "Use SpeedUnit or DistanceUnit instead.")
public enum SpeedDistanceUnit: Int, Codable, CaseIterable {
	
	/// km/h, distance unit: km
	case kmPerH = 1
	
	/// mph, distance unit: miles
	case mPerH = 2
}

//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// State for time format attribute
public enum TimeFormatType: Bool, Codable, CaseIterable {
	case format12 = 0
	case format24 = 1
}


// MARK: - Extension

extension TimeFormatType {
	
	public var toString: String {
		switch self {
		case .format12:	return "12 h"
		case .format24:	return "24 h"
		}
	}
}

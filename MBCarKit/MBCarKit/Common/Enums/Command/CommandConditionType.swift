//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// The condition type of vehicle commands
@available(*, deprecated, message: "Please switch to the Use CommandVehicleApiRequest instead.")
public enum CommandConditionType: CaseIterable {
	case accepted
	case duplicate
	case failed
	case none
	case overwritten
	case rejected
	case success
	case terminate
	case timeout
	case unknown
}


// MARK: - Extension

extension CommandConditionType {
	
	public var title: String {
		switch self {
		case .accepted:		return "accepted"
		case .duplicate:	return "duplicate"
		case .failed:		return "failed"
		case .none:			return "none"
		case .overwritten:	return "overwritten"
		case .rejected:		return "rejected"
		case .success:		return "success"
		case .terminate:	return "terminate"
		case .timeout:		return "timeout"
		case .unknown:		return "-"
		}
	}
}

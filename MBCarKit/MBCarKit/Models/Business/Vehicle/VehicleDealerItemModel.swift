//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of a dealer item of a vehicle
public struct VehicleDealerItemModel {
	
	public let dealerId: String
	public let role: DealerRole
	
	
	// MARK: - Init
	
	public init(dealerId: String, role: DealerRole) {
		
		self.dealerId = dealerId
		self.role     = role
	}
}

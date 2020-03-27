//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of a dealer search item
public struct DealerSearchDealerModel {

	let address: DealerSearchAddressModel
	public let coordinate: CoordinateModel?
    public let name: String
	public let openingHour: DealerOpeningStatus
    public let phone: String?
    public let id: String
	
    public var addressFormatted: String {
        return self.address.street ?? self.address.city ?? ""
    }
}

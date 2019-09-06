//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIVehiclePendingModel: Decodable {
	
	let state: AssignmentPendingState
	let vin: String
}

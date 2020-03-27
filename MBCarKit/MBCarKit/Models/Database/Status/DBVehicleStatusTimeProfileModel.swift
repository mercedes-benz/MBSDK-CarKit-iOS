//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class DBVehicleStatusTimeProfileModel: Object {
	
	dynamic var identifier: Int32 = 0
	dynamic var hour: Int32 = 0
	dynamic var minute: Int32 = 0
	dynamic var active: Bool = false
	
	let days = List<Int32>()
}

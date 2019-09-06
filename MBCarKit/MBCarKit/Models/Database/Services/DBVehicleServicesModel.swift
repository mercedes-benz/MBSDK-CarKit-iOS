//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import RealmSwift

@objcMembers public class DBVehicleServicesModel: Object {
	
	// MARK: Properties
	dynamic var finOrVin: String = ""
	
	let services = List<DBVehicleServiceModel>()
	
	
	// MARK: - Realm
	
	override public static func primaryKey() -> String? {
		return "finOrVin"
	}
}

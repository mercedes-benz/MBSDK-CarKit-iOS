//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import RealmSwift

@objcMembers class DBTopImageModel: Object {
	
	// MARK: Properties
	dynamic var etag: String = ""
	dynamic var imageData: Data?
	dynamic var vin: String = ""
	
	
	// MARK: - Realm
	
	override public static func primaryKey() -> String? {
		return "vin"
	}
}

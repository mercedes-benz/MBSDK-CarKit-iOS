//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import RealmSwift
import MBRealmKit

struct ImageCacheConfig: RealmConfigProtocol {
	
	var deleteRealmIfMigrationNeeded: Bool {
		return true
	}
	var encryptionKey: Data? {
		return nil
	}
	var filename: String {
		return "ImageCache"
	}
	var filesizeToCompact: Int? {
		return 150
	}
	var inMemoryIdentifier: String? {
		return nil
	}
	var migrationBlock: MigrationBlock? {
		return { (migration, oldSchemaVersion) in
			
		}
	}
	var objects: [Object.Type]? {
		return [
			DBImageModel.self,
			DBTopImageModel.self
		]
	}
	var readOnly: Bool {
		return false
	}
	var schemaVersion: UInt64 {
		return 2
	}
}

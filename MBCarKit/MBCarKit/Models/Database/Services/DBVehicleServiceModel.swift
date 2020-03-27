//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import RealmSwift

@objcMembers public class DBVehicleServiceModel: Object {
	
	// MARK: Properties
	dynamic var activationStatus: String = ""
	dynamic var allowedActions: String = ""
	dynamic var categoryName: String = ""
	dynamic var categorySortIndex: Int = 0
	dynamic var id: Int = 0
	dynamic var name: String = ""
	dynamic var pending: String = ""
	dynamic var rights: String = ""
	dynamic var serviceDescription: String?
	dynamic var sortIndex: Int = 0
	dynamic var shortName: String?
	
	let prerequisites = List<DBVehicleServicePrerequisiteModel>()

	let vehicle = LinkingObjects(fromType: DBVehicleServicesModel.self, property: "services")
}

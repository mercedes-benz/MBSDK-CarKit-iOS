//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift
import MBRealmKit

public class DatabaseCommandCapabilitiesService {
	
	// MARK: Typealias
	internal typealias SaveCompletion = () -> Void
	
	public typealias BusinessModelType = CommandCapabilitiesModel
	internal typealias DatabaseModelType = DBVehicleCommandCapabilitiesModel
	
	internal typealias ChangeItem = (_ properties: [PropertyChange]) -> Void
	internal typealias DeletedItems = () -> Void
	internal typealias InitialItem = (BusinessModelType) -> Void
	
	// MARK: Properties
	private static let config = DatabaseConfig()
	private static let realm = RealmLayer<DatabaseModelType>(config: DatabaseCommandCapabilitiesService.config)
	
	
	// MARK: - Public
	
	/// Fetch a command capability from database
	///
	/// - Parameters:
	///   - finOrVin: Vehicle identifier
	/// - Returns: Optional CommandCapabilitiesModel. If there no capability exists the return value is nil.
	public static func item(with finOrVin: String) -> BusinessModelType? {

		let item: DatabaseModelType? = self.realm.item(with: finOrVin)
		guard let dbVehicleCommandCapabilitiesModel = item else {
			return nil
		}
		
		return DatabaseModelMapper.map(dbVehicleCommandCapabilitiesModel: dbVehicleCommandCapabilitiesModel)
	}
	
	
	// MARK: - Internal
	
	static func delete(with finOrVin: String) {
		
		guard let item = self.realm.item(with: finOrVin) else {
			return
		}
		
		self.realm.delete(object: item, method: .cascade, completion: nil)
	}
	
	static func deleteAll(completion: DeletedItems?) {
		
		guard let results = self.realm.all(), results.isEmpty == false else {
			completion?()
			return
		}
		
		self.realm.delete(results: results, method: .cascade) {
			completion?()
		}
	}
	
	static func save(commandCapabilitiesModel: BusinessModelType, finOrVin: String, completion: @escaping SaveCompletion) {
		
		guard let item = self.realm.item(with: finOrVin) else {
			
			let dbVehicleCommandCapabilitiesModel      = DatabaseModelMapper.map(commandCapabilitiesModel: commandCapabilitiesModel,
																				 dbVehicleCommandCapabilitiesModel: DBVehicleCommandCapabilitiesModel())
			dbVehicleCommandCapabilitiesModel.finOrVin = finOrVin
			
			self.realm.save(object: dbVehicleCommandCapabilitiesModel,
							update: true,
							method: .async) {
								completion()
			}

			return
		}
		
		self.realm.edit(item: item, method: .async, editBlock: { (realm, item, editCompletion) in
			
			if item.isInvalidated == false {
				
				let newItem = DatabaseModelMapper.map(commandCapabilitiesModel: commandCapabilitiesModel,
													  dbVehicleCommandCapabilitiesModel: item)
				realm.add(newItem, update: .modified)
			}
			editCompletion()
		}, completion: {
			completion()
		})
	}
}

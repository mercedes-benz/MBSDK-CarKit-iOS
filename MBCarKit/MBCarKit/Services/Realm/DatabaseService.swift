//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift
import MBRealmKit

/// Service for common database handling
public class DatabaseService {
	
	// MARK: Typealias
	
	/// Completion for database transactions
	public typealias Completion = () -> Void
	
	// MARK: Properties
	private static let config = DatabaseConfig()
	private static let realm = RealmLayer<DBVehicleModel>(config: DatabaseService.config)
	
	
	// MARK: - Debug
	public static var encryptionKey: Data {
		return self.realm.config.realm?.configuration.encryptionKey ?? Data(count: 0)
	}
	
	
	// MARK: - Public
	
	/// Delete the complete vehicle attribute database
	///
	/// - Parameters:
	///   - method: Write method async or sync
	public static func deleteAll(method: RealmConstants.RealmWriteMethod) {
		
		switch method {
		case .async:
			guard let results = self.realm.all() else {
				return
			}
			
			self.realm.delete(results: results, method: .cascade, completion: nil)
			
		case .sync:
			self.realm.deleteAll()
		}
	}
	
	/// Fetch a list of selected vehicle to observe any changes of the list
	///
	/// - Parameters:
	///   - initial: Closure with Completion
	///   - update: Closure with Completion
	///   - error: Closure with ErrorCompletion
	/// - Returns: Optional NotificationToken to observe any changes
	public static func fetchSelectVehicle(initial: @escaping Completion, update: @escaping Completion, error: RealmConstants.ErrorCompletion?) -> NotificationToken? {
		return DatabaseVehicleSelectionService.fetch(initial: initial, update: update, error: error)
	}
	
	/// Update the selected vehicle in database
	///
	/// - Parameters:
	///   - finOrVin: Vehicle identifier
	///   - completion: Closure with Completion
	public static func update(finOrVin: String, completion: Completion?) {
		
		let dbModel: DBVehicleModel? = DatabaseVehicleService.item(with: finOrVin)
		guard let dbVehicleModel = dbModel else {
			completion?()
			return
		}
		
		let vehicleModel = DatabaseModelMapper.map(dbVehicleModel: dbVehicleModel)
		DatabaseVehicleSelectionService.update(finOrVin: vehicleModel.finOrVin) {
			completion?()
		}
	}
}

//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift
import MBRealmKit

class DatabaseVehicleStatusService {
	
	// MARK: Typealias
	internal typealias SaveCompletion = () -> Void
	
	internal typealias BusinessModelType = ResultsVehicleStatusProvider.BusinessModelType
	internal typealias DatabaseModelType = ResultsVehicleStatusProvider.DatabaseModelType
	
	internal typealias ChangeItem = (_ properties: [PropertyChange]) -> Void
	internal typealias DeletedItems = () -> Void
	internal typealias InitialItem = (BusinessModelType) -> Void
	internal typealias InitialProvider = (_ provider: ResultsVehicleStatusProvider) -> Void
	internal typealias UpdateProvider = (_ provider: ResultsVehicleStatusProvider, _ deletions: [Int], _ insertions: [Int], _ modifications: [Int]) -> Void
	
	// MARK: Properties
	private static let config = DatabaseConfig()
	private static let realm = RealmLayer<DatabaseModelType>(config: DatabaseVehicleStatusService.config)
	
	
	// MARK: - Public
	
	static func delete(with finOrVin: String, completion: DeletedItems?) {
		
		guard let item = self.realm.item(with: finOrVin) else {
			completion?()
			return
		}
		
		self.realm.delete(object: item, method: .cascade, completion: completion)
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
	
	static func item(with finOrVin: String?) -> BusinessModelType {
		
		guard let finOrVin = finOrVin,
			let item = self.realm.item(with: finOrVin) else {
				return DatabaseModelMapper.map(dbVehicleStatusModel: DBVehicleStatusModel())
			}
		
		return DatabaseModelMapper.map(dbVehicleStatusModel: item)
	}
	
	static func item(with finOrVin: String, initial: @escaping InitialItem, change: @escaping ChangeItem, deleted: @escaping DeletedItems, error: RealmConstants.ErrorCompletion?) -> NotificationToken? {
		
		let item = self.realm.item(with: finOrVin)
		return self.realm.observe(item: item, error: { (observeError) in
			RealmLayer.handle(observeError: observeError, completion: error)
		}, initial: { (item) in
			initial(DatabaseModelMapper.map(dbVehicleStatusModel: item))
		}, change: { (properties) in
			change(properties)
		}, deleted: {
			deleted()
		})
	}
	
	static func save(vehicleStatusModel: BusinessModelType, finOrVin: String, completion: @escaping SaveCompletion) {
		
		guard let item = self.realm.item(with: finOrVin) else {
			
			let dbVehicleStatusModel      = DatabaseModelMapper.map(vehicleStatusModel: vehicleStatusModel,
																	dbVehicleStatus: DBVehicleStatusModel())
			dbVehicleStatusModel.finOrVin = finOrVin
			
			self.realm.save(object: dbVehicleStatusModel,
							update: true,
							method: .async) {
								completion()
			}

			return
		}
		
		self.realm.edit(item: item, method: .async, editBlock: { (realm, item, editCompletion) in
			
			if item.isInvalidated == false {
				
				let newItem = DatabaseModelMapper.map(vehicleStatusModel: vehicleStatusModel, dbVehicleStatus: item)
				realm.add(newItem, update: .modified)
			}
			editCompletion()
		}, completion: {
			completion()
		})
	}
}

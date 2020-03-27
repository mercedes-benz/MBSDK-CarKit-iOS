//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift
import MBRealmKit

public class DatabaseVehicleService {
	
	// MARK: Typealias
	internal typealias AssignmentCompletion = (String?) -> Void
	internal typealias SaveCompletion = () -> Void
	
	public typealias BusinessModelType = ResultsVehicleProvider.BusinessModelType
	internal typealias DatabaseModelType = ResultsVehicleProvider.DatabaseModelType
	
	internal typealias ChangeItem = (_ properties: [PropertyChange]) -> Void
	internal typealias DeletedItems = () -> Void
	internal typealias InitialItem = (BusinessModelType) -> Void
	public typealias InitialProvider = (_ provider: ResultsVehicleProvider) -> Void
	public typealias UpdateProvider = (_ provider: ResultsVehicleProvider, _ deletions: [Int], _ insertions: [Int], _ modifications: [Int]) -> Void
	
	// MARK: Properties
	private static let config = DatabaseConfig()
	private static let realm = RealmLayer<DatabaseModelType>(config: DatabaseVehicleService.config)
	
	
	// MARK: - Public
	
	public static func fetch() -> [BusinessModelType] {
		
		guard let results = self.realm.all()?.toArray(ofType: DatabaseModelType.self) else {
			return []
		}
		
		return DatabaseModelMapper.map(dbVehicleModels: results)
	}
	
	public static func fetch(initial: @escaping InitialProvider, update: @escaping UpdateProvider, error: RealmConstants.ErrorCompletion?) -> NotificationToken? {
		
		let results = self.realm.all()
		return self.realm.observe(results: results, error: { (observeError) in
			RealmLayer.handle(observeError: observeError, completion: error)
		}, initial: { (results) in
			initial(ResultsVehicleProvider(results: results))
		}, update: { (results, deletions, insertions, modifications) in
			update(ResultsVehicleProvider(results: results),
				   deletions,
				   insertions,
				   modifications)
		})
	}
	
	public static func fetchProvider() -> ResultsVehicleProvider? {
		
		guard let results = self.realm.all(),
			results.isEmpty == false else {
				return nil
		}
		
		return ResultsVehicleProvider(results: results)
	}
	
	public static func firstAssignedVehicle() -> BusinessModelType? {
		
		let predicates = [
			NSPredicate(format: "pending != %@", AssignmentPendingState.assigning.rawValue),
			NSPredicate(format: "pending != %@", AssignmentPendingState.deleting.rawValue)
		]
		let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
		
		guard let item = self.realm.all()?.filter(predicate).first else {
			return nil
		}
		
		return DatabaseModelMapper.map(dbVehicleModel: item)
	}
	
	public static func item(with finOrVin: String) -> BusinessModelType? {
		
		let item: DatabaseModelType? = self.item(with: finOrVin)
		guard let dbVehicleModel = item else {
			return nil
		}
		
		return DatabaseModelMapper.map(dbVehicleModel: dbVehicleModel)
	}
	
	
	// MARK: - Internal
	
	static func item(with finOrVin: String) -> DatabaseModelType? {
		return self.realm.item(with: finOrVin)
	}
	
	static func item(with finOrVin: String, initial: @escaping InitialItem, change: @escaping ChangeItem, deleted: @escaping DeletedItems, error: RealmConstants.ErrorCompletion?) -> NotificationToken? {
		
		let item: DatabaseModelType? = self.item(with: finOrVin)
		return self.realm.observe(item: item, error: { (observeError) in
			RealmLayer.handle(observeError: observeError, completion: error)
		}, initial: { (item) in
			initial(DatabaseModelMapper.map(dbVehicleModel: item))
		}, change: { (properties) in
			change(properties)
		}, deleted: {
			deleted()
		})
	}
	
	static func save(vehicleModel: BusinessModelType, completion: @escaping SaveCompletion) {
		
		let item: DatabaseModelType? = self.item(with: vehicleModel.finOrVin)
		guard let dbVehicleModel = item else {
			
			let dbVehicleModel: DBVehicleModel = DatabaseModelMapper.map(vehicleModel: vehicleModel)
			self.realm.save(object: dbVehicleModel,
							update: true,
							method: .async,
							completion: completion)
			return
		}
		
		self.realm.edit(item: dbVehicleModel, method: .async, editBlock: { (_, item, editCompletion) in
			
			if let pending = vehicleModel.pending,
				item.isInvalidated == false {
				item.pending = pending.rawValue
			}
			editCompletion()
		}, completion: completion)
	}
	
	static func save(vehicleModels: [BusinessModelType], completion: @escaping SaveCompletion, needsVehicleSelectionUpdate: @escaping AssignmentCompletion) {

		var preAssignedVin: String?
		
		guard let results = self.realm.all(),
			results.isEmpty == false else {

				let dbVehicleModels = DatabaseModelMapper.map(vehicleModels: vehicleModels)
				self.realm.save(objects: dbVehicleModels,
								update: true,
								method: .async,
								completion: completion)
				return
			}

		var updateVehicles = vehicleModels
		self.realm.edit(results: results, editBlock: { (realm, results, editCompletion) in
			
			/// pre assigned vehicles
			let preAssignResults = results.filter("pending == %@", AssignmentPendingState.assigning.rawValue)
			
			/// delete delta between api and cache
			self.delete(vehicleModels: updateVehicles, realm: realm, results: results)
			
			/// delete all deleting flaged cache items in api
			let deleteResults = results.filter("pending == %@", AssignmentPendingState.deleting.rawValue)
			updateVehicles.removeAll(where: { (vehicle) -> Bool in
				return deleteResults.contains(where: { (dbVehicle) -> Bool in
					return dbVehicle.finOrVin == vehicle.finOrVin
				})
			})
			
			/// compare pre assigned vehicles with updated vehicle
			preAssignedVin = self.selectPreAssignedVehicle(vehicleModels: updateVehicles, results: preAssignResults)
			
			/// update remaining api items
			self.update(vehicles: updateVehicles, realm: realm, results: results)
			
			editCompletion()
		}, completion: {
			
			completion()
			needsVehicleSelectionUpdate(preAssignedVin)
		})
	}
	
	static func update(licensePlate: String, for finOrVin: String, completion: SaveCompletion?) {
		
		let item: DatabaseModelType? = self.item(with: finOrVin)
		guard let dbVehicleModel = item else {
			return
		}
		
		self.realm.edit(item: dbVehicleModel, method: .async, editBlock: { (_, item, editCompletion) in
			
			if item.isInvalidated == false {
				item.licensePlate = licensePlate
			}
			editCompletion()
		}, completion: completion)
	}
	
	static func update(pendingState: AssignmentPendingState, for finOrVin: String, completion: SaveCompletion?) {
		
		let item: DatabaseModelType? = self.item(with: finOrVin)
		guard let dbVehicleModel = item else {
			return
		}
		
		self.realm.edit(item: dbVehicleModel, method: .async, editBlock: { (_, item, editCompletion) in
			
			if item.isInvalidated == false {
				item.pending = pendingState.rawValue
			}
			editCompletion()
		}, completion: completion)
	}
	
	
	// MARK: - Helper
	
	private static func delete(vehicleModels: [BusinessModelType], realm: Realm, results: Results<DatabaseModelType>) {
		
		var predicates = vehicleModels.map { NSPredicate(format: "finOrVin != %@", $0.finOrVin) }
		predicates.append(NSPredicate(format: "pending != %@", AssignmentPendingState.assigning.rawValue))
		let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
		
		results.filter(predicate).forEach {
			
			if $0.isInvalidated == false {
				
				self.deleteDealers(for: $0, realm: realm)
				realm.delete($0)
			}
		}
	}
	
	private static func deleteDealers(for item: DatabaseModelType, realm: Realm) {
		
		guard item.dealers.isEmpty == false &&
			item.dealers.isInvalidated == false else {
				return
		}
		
		item.dealers.delete(method: .cascade, type: DBVehicleDealerItemModel.self)
	}
	
	private static func selectPreAssignedVehicle(vehicleModels: [BusinessModelType], results: Results<DatabaseModelType>) -> String? {
		
		guard results.isEmpty == false else {
			return nil
		}
		
		let predicates = vehicleModels.map { NSPredicate(format: "finOrVin == %@", $0.finOrVin) }
		let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
		
		return results.filter(predicate).first?.finOrVin
	}
	
	private static func update(vehicles: [BusinessModelType], realm: Realm, results: Results<DatabaseModelType>) {
		
		/// update remaining api items
		vehicles.forEach {
			
			let newDbVehicleModel: DatabaseModelType = DatabaseModelMapper.map(vehicleModel: $0)
			
			if let dbVehicleModel = results.filter("finOrVin == %@", $0.finOrVin).first {
				
				if dbVehicleModel.isInvalidated == false &&
					dbVehicleModel.isEqual(newDbVehicleModel) == false {
					
					self.deleteDealers(for: dbVehicleModel, realm: realm)
					realm.add(newDbVehicleModel, update: .modified)
				}
			} else {
				realm.add(newDbVehicleModel, update: .all)
			}
		}
	}
}

//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift
import MBRealmKit

class DatabaseUserManagementService {
	
	// MARK: Typealias
	
	internal typealias BusinessModelType = ResultsUserManagementProvider.BusinessModelType
	internal typealias DatabaseModelType = ResultsUserManagementProvider.DatabaseModelType
	
	internal typealias ChangeItem = (_ properties: [PropertyChange]) -> Void
	internal typealias DeletedItems = () -> Void
	internal typealias InitialItem = (BusinessModelType?) -> Void
	internal typealias InitialProvider = (_ provider: ResultsUserManagementProvider) -> Void
    internal typealias SaveCompletion = () -> Void
	internal typealias UpdateProvider = (_ provider: ResultsUserManagementProvider, _ deletions: [Int], _ insertions: [Int], _ modifications: [Int]) -> Void
	
	// MARK: Properties
	private static let config = DatabaseConfig()
	private static let realm = RealmLayer<DatabaseModelType>(config: DatabaseUserManagementService.config)
	
	
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
	
	static func deleteSubuser(with authorizationId: String, from finOrVin: String, completion: DeletedItems?) {

        guard let item = self.realm.item(with: finOrVin) else {
            return
        }

        self.realm.edit(item: item, method: .async, editBlock: { (realm, item, editCompletion) in
            
            if item.isInvalidated == false,
                let index = item.users.firstIndex(where: { $0.authorizationId == authorizationId }) {
                
				item.users.remove(at: index)
				realm.add(item, update: .modified)
            }
            
            editCompletion()
        }, completion: completion)
    }
	
	static func item(with finOrVin: String?) -> BusinessModelType? {
		
		guard let finOrVin = finOrVin, let item = self.realm.item(with: finOrVin) else {
			return nil
		}
		
		return DatabaseModelMapper.map(dbUserManagement: item)
	}
	
	static func item(with finOrVin: String, initial: @escaping InitialItem, change: @escaping ChangeItem, deleted: @escaping DeletedItems, error: RealmConstants.ErrorCompletion?) -> NotificationToken? {
		
		let item = self.realm.item(with: finOrVin)
		return self.realm.observe(item: item, error: { (observeError) in
			RealmLayer.handle(observeError: observeError, completion: error)
		}, initial: { (item) in
			initial(DatabaseModelMapper.map(dbUserManagement: item))
		}, change: { (properties) in
			change(properties)
		}, deleted: {
			deleted()
		})
	}

	static func save(vehicleUserManagement: BusinessModelType, completion: @escaping SaveCompletion) {

		guard let item = self.realm.item(with: vehicleUserManagement.finOrVin) else {
			
			let dbVehicleUserManagement      = DatabaseModelMapper.map(userManagement: vehicleUserManagement,
																	   dbUserManagement: DBVehicleUserManagementModel())
			dbVehicleUserManagement.finOrVin = vehicleUserManagement.finOrVin

			self.realm.save(object: dbVehicleUserManagement,
							update: true,
							method: .async,
							completion: completion)
			return
		}

		self.realm.edit(item: item, method: .async, editBlock: { (realm, item, editCompletion) in

			if item.isInvalidated == false {

				let dbVehicleUserManagement = DatabaseModelMapper.map(userManagement: vehicleUserManagement, dbUserManagement: item)
				realm.add(dbVehicleUserManagement, update: .modified)
			}
			editCompletion()
		}, completion: {
			completion()
		})
	}
    
    static func updateProfileSync(status: VehicleProfileSyncStatus, from finOrVin: String, completion: SaveCompletion?) {
                
        guard let item = self.realm.item(with: finOrVin) else {
            return
        }

        self.realm.edit(item: item, method: .async, editBlock: { (realm, item, editCompletion) in
            
            if item.isInvalidated == false {
                
                item.metaData?.profileSyncStatus = status.rawValue
                realm.add(item, update: .modified)
            }
            editCompletion()
        }, completion: completion)
    }
    
    static func upgradeTemporaryUser(with authorizationId: String, from finOrVin: String, completion: SaveCompletion?) {
               
        guard let item = self.realm.item(with: finOrVin) else {
            return
        }
            
        self.realm.edit(item: item, method: .async, editBlock: { (realm, item, editCompletion) in
            
            if item.isInvalidated == false,
                let index = item.users.firstIndex(where: { $0.authorizationId == authorizationId }) {
                
                item.users.item(at: index)?.validUntil = nil
                realm.add(item, update: .modified)
            }
            editCompletion()
        }, completion: completion)
    }
}

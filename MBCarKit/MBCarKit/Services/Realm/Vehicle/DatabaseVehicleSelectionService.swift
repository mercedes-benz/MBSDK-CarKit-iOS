//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift
import MBRealmKit

class DatabaseVehicleSelectionService {
	
	// MARK: Typealias
	public typealias Completion = () -> Void
	
	internal typealias BusinessModelType = String
	internal typealias DatabaseModelType = DBVehicleSelectionModel
	
	// MARK: Properties
	private static let config = DatabaseConfig()
	private static let realm = RealmLayer<DatabaseModelType>(config: DatabaseVehicleSelectionService.config)
	
	
	// MARK: - Public
	
	static var selectedVehicle: DatabaseModelType? {
		return self.realm.all()?.first
	}
	
	static func delete(completion: Completion?) {
		
		guard let results = self.realm.all() else {
			return
		}
		
		self.realm.delete(results: results, method: .normal, completion: completion)
	}
	
	static func fetch(initial: @escaping Completion, update: @escaping Completion, error: RealmConstants.ErrorCompletion?) -> NotificationToken? {
		
		let results = self.realm.all()
		return self.realm.observe(results: results, error: { (observeError) in
			RealmLayer.handle(observeError: observeError, completion: error)
		}, initial: { (_) in
			initial()
		}, update: { (_, _, _, _) in
			update()
		})
	}
	
	static func save(finOrVin: BusinessModelType, completion: @escaping Completion) {
		
		let object: DatabaseModelType = DatabaseModelMapper.map(finOrVin: finOrVin)
		self.realm.save(object: object,
						update: true,
						method: .async) {
							completion()
		}
	}
	
	static func update(finOrVin: BusinessModelType, completion: @escaping Completion) {
		
		guard let item = self.realm.all()?.first else {
			
			self.save(finOrVin: finOrVin, completion: completion)
			return
		}
		
		self.realm.edit(item: item, method: .async, editBlock: { (_, item, editCompletion) in
			
			if item.isInvalidated == false {
				item.finOrVin = finOrVin
			}
			editCompletion()
		}, completion: completion)
	}
}

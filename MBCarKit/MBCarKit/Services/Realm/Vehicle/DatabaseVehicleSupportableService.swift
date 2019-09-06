//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift
import MBRealmKit

public class DatabaseVehicleSupportableService {
	
	// MARK: Typealias
	public typealias Completion = () -> Void
	
	public typealias BusinessModelType = VehicleSupportableModel
	internal typealias DatabaseModelType = DBVehicleSupportableModel
	
	// MARK: Properties
	private static let config = DatabaseConfig()
	private static let realm = RealmLayer<DatabaseModelType>(config: DatabaseVehicleSupportableService.config)
	
	
	// MARK: - Public
	
	public static func item(with finOrVin: String) -> BusinessModelType? {
		
		guard let item = self.realm.item(with: finOrVin) else {
			return nil
		}
		
		return DatabaseModelMapper.map(dbVehicleSupportableModel: item)
	}
	
	
	// MARK: - Internal
	
	static func delete(with finOrVin: String) {
		
		guard let item = self.realm.item(with: finOrVin) else {
			return
		}
		
		self.realm.delete(object: item, method: .normal, completion: nil)
	}
	
	static func update(finOrVin: String, vehicleSupportableModel: BusinessModelType, completion: Completion?) {
		
		guard let item = self.realm.item(with: finOrVin) else {

			self.save(finOrVin: finOrVin, vehicleSupportableModel: vehicleSupportableModel, completion: completion)
			return
		}

		self.realm.edit(item: item, method: .async, editBlock: { (_, item, editCompletion) in

			if item.isInvalidated == false {
				
				item.canReceiveVACs = vehicleSupportableModel.canReceiveVACs
                item.vehicleConnectivity = vehicleSupportableModel.vehicleConnectivity.rawValue
			}
			
			editCompletion()
		}, completion: completion)
	}
	
	
	// MARK: - Helper
	
	private static func save(finOrVin: String, vehicleSupportableModel: BusinessModelType, completion: Completion?) {
		
		let object: DatabaseModelType = DatabaseModelMapper.map(vehicleSupportableModel: vehicleSupportableModel, finOrVin: finOrVin)
		self.realm.save(object: object,
						update: true,
						method: .async) {
							completion?()
		}
	}
}

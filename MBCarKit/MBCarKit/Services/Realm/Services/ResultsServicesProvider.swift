//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBRealmKit

/// Abstract database provider to access the database model through a business model
public class ResultsServicesProvider: RealmDataSourceProvider<DBVehicleServiceModel, VehicleServiceModel> {
	
	/// Returns the business model based on the database model
	///
	/// - Parameters:
	///   - model: DBVehicleModel
	/// - Returns: Optional VehicleModel
	public override func map(model: DBVehicleServiceModel) -> VehicleServiceModel {
		return DatabaseModelMapper.map(dbVehicleServiceModel: model)
	}
	
	/// Returns a array of business model
	public func allServices() -> [VehicleServiceModel] {
		
		var services = [VehicleServiceModel]()
		for index in 0..<self.count {
			
			guard let service = self.item(at: index) else {
				continue
			}
			services.append(service)
		}
		
		return services
	}
}


/// Abstract database provider to access the database model through a business model
public class ResultsServiceGroupProvider: RealmDataSourceProvider<DBVehicleServiceModel, VehicleServiceGroup> {
	
	/// Returns the business model based on the database model
	///
	/// - Parameters:
	///   - model: DBVehicleModel
	/// - Returns: Optional VehicleModel
	public override func map(model: DBVehicleServiceModel) -> VehicleServiceGroup? {
		
		guard let finOrVin = model.vehicle.first?.finOrVin else {
			return nil
		}
		
		let provider = DatabaseVehicleServicesService.fetchProvider(with: finOrVin,
																	categoryName: model.categoryName)
		return VehicleServiceGroup(group: model.categoryName,
								   provider: provider)
	}
}

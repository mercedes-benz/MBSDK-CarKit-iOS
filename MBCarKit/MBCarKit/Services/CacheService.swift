//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

class CacheService {
	
	typealias Deleted = () -> Void

	// MARK: - Public
	
	class func deleteStatus(for vin: String, completion: Deleted?) {
		DatabaseVehicleStatusService.delete(with: vin, completion: completion)
	}
	
	class func deleteAll() {
		DatabaseService.deleteAll(method: .async)
	}
	
	class func getCurrentStatus() -> VehicleStatusModel {
		return self.getStatus(for: CarKit.selectedFinOrVin)
	}
	
	class func getStatus(for vin: String?) -> VehicleStatusModel {
		return DatabaseVehicleStatusService.item(with: vin)
	}
	
	class func update(statusUpdateModel: VehicleStatusDTO, completion: @escaping DTOModelMapper.CacheSaved) {
		
		if statusUpdateModel.fullUpdate {
			LOG.D("Clearing vehicle status cache for vin \(statusUpdateModel.vin)")
			
			self.deleteStatus(for: statusUpdateModel.vin) {
				self.handle(statusUpdateModel: statusUpdateModel, completion: completion)
			}
		} else {
			self.handle(statusUpdateModel: statusUpdateModel, completion: completion)
		}
	}
	
	
	// MARK: - Helper
	
	private class func handle(statusUpdateModel: VehicleStatusDTO, completion: @escaping DTOModelMapper.CacheSaved) {
		
		let cachedVehicleStatusModel = self.getStatus(for: statusUpdateModel.vin)
		let vehicleStatusTupel: DTOModelMapper.VehicleStatusTupel = DTOModelMapper.map(statusUpdateModel: statusUpdateModel, cachedVehicleStatus: cachedVehicleStatusModel)
		
		DatabaseVehicleStatusService.save(vehicleStatusModel: vehicleStatusTupel.model, finOrVin: statusUpdateModel.vin) {
			completion(vehicleStatusTupel, statusUpdateModel.vin)
		}
	}
}

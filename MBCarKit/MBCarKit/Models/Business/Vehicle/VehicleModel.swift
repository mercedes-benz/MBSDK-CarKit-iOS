//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of vehicle data
public struct VehicleModel {
	
	/// sales related baumuster information
	public let baumuster: String
	public let carline: String?
	public let dataCollectorVersion: DataCollectorVersion?
	public let dealers: [VehicleDealerItemModel]
	public let doorsCount: DoorsCount?
	/// vehicle identifier
	public let fin: String
	public let fuelType: FuelType?
	public let handDrive: HandDriven?
	public let hasAuxHeat: Bool
	/// represent the mopf value from vcb
	public let hasFacelift: Bool
	public let indicatorImageUrl: URL?
	/// Indicates whether the user is owner or user of the vehicle.
	public let isOwner: Bool?
	public let licensePlate: String
	/// correct model name of vehicle
	public let model: String
	public let pending: AssignmentPendingState?
	public let roofType: RoofType?
	public let starArchitecture: StarArchitecture?
	public let tcuHardwareVersion: TcuHardwareVersion?
	public let tcuSoftwareVersion: TcuSoftwareVersion?
	public let tirePressureMonitoringType: TirePressureMonitoringType?
	public let trustLevel: Int
	/// vehicle identifier
	public let vin: String?
	public let windowsLiftCount: WindowsLiftCount?
    public let vehicleConnectivity: VehicleConnectivity?
	public let vehicleSegment: VehicleSegment
}


// MARK: - Extension

extension VehicleModel {
	
	/// vehicle identifier
	public var finOrVin: String {
		
		let vin: String? = {
			return self.vin?.isEmpty == true ? nil : self.vin
		}()
		return vin ?? self.fin
	}
	
	/// preferred sales dealer
	public var salesDealer: VehicleDealerItemModel? {
		return self.dealers.first(where: { $0.role == .sales })
	}
	
	/// preferred service dealer
	public var serviceDealer: VehicleDealerItemModel? {
		return self.dealers.first(where: { $0.role == .service })
	}
}

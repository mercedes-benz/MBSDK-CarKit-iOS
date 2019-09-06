//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIVehicleDataModel: Decodable {
	
	let carline: String?
	let dataCollectorVersion: DataCollectorVersion?
	let dealers: APIVehicleDealerItemsModel?
	let doorsCount: DoorsCount?
	let fin: String?
	let fuelType: FuelType?
	let handDrive: HandDriven?
	let hasAuxHeat: Bool?
	let licensePlate: String?
	let mopf: Bool?
	let roofType: RoofType?
	let salesRelatedInformation: APIVehicleSalesRelatedInformationModel?
	let starArchitecture: StarArchitecture?
	let tcuHardwareVersion: TcuHardwareVersion?
	let tcuSoftwareVersion: TcuSoftwareVersion?
	let technicalInformation: APIVehicleTechnicalInformationModel?
	let tirePressureMonitoringType: TirePressureMonitoringType?
	let trustLevel: Int?
	let vin: String?
	let windowsLiftCount: WindowsLiftCount?
    let vehicleConnectivity: VehicleConnectivity?
	let vehicleSegment: VehicleSegment?
}

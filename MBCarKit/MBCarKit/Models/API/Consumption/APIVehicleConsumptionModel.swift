//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIVehicleConsumptionModel: Decodable {
	
	let averageConsumption: APIVehicleConsumptionEntryModel?
	let consumptionData: APIVehicleConsumptionDataModel?
	let individualLifetimeConsumption: APIVehicleConsumptionEntryModel?
	let individualResetConsumption: APIVehicleConsumptionEntryModel?
	let individualStartConsumption: APIVehicleConsumptionEntryModel?
	let wlptCombinded: APIVehicleConsumptionEntryModel?
}

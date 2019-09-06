//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIVehicleMasterDataModel: Decodable {
	
	let pending: [APIVehiclePendingModel]
	let vehicleMasterDataResponse: [APIVehicleDataModel]
	let vin: String
	
	
	enum CodingKeys: String, CodingKey {
		case pending
		case vehicleMasterDataResponse
		case vin = "Vin"
	}
	
	
	// MARK: - Init
	
	init(from decoder: Decoder) throws {
		
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		self.pending                   = container.decodeArraySafelyIfPresent(APIVehiclePendingModel.self, forKey: .pending) ?? []
		self.vehicleMasterDataResponse = container.decodeArraySafelyIfPresent(APIVehicleDataModel.self, forKey: .vehicleMasterDataResponse) ?? []
		self.vin                       = try container.decode(String.self, forKey: .vin)
	}
}

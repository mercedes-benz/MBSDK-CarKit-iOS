//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

// MARK: - CommandStatusUpdateModel

@available(*, deprecated, message: "Use CommandStatusUpdateVehicleApiModel instead.")
struct CommandStatusUpdateModel {

	let commandStatusModels: [CommandStatusModel]
	let clientMessageData: Data?
	let eventTimestamp: Int64?
	let sequenceNumber: Int32
	let vin: String
}


// MARK: - CommandStatusUpdateVehicleApiModel

struct CommandStatusUpdateVehicleApiModel {
	
	let commandStatusVehicleApiModels: [CommandStatusVehicleApiModel]
	let clientMessageData: Data?
	let sequenceNumber: Int32
	let vin: String
}

// MARK: - VehicleCommandStatusUpdateModel

struct VehicleCommandStatusUpdateModel {
	
	let requestIDs: [String]
	let clientMessageData: Data?
	let sequenceNumber: Int32
	let vin: String
}

//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of vehicle status related attributes
public struct VehicleStatusModel {
	
	public let auxheat: VehicleAuxheatModel
	public let doors: VehicleDoorsModel
	public let ecoScore: VehicleEcoScoreModel
	public let engine: VehicleEngineModel
    public let eventTimestamp: Int64
	public let hu: VehicleHuModel
	public let location: VehicleLocationModel
	public let statistics: VehicleStatisticsModel
	public let tank: VehicleTankModel
	public let theft: VehicleTheftModel
	public let tires: VehicleTiresModel
	public let vehicle: VehicleVehicleModel
	public let warnings: VehicleWarningsModel
	public let windows: VehicleWindowsModel
	public let zev: VehicleZEVModel
}

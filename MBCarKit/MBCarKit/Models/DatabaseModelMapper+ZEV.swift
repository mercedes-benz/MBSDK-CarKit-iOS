//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift

extension DatabaseModelMapper {

	static func map<T: RawRepresentable>(dbVehicleStatusChargeProgramModel model: DBVehicleStatusChargeProgramModel?) -> StatusAttributeType<[VehicleChargeProgramModel], T> where T.RawValue == Int {
        
        let timestamp = model?.timestamp ?? 0
        
        guard let statusType = StatusType(rawValue: model?.status ?? -1) else {
            return .invalid(timestamp: timestamp)
        }
         
        switch statusType {
        case .invalid:
            return .invalid(timestamp: timestamp)
            
        case .notAvailable:
            return .notAvailable(timestamp: timestamp)
            
        case .noValue:
            return .noValue(timestamp: timestamp)
            
        case .valid:
            guard let values = model?.values else {
                return .valid(value: nil, timestamp: timestamp, unit: self.map(dbVehicleStatusChargeProgramModel: model))
            }
            
            let dbVehicleChargeProgramModels: [DBVehicleChargeProgramModel] = values.map { $0 }
            return .valid(value: self.map(dbVehicleChargeProgramModels: dbVehicleChargeProgramModels), timestamp: timestamp, unit: self.map(dbVehicleStatusChargeProgramModel: model))
        }
    }
	
	static func map<T: RawRepresentable>(dbVehicleStatusTariffModel model: DBVehicleStatusTariffModel?) -> StatusAttributeType<[VehicleZEVTariffModel], T> where T.RawValue == Int {
		
		let timestamp = model?.timestamp ?? 0
		
		guard let statusType = StatusType(rawValue: model?.status ?? -1) else {
			return .invalid(timestamp: timestamp)
		}
		
		switch statusType {
		case .invalid:	    return .invalid(timestamp: timestamp)
		case .notAvailable: return .notAvailable(timestamp: timestamp)
		case .noValue:	    return .noValue(timestamp: timestamp)
		case .valid:	    return .valid(value: self.map(dbVehicleStatusTariffModel: model), timestamp: timestamp, unit: self.map(dbVehicleStatusTariffModel: model))
		}
	}
	
	static func map(vehicleChargeProgramModel model: VehicleChargeProgramModel) -> DBVehicleChargeProgramModel {
        
        let dbModel = DBVehicleChargeProgramModel()
        dbModel.autoUnlock = model.autoUnlock
        dbModel.chargeProgram = Int64(model.chargeProgram.rawValue)
        dbModel.clockTimer = model.clockTimer
        dbModel.ecoCharging = model.ecoCharging
        dbModel.locationBasedCharging = model.locationBasedCharging
        dbModel.maxChargingCurrent = Int64(model.maxChargingCurrent)
        dbModel.maxSoc = Int64(model.maxSoc)
        dbModel.weeklyProfile = model.weeklyProfile
        return dbModel
    }
	
	
	// MARK: - Helper
	
    private static func map<T: RawRepresentable>(dbVehicleStatusChargeProgramModel model: DBVehicleStatusChargeProgramModel?) -> VehicleAttributeUnitModel<T> where T.RawValue == Int {
        return VehicleAttributeUnitModel<T>(value: model?.displayValue ?? "", unit: nil)
    }
	
	private static func map<T: RawRepresentable>(dbVehicleStatusTariffModel model: DBVehicleStatusTariffModel?) -> VehicleAttributeUnitModel<T> where T.RawValue == Int {
		return VehicleAttributeUnitModel<T>(value: model?.displayValue ?? "",
											unit: nil)
	}
	
	private static func map(dbVehicleChargeProgramModel model: DBVehicleChargeProgramModel) -> VehicleChargeProgramModel {
        return VehicleChargeProgramModel(autoUnlock: model.autoUnlock,
                                         chargeProgram: ChargingProgram(rawValue: Int(model.chargeProgram)) ?? .default,
                                         clockTimer: model.clockTimer,
                                         ecoCharging: model.ecoCharging,
                                         locationBasedCharging: model.locationBasedCharging,
                                         maxChargingCurrent: Int(model.maxChargingCurrent),
                                         maxSoc: Int(model.maxSoc),
                                         weeklyProfile: model.weeklyProfile)
    }
	
	private static func map(dbVehicleChargeProgramModels models: [DBVehicleChargeProgramModel]) -> [VehicleChargeProgramModel] {
        return models.map { self.map(dbVehicleChargeProgramModel: $0) }
    }
	
	private static func map(dbVehicleStatusTariffModel model: DBVehicleStatusTariffModel?) -> [VehicleZEVTariffModel]? {
		
		guard let rates = model?.rates,
			let times = model?.times else {
				return nil
		}
		
		return zip(rates, times).map { VehicleZEVTariffModel(rate: $0, time: $1) }
	}
}

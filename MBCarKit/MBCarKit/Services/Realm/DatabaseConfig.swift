//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBCommonKit
import MBRealmKit
import RealmSwift

struct DatabaseConfig: RealmConfigProtocol {
	
	var deleteRealmIfMigrationNeeded: Bool {
		return true
	}
	var encryptionKey: Data? {
		return KeychainProviderArchetype.realmEncryptionKey
	}
	var filename: String {
		return "MyCar"
	}
	var filesizeToCompact: Int? {
		return 150
	}
	var inMemoryIdentifier: String? {
		return nil
	}
	var migrationBlock: MigrationBlock? {
		return nil
	}
	var objects: [Object.Type]? {
		return [
			DBVehicleModel.self,
			DBVehicleDealerItemModel.self,
			DBVehicleSelectionModel.self,
			DBVehicleServiceModel.self,
			DBVehicleServicePrerequisiteModel.self,
			DBVehicleServicesModel.self,
			DBVehicleStatusModel.self,
			DBVehicleStatusBoolModel.self,
			DBVehicleStatusDayTimeModel.self,
			DBVehicleStatusDoubleModel.self,
			DBVehicleStatusIntModel.self,
			DBVehicleStatusSocProfileModel.self,
			DBVehicleStatusTariffModel.self,
			DBVehicleSupportableModel.self
		]
	}
	var readOnly: Bool {
		return false
	}
	var schemaVersion: UInt64 {
		return 33
	}
}


// MARK: - DatabaseConfig

//extension DatabaseConfig {
//	
//	fileprivate func migrateTo1(migration: Migration, oldSchemaVersion: UInt64) {
//		
//		if oldSchemaVersion < 1 {
//			// DBVehicleModel
//			// DBVehicleSelectionModel
//		}
//	}
//	
//	fileprivate func migrateTo2(migration: Migration, oldSchemaVersion: UInt64) {
//		
//		if oldSchemaVersion < 2 {
//			// add auxheatState, positionHeading, positionLat, positionLong to DBVehicleStatusModel
//		}
//	}
//	
//	fileprivate func migrateTo3(migration: Migration, oldSchemaVersion: UInt64) {
//		
//		if oldSchemaVersion < 3 {
//			// add sunroofState, tankAdBlueLevel, tankElectricRange, tankFuelRange, tankGasRange,
//			// tirePressureFrontLeft, tirePressureFrontRight, tirePressureRearLeft, tirePressureRearRight
//			// windowFrontLeftState, windowFrontRightState, windowRearLeftState, windowRearRightState to DBVehicleStatusModel
//		}
//	}
//	
//	fileprivate func migrateTo4(migration: Migration, oldSchemaVersion: UInt64) {
//		
//		if oldSchemaVersion < 4 {
//			// add eventTimestamp
//		}
//	}
//	
//	fileprivate func migrateTo5(migration: Migration, oldSchemaVersion: UInt64) {
//		
//		if oldSchemaVersion < 5 {
//			// add all vep attributes
//			// rename fuel to liquid
//		}
//	}
//	
//	fileprivate func migrateTo6(migration: Migration, oldSchemaVersion: UInt64) {
//		
//		if oldSchemaVersion < 6 {
//			// change dbVehicleModel
//		}
//	}
//	
//	fileprivate func migrateTo7(migration: Migration, oldSchemaVersion: UInt64) {
//		
//		if oldSchemaVersion < 7 {
//			// add park damage detection and theft alarm
//		}
//	}
//	
//	fileprivate func migrateTo8(migration: Migration, oldSchemaVersion: UInt64) {
//		
//		if oldSchemaVersion < 8 {
//			// remove image url
//		}
//	}
//	
//	fileprivate func migrateTo9(migration: Migration, oldSchemaVersion: UInt64) {
//		
//		if oldSchemaVersion < 9 {
//			// add trust level
//		}
//	}
//	
//	fileprivate func migrateTo10(migration: Migration, oldSchemaVersion: UInt64) {
//		
//		if oldSchemaVersion < 10 {
//			// add baumuster
//		}
//	}
//	
//	fileprivate func migrateTo11(migration: Migration, oldSchemaVersion: UInt64) {
//		
//		if oldSchemaVersion < 11 {
//			// change value type
//		}
//	}
//	
//	fileprivate func migrateTo12(migration: Migration, oldSchemaVersion: UInt64) {
//		
//		if oldSchemaVersion < 12 {
//			// add fin, finOrVin to DBVehicleModel
//			// change primaryKey DBVehicleModel
//			// change property in DBVehicleSelectionModel
//			// change property in DBVehicleStatusModel
//		}
//	}
//	
//	fileprivate func migrateTo13(migration: Migration, oldSchemaVersion: UInt64) {
//		
//		if oldSchemaVersion < 13 {
//			// add DBVehicleStatusBoolModel, DBVehicleStatusDoubleModel, DBVehicleStatusIntModel
//		}
//	}
//
//	fileprivate func migrateTo14(migration: Migration, oldSchemaVersion: UInt64) {
//
//		if oldSchemaVersion < 14 {
//			// add displayUnit, displayValue to DBVehicleStatusBoolModel
//			// add displayUnit, displayValue to DBVehicleStatusDoubleModel
//			// add displayUnit, displayValue to DBVehicleStatusIntModel
//		}
//	}
//
//	fileprivate func migrateTo15(migration: Migration, oldSchemaVersion: UInt64) {
//
//		if oldSchemaVersion < 15 {
//			// add more static attributes to DBVehicleModel
//		}
//	}
//
//	fileprivate func migrateTo16(migration: Migration, oldSchemaVersion: UInt64) {
//
//		if oldSchemaVersion < 16 {
//			// add more dynamic attributes to DBVehicleStatusModel
//		}
//	}
//}

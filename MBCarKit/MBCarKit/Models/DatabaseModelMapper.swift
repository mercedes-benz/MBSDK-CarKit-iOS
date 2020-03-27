//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift

// swiftlint:disable function_body_length
// swiftlint:disable line_length
// swiftlint:disable type_body_length
// swiftlint:disable file_length

class DatabaseModelMapper {
	
	// MARK: - Public - BusinessModel
	
	static func map(dbImageModel: DBImageModel) -> ImageCacheModel {
		
		let imageType: VehicleImageType = {
			
			if dbImageModel.isPng {
				let size = VehicleImagePNGSize(rawValue: dbImageModel.size) ?? .size1000x295
				return .png(size: size)
			} else {
				let size = VehicleImageJPEGSize(rawValue: dbImageModel.size) ?? .size1000x295
				return .jpeg(size: size)
			}
		}()
		
		return ImageCacheModel(background: VehicleImageBackground(rawValue: dbImageModel.background) ?? .transparent,
							   degrees: dbImageModel.degrees,
							   imageData: dbImageModel.imageData,
							   imageType: imageType)
	}
	
	static func map(dbVehicleModel: DBVehicleModel) -> VehicleModel {
		return VehicleModel(baumuster: dbVehicleModel.baumuster,
							carline: dbVehicleModel.carline,
							dataCollectorVersion: DataCollectorVersion(rawValue: dbVehicleModel.dataCollectorVersion ?? ""),
							dealers: self.map(dbVehicleDealerItemList: dbVehicleModel.dealers),
							doorsCount: DoorsCount(rawValue: dbVehicleModel.doorsCount ?? ""),
							fin: dbVehicleModel.fin,
							fuelType: FuelType(rawValue: dbVehicleModel.fuelType ?? ""),
							handDrive: HandDriven(rawValue: dbVehicleModel.handDrive ?? ""),
							hasAuxHeat: dbVehicleModel.hasAuxHeat,
							hasFacelift: dbVehicleModel.hasFacelift,
							indicatorImageUrl: URL(string: dbVehicleModel.indicatorImageUrl),
							isOwner: dbVehicleModel.isOwner.value,
							licensePlate: dbVehicleModel.licensePlate,
							model: dbVehicleModel.model,
							pending: AssignmentPendingState(rawValue: dbVehicleModel.pending),
							roofType: RoofType(rawValue: dbVehicleModel.roofType ?? ""),
							starArchitecture: StarArchitecture(rawValue: dbVehicleModel.starArchitecture ?? ""),
							tcuHardwareVersion: TcuHardwareVersion(rawValue: dbVehicleModel.tcuHardwareVersion ?? ""),
							tcuSoftwareVersion: TcuSoftwareVersion(rawValue: dbVehicleModel.tcuSoftwareVersion ?? ""),
							tirePressureMonitoringType: TirePressureMonitoringType(rawValue: dbVehicleModel.tirePressureMonitoringType ?? ""),
							trustLevel: dbVehicleModel.trustLevel,
							vin: dbVehicleModel.vin,
                            windowsLiftCount: WindowsLiftCount(rawValue: dbVehicleModel.windowsLiftCount ?? ""),
							vehicleConnectivity: VehicleConnectivity(rawValue: dbVehicleModel.vehicleConnectivity ?? ""),
							vehicleSegment: VehicleSegment(rawValue: dbVehicleModel.vehicleSegment) ?? .default)
	}
	
	static func map(dbVehicleModels: [DBVehicleModel]) -> [VehicleModel] {
		return dbVehicleModels.map { self.map(dbVehicleModel: $0) }
	}
	
	static func map(dbVehicleSelectionModel: DBVehicleSelectionModel) -> String {
		return dbVehicleSelectionModel.finOrVin
	}
	
	static func map(dbVehicleServiceModel: DBVehicleServiceModel) -> VehicleServiceModel {
		
		let activationStaus: ServiceActivationStatus = {
			
			let defaultActivationStatus = ServiceActivationStatus(rawValue: dbVehicleServiceModel.activationStatus) ?? .unknown
			guard let pendingState = ServicePendingState(rawValue: dbVehicleServiceModel.pending),
				pendingState != .none else {
					return defaultActivationStatus
			}
			
			switch pendingState {
			case .activation:	return .activationPending
			case .deactivation:	return .deactivationPending
			case .none:			return defaultActivationStatus
			}
		}()
		
		return VehicleServiceModel(activationStatus: activationStaus,
								   allowedActions: dbVehicleServiceModel.allowedActions.components(separatedBy: ",").compactMap { ServiceAction(rawValue: $0) },
								   description: dbVehicleServiceModel.serviceDescription ?? "",
								   id: dbVehicleServiceModel.id,
								   name: dbVehicleServiceModel.name,
								   prerequisites: dbVehicleServiceModel.prerequisites.map { self.map(dbVehicleServicePrerequisiteModel: $0) },
								   shortName: dbVehicleServiceModel.shortName,
								   rights: dbVehicleServiceModel.rights.components(separatedBy: ",").compactMap { ServiceRight(rawValue: $0) })
	}
	
	static func map(dbVehicleServicePrerequisiteModel: DBVehicleServicePrerequisiteModel) -> VehicleServicePrerequisiteModel {
		return VehicleServicePrerequisiteModel(actions: dbVehicleServicePrerequisiteModel.actions.components(separatedBy: ",").compactMap { ServiceAction(rawValue: $0) },
											   missingFields: dbVehicleServicePrerequisiteModel.missingFields.components(separatedBy: ",").compactMap { ServiceMissingFields(rawValue: $0) },
											   name: PrerequisiteCheck(rawValue: dbVehicleServicePrerequisiteModel.name) ?? .license)
	}
	
	static func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleStatusModel {
		return VehicleStatusModel(auxheat: self.map(dbVehicleStatusModel: dbVehicleStatusModel),
								  doors: self.map(dbVehicleStatusModel: dbVehicleStatusModel),
								  ecoScore: self.map(dbVehicleStatusModel: dbVehicleStatusModel),
								  engine: self.map(dbVehicleStatusModel: dbVehicleStatusModel),
								  eventTimestamp: self.map(int64Value: dbVehicleStatusModel.eventTimestamp.value),
								  hu: self.map(dbVehicleStatusModel: dbVehicleStatusModel),
								  location: self.map(dbVehicleStatusModel: dbVehicleStatusModel),
								  statistics: self.map(dbVehicleStatusModel: dbVehicleStatusModel),
								  tank: self.map(dbVehicleStatusModel: dbVehicleStatusModel),
								  theft: self.map(dbVehicleStatusModel: dbVehicleStatusModel),
								  tires: self.map(dbVehicleStatusModel: dbVehicleStatusModel),
								  vehicle: self.map(dbVehicleStatusModel: dbVehicleStatusModel),
								  warnings: self.map(dbVehicleStatusModel: dbVehicleStatusModel),
								  windows: self.map(dbVehicleStatusModel: dbVehicleStatusModel),
								  zev: self.map(dbVehicleStatusModel: dbVehicleStatusModel))
	}
	
	static func map(dbVehicleSupportableModel: DBVehicleSupportableModel) -> VehicleSupportableModel {
        let vehicleConnectivity = VehicleConnectivity(rawValue: dbVehicleSupportableModel.vehicleConnectivity) ?? .builtin
        return VehicleSupportableModel(canReceiveVACs: dbVehicleSupportableModel.canReceiveVACs,
                                       vehicleConnectivity: vehicleConnectivity)
    }
	
	
	// MARK: - Public - DatabaseModel
	
	static func map(finOrVin: String, serviceGroups: [VehicleServiceGroupModel]) -> DBVehicleServicesModel {
		
		let dbServices      = DBVehicleServicesModel()
		dbServices.finOrVin = finOrVin
		dbServices.services.append(objectsIn: self.map(serviceGroups: serviceGroups))
		return dbServices
	}
	
    static func map(topImageModel model: TopImageModel) -> DBTopImageModel {
		
        let components = List<DBTopImageComponentModel>()
        components.append(objectsIn: model.components.map {  DatabaseModelMapper.map(topImageComponentModel: $0) })
        
		let dbTopImage        = DBTopImageModel()
		dbTopImage.components = components
		dbTopImage.vin        = model.vin
		return dbTopImage
	}
    
    static func map(topImageComponentModel model: TopImageComponentModel) -> DBTopImageComponentModel {
        let dbTopImageComponent = DBTopImageComponentModel()
        dbTopImageComponent.name = model.name
        dbTopImageComponent.imageData = model.imageData
        return dbTopImageComponent
    }
    
    static func map(dbTopImageModel model: DBTopImageModel) -> TopImageModel {
        return TopImageModel(
            vin: model.vin,
            components: model.components.map { DatabaseModelMapper.map(dbTopImageComponentModel: $0) })
    }
    
    static func map(dbTopImageComponentModel model: DBTopImageComponentModel) -> TopImageComponentModel {
        return TopImageComponentModel(name: model.name, imageData: model.imageData)
    }
	
	static func map(requestImage: VehicleImageRequest) -> DBImageModel {
		
		let dbImage        = DBImageModel()
		dbImage.background = requestImage.background.rawValue
		dbImage.centered   = requestImage.centered
		dbImage.degrees    = requestImage.degrees.rawValue
		dbImage.night      = requestImage.night
		dbImage.roofOpen   = requestImage.roofOpen
		
		switch requestImage.size {
		case .jpeg(let size):
			dbImage.isPng = false
			dbImage.size  = size.rawValue
			
		case .png(let size):
			dbImage.isPng = true
			dbImage.size  = size.rawValue
		}
		
		return dbImage
	}
	
	static func map(service: VehicleServiceModel, dbService: DBVehicleServiceModel) {
		
		dbService.activationStatus   = service.activationStatus.rawValue
		dbService.allowedActions     = service.allowedActions.map { $0.rawValue }.joined(separator: ",")
		dbService.name               = service.name
		dbService.rights             = service.rights.map { $0.rawValue }.joined(separator: ",")
		dbService.serviceDescription = service.description
		dbService.shortName          = service.shortName
		dbService.prerequisites.append(objectsIn: self.map(servicePrerequisites: service.prerequisites))
	}
	
	static func map(service: VehicleServiceModel, sortIndex: Int, categoryName: String, categorySortIndex: Int) -> DBVehicleServiceModel {

		let dbService                = DBVehicleServiceModel()
		dbService.activationStatus   = service.activationStatus.rawValue
		dbService.allowedActions     = service.allowedActions.map { $0.rawValue }.joined(separator: ",")
		dbService.categoryName       = categoryName
		dbService.categorySortIndex  = categorySortIndex
		dbService.id                 = service.id
		dbService.name               = service.name
		dbService.rights             = service.rights.map { $0.rawValue }.joined(separator: ",")
		dbService.serviceDescription = service.description
		dbService.sortIndex          = sortIndex
		dbService.shortName          = service.shortName
		dbService.prerequisites.append(objectsIn: self.map(servicePrerequisites: service.prerequisites))
		return dbService
	}
	
	static func map(servicePrerequisite: VehicleServicePrerequisiteModel) -> DBVehicleServicePrerequisiteModel {
		
		let dbPrerequisite           = DBVehicleServicePrerequisiteModel()
		dbPrerequisite.actions       = servicePrerequisite.actions.map { $0.rawValue }.joined(separator: ",")
		dbPrerequisite.missingFields = servicePrerequisite.missingFields.map { $0.rawValue }.joined(separator: ",")
		dbPrerequisite.name          = servicePrerequisite.name.rawValue
		return dbPrerequisite
	}
	
	static func map(servicePrerequisites: [VehicleServicePrerequisiteModel]) -> [DBVehicleServicePrerequisiteModel] {
		return servicePrerequisites.map { self.map(servicePrerequisite: $0) }
	}
	
	static func map(serviceGroups: [VehicleServiceGroupModel]) -> [DBVehicleServiceModel] {
		return serviceGroups.enumerated().flatMap { (categoryIndex, category) -> [DBVehicleServiceModel] in
			return category.services.enumerated().map { (serviceIndex, service) -> DBVehicleServiceModel in
				return self.map(service: service,
								sortIndex: serviceIndex,
								categoryName: category.group,
								categorySortIndex: categoryIndex)
			}
		}
	}
	
	static func map(vehicleModel: VehicleModel) -> DBVehicleModel {
		
		let dbVehicle                        = DBVehicleModel()
		dbVehicle.baumuster                  = vehicleModel.baumuster
		dbVehicle.carline                    = vehicleModel.carline
		dbVehicle.dataCollectorVersion       = vehicleModel.dataCollectorVersion?.rawValue
		dbVehicle.doorsCount                 = vehicleModel.doorsCount?.rawValue
		dbVehicle.fin                        = vehicleModel.fin
		dbVehicle.finOrVin                   = vehicleModel.finOrVin
		dbVehicle.fuelType                   = vehicleModel.fuelType?.rawValue
		dbVehicle.handDrive                  = vehicleModel.handDrive?.rawValue
		dbVehicle.hasAuxHeat                 = vehicleModel.hasAuxHeat
		dbVehicle.hasFacelift                = vehicleModel.hasFacelift
		dbVehicle.indicatorImageUrl          = vehicleModel.indicatorImageUrl?.absoluteString ?? ""
		dbVehicle.isOwner.value              = vehicleModel.isOwner
		dbVehicle.licensePlate               = vehicleModel.licensePlate
		dbVehicle.model                      = vehicleModel.model
		dbVehicle.pending                    = vehicleModel.pending?.rawValue ?? ""
		dbVehicle.roofType                   = vehicleModel.roofType?.rawValue
		dbVehicle.starArchitecture           = vehicleModel.starArchitecture?.rawValue
		dbVehicle.tcuHardwareVersion         = vehicleModel.tcuHardwareVersion?.rawValue
		dbVehicle.tcuSoftwareVersion         = vehicleModel.tcuSoftwareVersion?.rawValue
		dbVehicle.tirePressureMonitoringType = vehicleModel.tirePressureMonitoringType?.rawValue
		dbVehicle.trustLevel                 = vehicleModel.trustLevel
		dbVehicle.vin                        = vehicleModel.vin ?? ""
		dbVehicle.windowsLiftCount           = vehicleModel.windowsLiftCount?.rawValue
		dbVehicle.vehicleConnectivity        = vehicleModel.vehicleConnectivity?.rawValue
		dbVehicle.vehicleSegment             = vehicleModel.vehicleSegment.rawValue
		
		dbVehicle.dealers.append(objectsIn: self.map(vehicleDealerItemModels: vehicleModel.dealers))
		
		return dbVehicle
	}
	
	static func map(vehicleModels: [VehicleModel]) -> [DBVehicleModel] {
		return vehicleModels.map { self.map(vehicleModel: $0) }
	}
	
	static func map(vehicleModel: VehicleModel) -> DBVehicleSelectionModel {
		
		let dbVehicleSelection      = DBVehicleSelectionModel()
		dbVehicleSelection.finOrVin = vehicleModel.finOrVin
		
		return dbVehicleSelection
	}
	
	static func map(vehicleStatusModel: VehicleStatusModel, dbVehicleStatus: DBVehicleStatusModel) -> DBVehicleStatusModel {
		
		dbVehicleStatus.auxheatActive                                  = self.map(statusAttribute: vehicleStatusModel.auxheat.isActive, dbModel: dbVehicleStatus.auxheatActive)
		dbVehicleStatus.auxheatRuntime                                 = self.map(statusAttribute: vehicleStatusModel.auxheat.runtime, dbModel: dbVehicleStatus.auxheatRuntime)
		dbVehicleStatus.auxheatState                                   = self.map(statusAttribute: vehicleStatusModel.auxheat.state, dbModel: dbVehicleStatus.auxheatState)
		dbVehicleStatus.auxheatTime1                                   = self.map(statusAttribute: vehicleStatusModel.auxheat.time1, dbModel: dbVehicleStatus.auxheatTime1)
		dbVehicleStatus.auxheatTime2                                   = self.map(statusAttribute: vehicleStatusModel.auxheat.time2, dbModel: dbVehicleStatus.auxheatTime2)
		dbVehicleStatus.auxheatTime3                                   = self.map(statusAttribute: vehicleStatusModel.auxheat.time3, dbModel: dbVehicleStatus.auxheatTime3)
		dbVehicleStatus.auxheatTimeSelection                           = self.map(statusAttribute: vehicleStatusModel.auxheat.timeSelection, dbModel: dbVehicleStatus.auxheatTimeSelection)
		dbVehicleStatus.auxheatWarnings                                = self.map(statusAttribute: vehicleStatusModel.auxheat.warnings, dbModel: dbVehicleStatus.auxheatWarnings)
		dbVehicleStatus.averageSpeedReset                              = self.map(statusAttribute: vehicleStatusModel.statistics.averageSpeed.reset, dbModel: dbVehicleStatus.averageSpeedReset)
		dbVehicleStatus.averageSpeedStart                              = self.map(statusAttribute: vehicleStatusModel.statistics.averageSpeed.start, dbModel: dbVehicleStatus.averageSpeedStart)
        dbVehicleStatus.chargePrograms                                 = self.map(statusAttribute: vehicleStatusModel.zev.chargePrograms, dbModel: dbVehicleStatus.chargePrograms)
		dbVehicleStatus.chargingActive                                 = self.map(statusAttribute: vehicleStatusModel.zev.chargingActive, dbModel: dbVehicleStatus.chargingActive)
		dbVehicleStatus.chargingError                                  = self.map(statusAttribute: vehicleStatusModel.zev.chargingError, dbModel: dbVehicleStatus.chargingError)
		dbVehicleStatus.chargingMode                                   = self.map(statusAttribute: vehicleStatusModel.zev.chargingMode, dbModel: dbVehicleStatus.chargingMode)
		dbVehicleStatus.chargingPower                                  = self.map(statusAttribute: vehicleStatusModel.zev.chargingPower, dbModel: dbVehicleStatus.chargingPower)
		dbVehicleStatus.chargingStatus                                 = self.map(statusAttribute: vehicleStatusModel.zev.chargingStatus, dbModel: dbVehicleStatus.chargingStatus)
		dbVehicleStatus.decklidLockState                               = self.map(statusAttribute: vehicleStatusModel.doors.decklid.lockState, dbModel: dbVehicleStatus.decklidLockState)
		dbVehicleStatus.decklidStatus                                  = self.map(statusAttribute: vehicleStatusModel.doors.decklid.state, dbModel: dbVehicleStatus.decklidStatus)
		dbVehicleStatus.departureTime                                  = self.map(statusAttribute: vehicleStatusModel.zev.departureTime, dbModel: dbVehicleStatus.departureTime)
		dbVehicleStatus.departureTimeMode                              = self.map(statusAttribute: vehicleStatusModel.zev.departureTimeMode, dbModel: dbVehicleStatus.departureTimeMode)
		dbVehicleStatus.departureTimeSoc                               = self.map(statusAttribute: vehicleStatusModel.zev.departureTimeSoc, dbModel: dbVehicleStatus.departureTimeSoc)
		dbVehicleStatus.departureTimeWeekday                           = self.map(statusAttribute: vehicleStatusModel.zev.departureTimeWeekday, dbModel: dbVehicleStatus.departureTimeWeekday)
		dbVehicleStatus.distanceElectricalReset                        = self.map(statusAttribute: vehicleStatusModel.statistics.electric.distance.reset, dbModel: dbVehicleStatus.distanceElectricalReset)
		dbVehicleStatus.distanceElectricalStart                        = self.map(statusAttribute: vehicleStatusModel.statistics.electric.distance.start, dbModel: dbVehicleStatus.distanceElectricalStart)
		dbVehicleStatus.distanceGasReset                               = self.map(statusAttribute: vehicleStatusModel.statistics.gas.distance.reset, dbModel: dbVehicleStatus.distanceGasReset)
		dbVehicleStatus.distanceGasStart                               = self.map(statusAttribute: vehicleStatusModel.statistics.gas.distance.start, dbModel: dbVehicleStatus.distanceGasStart)
		dbVehicleStatus.distanceReset                                  = self.map(statusAttribute: vehicleStatusModel.statistics.distance.reset, dbModel: dbVehicleStatus.distanceReset)
		dbVehicleStatus.distanceStart                                  = self.map(statusAttribute: vehicleStatusModel.statistics.distance.start, dbModel: dbVehicleStatus.distanceStart)
		dbVehicleStatus.distanceZEReset                                = self.map(statusAttribute: vehicleStatusModel.statistics.distance.ze.reset, dbModel: dbVehicleStatus.distanceZEReset)
		dbVehicleStatus.distanceZEStart                                = self.map(statusAttribute: vehicleStatusModel.statistics.distance.ze.start, dbModel: dbVehicleStatus.distanceZEStart)
		dbVehicleStatus.doorFrontLeftLockState                         = self.map(statusAttribute: vehicleStatusModel.doors.frontLeft.lockState, dbModel: dbVehicleStatus.doorFrontLeftLockState)
		dbVehicleStatus.doorFrontLeftState                             = self.map(statusAttribute: vehicleStatusModel.doors.frontLeft.state, dbModel: dbVehicleStatus.doorFrontLeftState)
		dbVehicleStatus.doorFrontRightLockState                        = self.map(statusAttribute: vehicleStatusModel.doors.frontRight.lockState, dbModel: dbVehicleStatus.doorFrontRightLockState)
		dbVehicleStatus.doorFrontRightState                            = self.map(statusAttribute: vehicleStatusModel.doors.frontRight.state, dbModel: dbVehicleStatus.doorFrontRightState)
		dbVehicleStatus.doorLockStatusGas                              = self.map(statusAttribute: vehicleStatusModel.vehicle.lockGasState, dbModel: dbVehicleStatus.doorLockStatusGas)
		dbVehicleStatus.doorLockStatusOverall                          = self.map(statusAttribute: vehicleStatusModel.doors.lockStatusOverall, dbModel: dbVehicleStatus.doorLockStatusOverall)
		dbVehicleStatus.doorRearLeftLockState                          = self.map(statusAttribute: vehicleStatusModel.doors.rearLeft.lockState, dbModel: dbVehicleStatus.doorRearLeftLockState)
		dbVehicleStatus.doorRearLeftState                              = self.map(statusAttribute: vehicleStatusModel.doors.rearLeft.state, dbModel: dbVehicleStatus.doorRearLeftState)
		dbVehicleStatus.doorRearRightLockState                         = self.map(statusAttribute: vehicleStatusModel.doors.rearRight.lockState, dbModel: dbVehicleStatus.doorRearRightLockState)
		dbVehicleStatus.doorRearRightState                             = self.map(statusAttribute: vehicleStatusModel.doors.rearRight.state, dbModel: dbVehicleStatus.doorRearRightState)
		dbVehicleStatus.doorStatusOverall                              = self.map(statusAttribute: vehicleStatusModel.doors.statusOverall, dbModel: dbVehicleStatus.doorStatusOverall)
		dbVehicleStatus.drivenTimeReset                                = self.map(statusAttribute: vehicleStatusModel.statistics.drivenTime.reset, dbModel: dbVehicleStatus.drivenTimeReset)
		dbVehicleStatus.drivenTimeStart                                = self.map(statusAttribute: vehicleStatusModel.statistics.drivenTime.start, dbModel: dbVehicleStatus.drivenTimeStart)
		dbVehicleStatus.drivenTimeZEReset                              = self.map(statusAttribute: vehicleStatusModel.statistics.drivenTime.ze.reset, dbModel: dbVehicleStatus.drivenTimeZEReset)
		dbVehicleStatus.drivenTimeZEStart                              = self.map(statusAttribute: vehicleStatusModel.statistics.drivenTime.ze.start, dbModel: dbVehicleStatus.drivenTimeZEStart)
		dbVehicleStatus.ecoScoreAccel                                  = self.map(statusAttribute: vehicleStatusModel.ecoScore.accel, dbModel: dbVehicleStatus.ecoScoreAccel)
		dbVehicleStatus.ecoScoreBonusRange                             = self.map(statusAttribute: vehicleStatusModel.ecoScore.bonusRange, dbModel: dbVehicleStatus.ecoScoreBonusRange)
		dbVehicleStatus.ecoScoreConst                                  = self.map(statusAttribute: vehicleStatusModel.ecoScore.const, dbModel: dbVehicleStatus.ecoScoreConst)
		dbVehicleStatus.ecoScoreFreeWhl                                = self.map(statusAttribute: vehicleStatusModel.ecoScore.freeWhl, dbModel: dbVehicleStatus.ecoScoreFreeWhl)
		dbVehicleStatus.ecoScoreTotal                                  = self.map(statusAttribute: vehicleStatusModel.ecoScore.total, dbModel: dbVehicleStatus.ecoScoreTotal)
		dbVehicleStatus.electricConsumptionReset                       = self.map(statusAttribute: vehicleStatusModel.statistics.electric.consumption.reset, dbModel: dbVehicleStatus.electricConsumptionReset)
		dbVehicleStatus.electricConsumptionStart                       = self.map(statusAttribute: vehicleStatusModel.statistics.electric.consumption.start, dbModel: dbVehicleStatus.electricConsumptionStart)
		dbVehicleStatus.electricalRangeSkipIndication                  = self.map(statusAttribute: vehicleStatusModel.warnings.electricalRangeSkipIndication, dbModel: dbVehicleStatus.electricalRangeSkipIndication)
		dbVehicleStatus.endOfChargeTime                                = self.map(statusAttribute: vehicleStatusModel.zev.endOfChargeTime, dbModel: dbVehicleStatus.endOfChargeTime)
		dbVehicleStatus.endOfChargeTimeRelative                        = self.map(statusAttribute: vehicleStatusModel.zev.endOfChargeTimeRelative, dbModel: dbVehicleStatus.endOfChargeTimeRelative)
		dbVehicleStatus.endOfChargeTimeWeekday                         = self.map(statusAttribute: vehicleStatusModel.zev.endOfChargeTimeWeekday, dbModel: dbVehicleStatus.endOfChargeTimeWeekday)
		dbVehicleStatus.engineHoodStatus                               = self.map(statusAttribute: vehicleStatusModel.vehicle.engineHoodStatus, dbModel: dbVehicleStatus.engineHoodStatus)
		dbVehicleStatus.engineState                                    = self.map(statusAttribute: vehicleStatusModel.engine.state, dbModel: dbVehicleStatus.engineState)
		dbVehicleStatus.eventTimestamp.value                           = vehicleStatusModel.eventTimestamp
		dbVehicleStatus.filterParticleLoading                          = self.map(statusAttribute: vehicleStatusModel.vehicle.filterParticaleState, dbModel: dbVehicleStatus.filterParticleLoading)
		dbVehicleStatus.gasConsumptionReset                            = self.map(statusAttribute: vehicleStatusModel.statistics.gas.consumption.reset, dbModel: dbVehicleStatus.gasConsumptionReset)
		dbVehicleStatus.gasConsumptionStart                            = self.map(statusAttribute: vehicleStatusModel.statistics.gas.consumption.start, dbModel: dbVehicleStatus.gasConsumptionStart)
		dbVehicleStatus.hybridWarnings                                 = self.map(statusAttribute: vehicleStatusModel.zev.hybridWarnings, dbModel: dbVehicleStatus.hybridWarnings)
		dbVehicleStatus.ignitionState                                  = self.map(statusAttribute: vehicleStatusModel.engine.ignitionState, dbModel: dbVehicleStatus.ignitionState)
		dbVehicleStatus.interiorProtectionSensorStatus                 = self.map(statusAttribute: vehicleStatusModel.theft.interiorProtectionSensorStatus, dbModel: dbVehicleStatus.interiorProtectionSensorStatus)
        dbVehicleStatus.keyActivationState                 = self.map(statusAttribute: vehicleStatusModel.theft.keyActivationState, dbModel: dbVehicleStatus.keyActivationState)
		dbVehicleStatus.languageHU                                     = self.map(statusAttribute: vehicleStatusModel.hu.language, dbModel: dbVehicleStatus.languageHU)
		dbVehicleStatus.lastParkEvent                                  = self.map(statusAttribute: vehicleStatusModel.theft.collision.lastParkEvent, dbModel: dbVehicleStatus.lastParkEvent)
		dbVehicleStatus.lastTheftWarning                               = self.map(statusAttribute: vehicleStatusModel.theft.lastTheftWarning, dbModel: dbVehicleStatus.lastTheftWarning)
		dbVehicleStatus.lastTheftWarningReason                         = self.map(statusAttribute: vehicleStatusModel.theft.lastTheftWarningReason, dbModel: dbVehicleStatus.lastTheftWarningReason)
		dbVehicleStatus.liquidConsumptionReset                         = self.map(statusAttribute: vehicleStatusModel.statistics.liquid.consumption.reset, dbModel: dbVehicleStatus.liquidConsumptionReset)
		dbVehicleStatus.liquidConsumptionStart                         = self.map(statusAttribute: vehicleStatusModel.statistics.liquid.consumption.start, dbModel: dbVehicleStatus.liquidConsumptionStart)
		dbVehicleStatus.liquidRangeSkipIndication                      = self.map(statusAttribute: vehicleStatusModel.warnings.liquidRangeSkipIndication, dbModel: dbVehicleStatus.liquidRangeSkipIndication)
		dbVehicleStatus.odo                                            = self.map(statusAttribute: vehicleStatusModel.vehicle.odo, dbModel: dbVehicleStatus.odo)
		dbVehicleStatus.maxRange                                       = self.map(statusAttribute: vehicleStatusModel.zev.maxRange, dbModel: dbVehicleStatus.maxRange)
		dbVehicleStatus.maxSoc                                         = self.map(statusAttribute: vehicleStatusModel.zev.maxSoc, dbModel: dbVehicleStatus.maxSoc)
		dbVehicleStatus.maxSocLowerLimit                               = self.map(statusAttribute: vehicleStatusModel.zev.maxSocLowerLimit, dbModel: dbVehicleStatus.maxSocLowerLimit)
		dbVehicleStatus.parkBrakeStatus                                = self.map(statusAttribute: vehicleStatusModel.vehicle.parkBrakeStatus, dbModel: dbVehicleStatus.parkBrakeStatus)
		dbVehicleStatus.parkEventLevel                                 = self.map(statusAttribute: vehicleStatusModel.theft.collision.parkEventLevel, dbModel: dbVehicleStatus.parkEventLevel)
		dbVehicleStatus.parkEventSensorStatus                          = self.map(statusAttribute: vehicleStatusModel.theft.collision.parkEventSensorStatus, dbModel: dbVehicleStatus.parkEventSensorStatus)
		dbVehicleStatus.parkEventType                                  = self.map(statusAttribute: vehicleStatusModel.theft.collision.parkEventType, dbModel: dbVehicleStatus.parkEventType)
		dbVehicleStatus.positionErrorCode                              = self.map(statusAttribute: vehicleStatusModel.location.positionErrorCode, dbModel: dbVehicleStatus.positionErrorCode)
		dbVehicleStatus.positionHeading                                = self.map(statusAttribute: vehicleStatusModel.location.heading, dbModel: dbVehicleStatus.positionHeading)
		dbVehicleStatus.positionLat                                    = self.map(statusAttribute: vehicleStatusModel.location.latitude, dbModel: dbVehicleStatus.positionLat)
		dbVehicleStatus.positionLong                                   = self.map(statusAttribute: vehicleStatusModel.location.longitude, dbModel: dbVehicleStatus.positionLong)
		dbVehicleStatus.precondActive                                  = self.map(statusAttribute: vehicleStatusModel.zev.precondActive, dbModel: dbVehicleStatus.precondActive)
		dbVehicleStatus.precondAtDeparture                             = self.map(statusAttribute: vehicleStatusModel.zev.precondAtDeparture, dbModel: dbVehicleStatus.precondAtDeparture)
		dbVehicleStatus.precondAtDepartureDisable                      = self.map(statusAttribute: vehicleStatusModel.zev.precondAtDepartureDisable, dbModel: dbVehicleStatus.precondAtDepartureDisable)
		dbVehicleStatus.precondDuration                                = self.map(statusAttribute: vehicleStatusModel.zev.precondDuration, dbModel: dbVehicleStatus.precondDuration)
		dbVehicleStatus.precondError                                   = self.map(statusAttribute: vehicleStatusModel.zev.precondError, dbModel: dbVehicleStatus.precondError)
		dbVehicleStatus.precondNow                                     = self.map(statusAttribute: vehicleStatusModel.zev.precondNow, dbModel: dbVehicleStatus.precondNow)
		dbVehicleStatus.precondNowError                                = self.map(statusAttribute: vehicleStatusModel.zev.precondNowError, dbModel: dbVehicleStatus.precondNowError)
		dbVehicleStatus.precondSeatFrontLeft                           = self.map(statusAttribute: vehicleStatusModel.zev.precondSeatFrontLeft, dbModel: dbVehicleStatus.precondSeatFrontLeft)
		dbVehicleStatus.precondSeatFrontRight                          = self.map(statusAttribute: vehicleStatusModel.zev.precondSeatFrontRight, dbModel: dbVehicleStatus.precondSeatFrontRight)
		dbVehicleStatus.precondSeatRearLeft                            = self.map(statusAttribute: vehicleStatusModel.zev.precondSeatRearLeft, dbModel: dbVehicleStatus.precondSeatRearLeft)
		dbVehicleStatus.precondSeatRearRight                           = self.map(statusAttribute: vehicleStatusModel.zev.precondSeatRearRight, dbModel: dbVehicleStatus.precondSeatRearRight)
        dbVehicleStatus.proximityCalculationForVehiclePositionRequired = self.map(statusAttribute: vehicleStatusModel.location.proximityCalculationForVehiclePositionRequired, dbModel: dbVehicleStatus.proximityCalculationForVehiclePositionRequired)
		dbVehicleStatus.remoteStartActive                              = self.map(statusAttribute: vehicleStatusModel.engine.remoteStartIsActive, dbModel: dbVehicleStatus.remoteStartActive)
		dbVehicleStatus.remoteStartEndtime                             = self.map(statusAttribute: vehicleStatusModel.engine.remoteStartEndtime, dbModel: dbVehicleStatus.remoteStartEndtime)
		dbVehicleStatus.remoteStartTemperature                         = self.map(statusAttribute: vehicleStatusModel.engine.remoteStartTemperature, dbModel: dbVehicleStatus.remoteStartTemperature)
		dbVehicleStatus.roofTopStatus                                  = self.map(statusAttribute: vehicleStatusModel.vehicle.roofTopState, dbModel: dbVehicleStatus.roofTopStatus)
		dbVehicleStatus.selectedChargeProgram                          = self.map(statusAttribute: vehicleStatusModel.zev.selectedChargeProgram, dbModel: dbVehicleStatus.selectedChargeProgram)
		dbVehicleStatus.serviceIntervalDays                            = self.map(statusAttribute: vehicleStatusModel.vehicle.serviceIntervalDays, dbModel: dbVehicleStatus.serviceIntervalDays)
		dbVehicleStatus.serviceIntervalDistance                        = self.map(statusAttribute: vehicleStatusModel.vehicle.serviceIntervalDistance, dbModel: dbVehicleStatus.serviceIntervalDistance)
		dbVehicleStatus.smartCharging                                  = self.map(statusAttribute: vehicleStatusModel.zev.smartCharging, dbModel: dbVehicleStatus.smartCharging)
		dbVehicleStatus.smartChargingAtDeparture                       = self.map(statusAttribute: vehicleStatusModel.zev.smartChargingAtDeparture, dbModel: dbVehicleStatus.smartChargingAtDeparture)
		dbVehicleStatus.smartChargingAtDeparture2                      = self.map(statusAttribute: vehicleStatusModel.zev.smartChargingAtDeparture2, dbModel: dbVehicleStatus.smartChargingAtDeparture2)
		dbVehicleStatus.soc                                            = self.map(statusAttribute: vehicleStatusModel.vehicle.soc, dbModel: dbVehicleStatus.soc)
		dbVehicleStatus.socProfile                                     = self.map(statusAttribute: vehicleStatusModel.zev.socProfile, dbModel: dbVehicleStatus.socProfile)
        dbVehicleStatus.speedAlert                                     = self.map(statusAttribute: vehicleStatusModel.vehicle.speedAlert, dbModel: dbVehicleStatus.speedAlert)
		dbVehicleStatus.speedUnitFromIC                                = self.map(statusAttribute: vehicleStatusModel.vehicle.speedUnitFromIC, dbModel: dbVehicleStatus.speedUnitFromIC)
		dbVehicleStatus.starterBatteryState                            = self.map(statusAttribute: vehicleStatusModel.vehicle.starterBatteryState, dbModel: dbVehicleStatus.starterBatteryState)
		dbVehicleStatus.sunroofEventState                              = self.map(statusAttribute: vehicleStatusModel.windows.sunroof.event, dbModel: dbVehicleStatus.sunroofEventState)
		dbVehicleStatus.sunroofEventActive                             = self.map(statusAttribute: vehicleStatusModel.windows.sunroof.isEventActive, dbModel: dbVehicleStatus.sunroofEventActive)
		dbVehicleStatus.sunroofState                                   = self.map(statusAttribute: vehicleStatusModel.windows.sunroof.status, dbModel: dbVehicleStatus.sunroofState)
		dbVehicleStatus.tankAdBlueLevel                                = self.map(statusAttribute: vehicleStatusModel.tank.adBlueLevel, dbModel: dbVehicleStatus.tankAdBlueLevel)
		dbVehicleStatus.tankElectricRange                              = self.map(statusAttribute: vehicleStatusModel.tank.electricRange, dbModel: dbVehicleStatus.tankElectricRange)
		dbVehicleStatus.tankGasLevel                                   = self.map(statusAttribute: vehicleStatusModel.tank.gasLevel, dbModel: dbVehicleStatus.tankGasLevel)
		dbVehicleStatus.tankGasRange                                   = self.map(statusAttribute: vehicleStatusModel.tank.gasRange, dbModel: dbVehicleStatus.tankGasRange)
		dbVehicleStatus.tankLiquidLevel                                = self.map(statusAttribute: vehicleStatusModel.tank.liquidLevel, dbModel: dbVehicleStatus.tankLiquidLevel)
		dbVehicleStatus.tankLiquidRange                                = self.map(statusAttribute: vehicleStatusModel.tank.liquidRange, dbModel: dbVehicleStatus.tankLiquidRange)
		dbVehicleStatus.temperaturePointFrontCenter                    = self.map(statusAttribute: vehicleStatusModel.zev.temperature.frontCenter, dbModel: dbVehicleStatus.temperaturePointFrontCenter)
		dbVehicleStatus.temperaturePointFrontLeft                      = self.map(statusAttribute: vehicleStatusModel.zev.temperature.frontLeft, dbModel: dbVehicleStatus.temperaturePointFrontLeft)
		dbVehicleStatus.temperaturePointFrontRight                     = self.map(statusAttribute: vehicleStatusModel.zev.temperature.frontRight, dbModel: dbVehicleStatus.temperaturePointFrontRight)
		dbVehicleStatus.temperaturePointRearCenter                     = self.map(statusAttribute: vehicleStatusModel.zev.temperature.rearCenter, dbModel: dbVehicleStatus.temperaturePointRearCenter)
		dbVehicleStatus.temperaturePointRearCenter2                    = self.map(statusAttribute: vehicleStatusModel.zev.temperature.rearCenter2, dbModel: dbVehicleStatus.temperaturePointRearCenter2)
		dbVehicleStatus.temperaturePointRearLeft                       = self.map(statusAttribute: vehicleStatusModel.zev.temperature.rearLeft, dbModel: dbVehicleStatus.temperaturePointRearLeft)
		dbVehicleStatus.temperaturePointRearRight                      = self.map(statusAttribute: vehicleStatusModel.zev.temperature.rearRight, dbModel: dbVehicleStatus.temperaturePointRearRight)
		dbVehicleStatus.temperatureUnitHU                              = self.map(statusAttribute: vehicleStatusModel.hu.temperatureType, dbModel: dbVehicleStatus.temperatureUnitHU)
		dbVehicleStatus.theftAlarmActive                               = self.map(statusAttribute: vehicleStatusModel.theft.theftAlarmActive, dbModel: dbVehicleStatus.theftAlarmActive)
		dbVehicleStatus.theftSystemArmed                               = self.map(statusAttribute: vehicleStatusModel.theft.theftSystemArmed, dbModel: dbVehicleStatus.theftSystemArmed)
		dbVehicleStatus.timeFormatHU                                   = self.map(statusAttribute: vehicleStatusModel.hu.timeFormatType, dbModel: dbVehicleStatus.timeFormatHU)
		dbVehicleStatus.tireMarkerFrontLeft                            = self.map(statusAttribute: vehicleStatusModel.tires.frontLeft.warningLevel, dbModel: dbVehicleStatus.tireMarkerFrontLeft)
		dbVehicleStatus.tireMarkerFrontRight                           = self.map(statusAttribute: vehicleStatusModel.tires.frontRight.warningLevel, dbModel: dbVehicleStatus.tireMarkerFrontRight)
		dbVehicleStatus.tireMarkerRearLeft                             = self.map(statusAttribute: vehicleStatusModel.tires.rearLeft.warningLevel, dbModel: dbVehicleStatus.tireMarkerRearLeft)
		dbVehicleStatus.tireMarkerRearRight                            = self.map(statusAttribute: vehicleStatusModel.tires.rearRight.warningLevel, dbModel: dbVehicleStatus.tireMarkerRearRight)
		dbVehicleStatus.tirePressureFrontLeft                          = self.map(statusAttribute: vehicleStatusModel.tires.frontLeft.pressure, dbModel: dbVehicleStatus.tirePressureFrontLeft)
		dbVehicleStatus.tirePressureFrontRight                         = self.map(statusAttribute: vehicleStatusModel.tires.frontRight.pressure, dbModel: dbVehicleStatus.tirePressureFrontRight)
		dbVehicleStatus.tirePressureMeasTimestamp                      = self.map(statusAttribute: vehicleStatusModel.tires.pressureMeasurementTimestamp, dbModel: dbVehicleStatus.tirePressureMeasTimestamp)
		dbVehicleStatus.tirePressureRearLeft                           = self.map(statusAttribute: vehicleStatusModel.tires.rearLeft.pressure, dbModel: dbVehicleStatus.tirePressureRearLeft)
		dbVehicleStatus.tirePressureRearRight                          = self.map(statusAttribute: vehicleStatusModel.tires.rearRight.pressure, dbModel: dbVehicleStatus.tirePressureRearRight)
		dbVehicleStatus.tireSensorAvailable                            = self.map(statusAttribute: vehicleStatusModel.tires.sensorAvailable, dbModel: dbVehicleStatus.tireSensorAvailable)
		dbVehicleStatus.towProtectionSensorStatus                      = self.map(statusAttribute: vehicleStatusModel.theft.towProtectionSensorStatus, dbModel: dbVehicleStatus.towProtectionSensorStatus)
		dbVehicleStatus.trackingStateHU                                = self.map(statusAttribute: vehicleStatusModel.hu.isTrackingEnable, dbModel: dbVehicleStatus.trackingStateHU)
		dbVehicleStatus.vehicleDataConnectionState                     = self.map(statusAttribute: vehicleStatusModel.vehicle.dataConnectionState, dbModel: dbVehicleStatus.vehicleDataConnectionState)
		dbVehicleStatus.vehicleLockState                               = self.map(statusAttribute: vehicleStatusModel.vehicle.vehicleLockState, dbModel: dbVehicleStatus.vehicleLockState)
		dbVehicleStatus.vTime                                          = self.map(statusAttribute: vehicleStatusModel.vehicle.time, dbModel: dbVehicleStatus.vTime)
		dbVehicleStatus.warningBrakeFluid                              = self.map(statusAttribute: vehicleStatusModel.warnings.brakeFluid, dbModel: dbVehicleStatus.warningBrakeFluid)
		dbVehicleStatus.warningBrakeLiningWear                         = self.map(statusAttribute: vehicleStatusModel.warnings.brakeLiningWear, dbModel: dbVehicleStatus.warningBrakeLiningWear)
		dbVehicleStatus.warningCoolantLevelLow                         = self.map(statusAttribute: vehicleStatusModel.warnings.coolantLevelLow, dbModel: dbVehicleStatus.warningCoolantLevelLow)
		dbVehicleStatus.warningEngineLight                             = self.map(statusAttribute: vehicleStatusModel.warnings.engineLight, dbModel: dbVehicleStatus.warningEngineLight)
		dbVehicleStatus.warningTireLamp                                = self.map(statusAttribute: vehicleStatusModel.warnings.tireLamp, dbModel: dbVehicleStatus.warningTireLamp)
		dbVehicleStatus.warningTireLevelPrw                            = self.map(statusAttribute: vehicleStatusModel.warnings.tireLevelPrw, dbModel: dbVehicleStatus.warningTireLevelPrw)
		dbVehicleStatus.warningTireSprw                                = self.map(statusAttribute: vehicleStatusModel.warnings.tireSprw, dbModel: dbVehicleStatus.warningTireSprw)
		dbVehicleStatus.warningTireSrdk                                = self.map(statusAttribute: vehicleStatusModel.tires.warningLevelOverall, dbModel: dbVehicleStatus.warningTireSrdk)
		dbVehicleStatus.warningWashWater                               = self.map(statusAttribute: vehicleStatusModel.warnings.washWater, dbModel: dbVehicleStatus.warningWashWater)
		dbVehicleStatus.weekdaytariff                                  = self.map(statusAttribute: vehicleStatusModel.zev.weekdayTariff, dbModel: dbVehicleStatus.weekdaytariff)
		dbVehicleStatus.weekendtariff                                  = self.map(statusAttribute: vehicleStatusModel.zev.weekendTariff, dbModel: dbVehicleStatus.weekendtariff)
		dbVehicleStatus.weeklyProfile                                  = self.map(statusAttribute: vehicleStatusModel.hu.weeklyProfile, dbModel: dbVehicleStatus.weeklyProfile)
		dbVehicleStatus.weeklySetHU                                    = self.map(statusAttribute: vehicleStatusModel.hu.weeklySetHU, dbModel: dbVehicleStatus.weeklySetHU)
		dbVehicleStatus.windowFrontLeftState                           = self.map(statusAttribute: vehicleStatusModel.windows.frontLeft, dbModel: dbVehicleStatus.windowFrontLeftState)
		dbVehicleStatus.windowFrontRightState                          = self.map(statusAttribute: vehicleStatusModel.windows.frontRight, dbModel: dbVehicleStatus.windowFrontRightState)
		dbVehicleStatus.windowRearLeftState                            = self.map(statusAttribute: vehicleStatusModel.windows.rearLeft, dbModel: dbVehicleStatus.windowRearLeftState)
		dbVehicleStatus.windowRearRightState                           = self.map(statusAttribute: vehicleStatusModel.windows.rearRight, dbModel: dbVehicleStatus.windowRearRightState)
		dbVehicleStatus.windowStatusOverall                            = self.map(statusAttribute: vehicleStatusModel.windows.overallState, dbModel: dbVehicleStatus.windowStatusOverall)
		dbVehicleStatus.zevActive                                      = self.map(statusAttribute: vehicleStatusModel.zev.isActive, dbModel: dbVehicleStatus.zevActive)

		return dbVehicleStatus
	}
	
	static func map(vehicleSupportableModel: VehicleSupportableModel, finOrVin: String) -> DBVehicleSupportableModel {
		
		let dbVehicleSupportable                 = DBVehicleSupportableModel()
		dbVehicleSupportable.canReceiveVACs      = vehicleSupportableModel.canReceiveVACs
		dbVehicleSupportable.finOrVin            = finOrVin
		dbVehicleSupportable.vehicleConnectivity = vehicleSupportableModel.vehicleConnectivity.rawValue
		return dbVehicleSupportable
	}
	
	static func map(finOrVin: String) -> DBVehicleSelectionModel {
		
		let dbVehicleSelectionModel      = DBVehicleSelectionModel()
		dbVehicleSelectionModel.finOrVin = finOrVin
		return dbVehicleSelectionModel
	}
	
	
	// MARK: - Helper - BusinessModel

	private static func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleAuxheatModel {
		return VehicleAuxheatModel(isActive: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.auxheatActive),
								   runtime: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.auxheatRuntime),
								   state: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.auxheatState),
								   time1: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.auxheatTime1),
								   time2: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.auxheatTime2),
								   time3: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.auxheatTime3),
								   timeSelection: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.auxheatTimeSelection),
								   warnings: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.auxheatWarnings))
	}
	
	private static func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleCollisionModel {
		return VehicleCollisionModel(lastParkEvent: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.lastParkEvent),
									 parkEventLevel: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.parkEventLevel),
									 parkEventSensorStatus: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.parkEventSensorStatus),
									 parkEventType: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.parkEventType))
	}
	
	private static func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleDoorsModel {
		
		let decklidLockState: StatusAttributeType<LockStatus, NoUnit>              = self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.decklidLockState)
		let decklidState: StatusAttributeType<DoorStatus, NoUnit>                  = self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.decklidStatus)
		let frontLeftLockState: StatusAttributeType<LockStatus, NoUnit>            = self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.doorFrontLeftLockState)
		let frontRightLockState: StatusAttributeType<LockStatus, NoUnit>           = self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.doorFrontRightLockState)
		let lockStatusOverall: StatusAttributeType<DoorLockOverallStatus, NoUnit>  = self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.doorLockStatusOverall)
		let rearLeftLockState: StatusAttributeType<LockStatus, NoUnit>             = self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.doorRearLeftLockState)
		let rearRightLockState: StatusAttributeType<LockStatus, NoUnit>            = self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.doorRearRightLockState)
		let frontLeftState: StatusAttributeType<DoorStatus, NoUnit>                = self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.doorFrontLeftState)
		let frontRightState: StatusAttributeType<DoorStatus, NoUnit>               = self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.doorFrontRightState)
		let rearLeftState: StatusAttributeType<DoorStatus, NoUnit>                 = self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.doorRearLeftState)
		let rearRightState: StatusAttributeType<DoorStatus, NoUnit>                = self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.doorRearRightState)
		let statusOverall: StatusAttributeType<DoorOverallStatus, NoUnit>          = self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.doorStatusOverall)

		return VehicleDoorsModel(decklid: VehicleDoorModel(lockState: decklidLockState,
														   state: decklidState),
								 frontLeft: VehicleDoorModel(lockState: frontLeftLockState,
															 state: frontLeftState),
								 frontRight: VehicleDoorModel(lockState: frontRightLockState,
															  state: frontRightState),
								 lockStatusOverall: lockStatusOverall,
								 rearLeft: VehicleDoorModel(lockState: rearLeftLockState,
															state: rearLeftState),
								 rearRight: VehicleDoorModel(lockState: rearRightLockState,
															 state: rearRightState),
								 statusOverall: statusOverall)
	}
	
	private static func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleEcoScoreModel {
		return VehicleEcoScoreModel(accel: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.ecoScoreAccel),
									bonusRange: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.ecoScoreBonusRange),
									const: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.ecoScoreConst),
									freeWhl: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.ecoScoreFreeWhl),
									total: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.ecoScoreTotal))
	}
	
	private static func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleEngineModel {
		return VehicleEngineModel(ignitionState: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.ignitionState),
								  remoteStartEndtime: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.remoteStartEndtime),
								  remoteStartIsActive: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.remoteStartActive),
								  remoteStartTemperature: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.remoteStartTemperature),
								  state: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.engineState))
	}
	
	private static func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleHuModel {
		return VehicleHuModel(isTrackingEnable: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.trackingStateHU),
							  language: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.languageHU),
							  temperatureType: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.temperatureUnitHU),
							  timeFormatType: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.timeFormatHU),
							  weeklyProfile: self.map(dbVehicleStatusWeeklyProfileModel: dbVehicleStatusModel.weeklyProfile),
							  weeklySetHU: self.map(dbVehicleStatusDayTimeModel: dbVehicleStatusModel.weeklySetHU))
	}
	
	private static func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleLocationModel {
		return VehicleLocationModel(heading: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.positionHeading),
									latitude: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.positionLat),
                                    longitude: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.positionLong),
                                    positionErrorCode: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.positionErrorCode),
                                    proximityCalculationForVehiclePositionRequired: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.proximityCalculationForVehiclePositionRequired))
	}
    
    private static func map(dbVehicleStatusModel: DBVehicleStatusModel) -> [VehicleSpeedAlertModel] {
        
        var model = [VehicleSpeedAlertModel]()
        
        guard let dbVehicleStatusModelSpeedAlertValues = dbVehicleStatusModel.speedAlert?.values else {

            return model
        }
        for element in dbVehicleStatusModelSpeedAlertValues {
            let vehicleSpeedAlertModel = self.map(dbVehicleStatusSpeedAlertModel: element)
            model.append(vehicleSpeedAlertModel)
        }
        
        return model
    }
	
	private static func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleStatisticsModel {
		
		let averageSpeed = VehicleStatisticResetStartDoubleModel<SpeedUnit>(reset: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.averageSpeedReset),
																			start: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.averageSpeedStart))
		let distance     = VehicleStatisticDistanceModel(reset: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.distanceReset),
														 start: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.distanceStart),
														 ze: VehicleStatisticResetStartIntModel(reset: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.distanceZEReset),
																							 start: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.distanceZEStart)))
		let drivenTime   = VehicleStatisticDrivenTimeModel(reset: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.drivenTimeReset),
														   start: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.drivenTimeStart),
														   ze: VehicleStatisticResetStartIntModel(reset: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.drivenTimeZEReset),
																							   start: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.drivenTimeZEStart)))
		let electric     = VehicleStatisticTankModel(consumption: VehicleStatisticResetStartDoubleModel<ElectricityConsumptionUnit>(reset: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.electricConsumptionReset),
																																	start: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.electricConsumptionStart)),
													 distance: VehicleStatisticResetStartDoubleModel<DistanceUnit>(reset: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.distanceElectricalReset),
																												   start: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.distanceElectricalStart)))
		let gas          = VehicleStatisticTankModel(consumption: VehicleStatisticResetStartDoubleModel<GasConsumptionUnit>(reset: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.gasConsumptionReset),
																															start: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.gasConsumptionStart)),
													 distance: VehicleStatisticResetStartDoubleModel<DistanceUnit>(reset: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.distanceElectricalReset),
																												   start: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.distanceElectricalStart)))
		let liquid       = VehicleStatisticTankModel(consumption: VehicleStatisticResetStartDoubleModel<CombustionConsumptionUnit>(reset: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.liquidConsumptionReset),
																																   start: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.liquidConsumptionStart)),
													 distance: VehicleStatisticResetStartDoubleModel<DistanceUnit>(reset: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.distanceElectricalReset),
																												   start: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.distanceElectricalStart)))
		
		return VehicleStatisticsModel(averageSpeed: averageSpeed,
									  distance: distance,
									  drivenTime: drivenTime,
									  electric: electric,
									  gas: gas,
									  liquid: liquid)
	}
	
	private static func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleSunroofModel {
		return VehicleSunroofModel(event: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.sunroofEventState),
								   isEventActive: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.sunroofEventActive),
								   status: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.sunroofState))
	}
	
	private static func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleTankModel {
		return VehicleTankModel(adBlueLevel: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.tankAdBlueLevel),
								electricLevel: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.soc),
								electricRange: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.tankElectricRange),
								gasLevel: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.tankGasLevel),
								gasRange: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.tankGasRange),
								liquidLevel: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.tankLiquidLevel),
								liquidRange: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.tankLiquidRange))
	}
	
	private static func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleTheftModel {
		return VehicleTheftModel(collision: self.map(dbVehicleStatusModel: dbVehicleStatusModel),
								 interiorProtectionSensorStatus: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.interiorProtectionSensorStatus),
								 keyActivationState: self.map(dbVehicleStatusBoolModel:
								 dbVehicleStatusModel.keyActivationState),
								 lastTheftWarning: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.lastTheftWarning),
								 lastTheftWarningReason: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.lastTheftWarningReason),
								 theftAlarmActive: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.theftAlarmActive),
								 theftSystemArmed: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.theftSystemArmed),
								 towProtectionSensorStatus: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.towProtectionSensorStatus))
	}
	
	private static func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleTiresModel {
		
		let frontLeftMarker: StatusAttributeType<TireMarkerWarning, NoUnit>   = self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.tireMarkerFrontLeft)
		let frontLeftPressure: StatusAttributeType<Double, PressureUnit>      = self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.tirePressureFrontLeft)
		let frontRightMarker: StatusAttributeType<TireMarkerWarning, NoUnit>  = self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.tireMarkerFrontRight)
		let frontRightPressure: StatusAttributeType<Double, PressureUnit>     = self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.tirePressureFrontRight)
		let rearLeftMarker: StatusAttributeType<TireMarkerWarning, NoUnit>    = self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.tireMarkerRearLeft)
		let rearLeftPressure: StatusAttributeType<Double, PressureUnit>       = self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.tirePressureRearLeft)
		let rearRightMarker: StatusAttributeType<TireMarkerWarning, NoUnit>   = self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.tireMarkerRearRight)
		let rearRightPressure: StatusAttributeType<Double, PressureUnit>      = self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.tirePressureRearRight)

		return VehicleTiresModel(frontLeft: VehicleTireModel(pressure: frontLeftPressure,
															 warningLevel: frontLeftMarker),
								 frontRight: VehicleTireModel(pressure: frontRightPressure,
															  warningLevel: frontRightMarker),
								 pressureMeasurementTimestamp: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.tirePressureMeasTimestamp),
								 rearLeft: VehicleTireModel(pressure: rearLeftPressure,
															warningLevel: rearLeftMarker),
								 rearRight: VehicleTireModel(pressure: rearRightPressure,
															 warningLevel: rearRightMarker),
								 sensorAvailable: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.tireSensorAvailable),
								 warningLevelOverall: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.warningTireSrdk))
	}
	
	private static func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleVehicleModel {
		return VehicleVehicleModel(dataConnectionState: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.vehicleDataConnectionState),
								   engineHoodStatus: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.engineHoodStatus),
								   filterParticaleState: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.filterParticleLoading),
								   odo: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.odo),
								   lockGasState: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.doorLockStatusGas),
								   parkBrakeStatus: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.parkBrakeStatus),
								   roofTopState: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.roofTopStatus),
								   serviceIntervalDays: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.serviceIntervalDays),
								   serviceIntervalDistance: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.serviceIntervalDistance),
								   soc: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.soc),
                                   speedAlert: self.map(dbVehicleStatusSpeedAlertModel: dbVehicleStatusModel.speedAlert),
								   speedUnitFromIC: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.speedUnitFromIC),
								   starterBatteryState: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.starterBatteryState),
								   time: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.vTime),
								   vehicleLockState: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.vehicleLockState))
	}
	
	private static func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleWarningsModel {
		return VehicleWarningsModel(brakeFluid: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.warningBrakeFluid),
									brakeLiningWear: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.warningBrakeLiningWear),
									coolantLevelLow: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.warningCoolantLevelLow),
									electricalRangeSkipIndication: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.electricalRangeSkipIndication),
									engineLight: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.warningEngineLight),
									liquidRangeSkipIndication: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.liquidRangeSkipIndication),
									tireLamp: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.warningTireLamp),
									tireLevelPrw: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.warningTireLevelPrw),
									tireSprw: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.warningTireSprw),
									washWater: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.warningWashWater))
	}
	
	private static func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleWindowsModel {
		return VehicleWindowsModel(frontLeft: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.windowFrontLeftState),
								   frontRight: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.windowFrontRightState),
								   overallState: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.windowStatusOverall),
								   rearLeft: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.windowRearLeftState),
								   rearRight: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.windowRearRightState),
								   sunroof: self.map(dbVehicleStatusModel: dbVehicleStatusModel))
	}
	
	private static func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleZEVModel {
        return VehicleZEVModel(chargePrograms: self.map(dbVehicleStatusChargeProgramModel: dbVehicleStatusModel.chargePrograms),
                               chargingActive: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.chargingActive),
							   chargingError: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.chargingError),
							   chargingMode: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.chargingMode),
							   chargingPower: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.chargingPower),
							   chargingStatus: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.chargingStatus),
							   departureTime: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.departureTime),
							   departureTimeMode: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.departureTimeMode),
							   departureTimeSoc: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.departureTimeSoc),
							   departureTimeWeekday: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.departureTimeWeekday),
							   endOfChargeTime: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.endOfChargeTime),
							   endOfChargeTimeRelative: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.endOfChargeTimeRelative),
							   endOfChargeTimeWeekday: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.endOfChargeTimeWeekday),
							   hybridWarnings: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.hybridWarnings),
							   isActive: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.zevActive),
							   maxRange: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.maxRange),
							   maxSoc: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.maxSoc),
							   maxSocLowerLimit: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.maxSocLowerLimit),
							   precondActive: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.precondActive),
							   precondAtDeparture: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.precondAtDeparture),
							   precondAtDepartureDisable: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.precondAtDepartureDisable),
							   precondDuration: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.precondDuration),
							   precondError: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.precondError),
							   precondNow: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.precondNow),
							   precondNowError: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.precondNowError),
							   precondSeatFrontLeft: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.precondSeatFrontLeft),
							   precondSeatFrontRight: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.precondSeatFrontRight),
							   precondSeatRearLeft: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.precondSeatRearLeft),
							   precondSeatRearRight: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.precondSeatRearRight),
							   selectedChargeProgram: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.selectedChargeProgram),
							   smartCharging: self.map(dbVehicleStatusIntModel: dbVehicleStatusModel.smartCharging),
							   smartChargingAtDeparture: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.smartChargingAtDeparture),
							   smartChargingAtDeparture2: self.map(dbVehicleStatusBoolModel: dbVehicleStatusModel.smartChargingAtDeparture2),
							   socProfile: self.map(dbVehicleStatusSocProfileModel: dbVehicleStatusModel.socProfile),
							   temperature: self.map(dbVehicleStatusModel: dbVehicleStatusModel),
							   weekdayTariff: self.map(dbVehicleStatusTariffModel: dbVehicleStatusModel.weekdaytariff),
							   weekendTariff: self.map(dbVehicleStatusTariffModel: dbVehicleStatusModel.weekendtariff))
	}
	
	private static func map(dbVehicleStatusModel: DBVehicleStatusModel) -> VehicleZEVTemperatureModel {
		return VehicleZEVTemperatureModel(frontCenter: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.temperaturePointFrontCenter),
										  frontLeft: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.temperaturePointFrontLeft),
										  frontRight: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.temperaturePointFrontRight),
										  rearCenter: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.temperaturePointRearCenter),
										  rearCenter2: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.temperaturePointRearCenter2),
										  rearLeft: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.temperaturePointRearLeft),
										  rearRight: self.map(dbVehicleStatusDoubleModel: dbVehicleStatusModel.temperaturePointRearRight))
	}
	
	private static func map<T: RawRepresentable>(dbVehicleStatusBoolModel model: DBVehicleStatusBoolModel?) -> StatusAttributeType<Bool, T> where T.RawValue == Int {
		
		let timestamp = model?.timestamp ?? 0
		
		guard let statusType = StatusType(rawValue: model?.status ?? -1) else {
			return .invalid(timestamp: timestamp)
		}
		
		switch statusType {
		case .invalid:	    return .invalid(timestamp: timestamp)
		case .notAvailable: return .notAvailable(timestamp: timestamp)
		case .noValue:	    return .noValue(timestamp: timestamp)
		case .valid:	    return .valid(value: model?.value.value, timestamp: timestamp, unit: self.map(dbVehicleStatusBoolModel: model))
		}
	}
	
	private static func map<T: RawRepresentable>(dbVehicleStatusBoolModel model: DBVehicleStatusBoolModel?) -> VehicleAttributeUnitModel<T> where T.RawValue == Int {
		return VehicleAttributeUnitModel<T>(value: model?.displayValue ?? "",
											unit: T(rawValue: model?.displayUnit.value ?? -1))
	}
	
	private static func map<T: RawRepresentable, U: RawRepresentable>(dbVehicleStatusBoolModel model: DBVehicleStatusBoolModel?) -> StatusAttributeType<T, U> where T.RawValue == Bool, U.RawValue == Int {
		
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
			guard let value = model?.value.value else {
				return .valid(value: nil, timestamp: timestamp, unit: self.map(dbVehicleStatusBoolModel: model))
			}
			return .valid(value: T(rawValue: value), timestamp: timestamp, unit: self.map(dbVehicleStatusBoolModel: model))
		}
	}
	
	private static func map<T: RawRepresentable>(dbVehicleStatusDayTimeModel model: DBVehicleStatusDayTimeModel?) -> StatusAttributeType<[DayTimeModel], T> where T.RawValue == Int {
		
		let timestamp = model?.timestamp ?? 0
		
		guard let statusType = StatusType(rawValue: model?.status ?? -1) else {
			return .invalid(timestamp: timestamp)
		}
		
		switch statusType {
		case .invalid:	    return .invalid(timestamp: timestamp)
		case .notAvailable: return .notAvailable(timestamp: timestamp)
		case .noValue:	    return .noValue(timestamp: timestamp)
		case .valid:	    return .valid(value: self.map(dbVehicleStatusDayTimeModel: model), timestamp: timestamp, unit: self.map(dbVehicleStatusDayTimeModel: model))
		}
	}
	
	private static func map(dbVehicleStatusDayTimeModel model: DBVehicleStatusDayTimeModel?) -> [DayTimeModel]? {
		
		guard let days = model?.days,
			let times = model?.times else {
				return nil
		}
		
		return zip(days, times).compactMap {
			
			guard let day = Day(rawValue: $0) else {
				return nil
			}
			return DayTimeModel(day: day, time: Int($1))
		}
	}
	
	private static func map<T: RawRepresentable>(dbVehicleStatusDayTimeModel model: DBVehicleStatusDayTimeModel?) -> VehicleAttributeUnitModel<T> where T.RawValue == Int {
		return VehicleAttributeUnitModel<T>(value: model?.displayValue ?? "",
											unit: nil)
	}
	
	private static func map<T: RawRepresentable>(dbVehicleStatusWeeklyProfileModel model: DBVehicleStatusWeeklyProfileModel?) -> StatusAttributeType<WeeklyProfileModel, T> where T.RawValue == Int {
		
		let timestamp = model?.timestamp ?? 0
		
		guard let statusType = StatusType(rawValue: model?.status ?? -1) else {
			return .invalid(timestamp: timestamp)
		}
		
		switch statusType {
		case .invalid:	    return .invalid(timestamp: timestamp)
		case .notAvailable: return .notAvailable(timestamp: timestamp)
		case .noValue:	    return .noValue(timestamp: timestamp)
		case .valid:	    return .valid(value: self.map(dbVehicleStatusWeeklyProfileModel: model), timestamp: timestamp, unit: self.map(dbVehicleStatusWeeklyProfileModel: model))
		}
	}
	
	private static func map(dbVehicleStatusWeeklyProfileModel model: DBVehicleStatusWeeklyProfileModel?) -> WeeklyProfileModel? {

		guard let dbModel = model else {
			return nil
		}
		
		let timeProfiles: [TimeProfile] = dbModel.timeProfiles.map { (dbTimeProfileModel) -> TimeProfile in
			
			let days: [Day] = dbTimeProfileModel.days.compactMap { Day(rawValue: Int($0)) }
			return TimeProfile(identifier: Int(dbTimeProfileModel.identifier),
							   hour: Int(dbTimeProfileModel.hour),
							   minute: Int(dbTimeProfileModel.minute),
							   active: dbTimeProfileModel.active,
							   days: Set(days))
		}
		
		return WeeklyProfileModel(singleEntriesActivatable: dbModel.singleTimeProfileEntriesActivatable,
								  maxSlots: Int(dbModel.maxNumberOfWeeklyTimeProfileSlots),
								  maxTimeProfiles: Int(dbModel.maxNumberOfTimeProfiles),
								  currentSlots: Int(dbModel.currentNumberOfTimeProfileSlots),
								  currentTimeProfiles: Int(dbModel.currentNumberOfTimeProfiles),
								  allTimeProfiles: Array(timeProfiles))
	}
	
	private static func map<T: RawRepresentable>(dbVehicleStatusWeeklyProfileModel model: DBVehicleStatusWeeklyProfileModel?) -> VehicleAttributeUnitModel<T> where T.RawValue == Int {
		return VehicleAttributeUnitModel<T>(value: model?.displayValue ?? "",
											unit: nil)
	}
	
	private static func map<T: RawRepresentable>(dbVehicleStatusDoubleModel model: DBVehicleStatusDoubleModel?) -> StatusAttributeType<Double, T> where T.RawValue == Int {
		
		let timestamp = model?.timestamp ?? 0
		
		guard let statusType = StatusType(rawValue: model?.status ?? -1) else {
			return .invalid(timestamp: timestamp)
		}

		switch statusType {
		case .invalid:	    return .invalid(timestamp: timestamp)
		case .notAvailable: return .notAvailable(timestamp: timestamp)
		case .noValue:	    return .noValue(timestamp: timestamp)
		case .valid:	    return .valid(value: model?.value.value, timestamp: timestamp, unit: self.map(dbVehicleStatusDoubleModel: model))
		}
	}
	
	private static func map<T: RawRepresentable>(dbVehicleStatusDoubleModel model: DBVehicleStatusDoubleModel?) -> VehicleAttributeUnitModel<T> where T.RawValue == Int {
		return VehicleAttributeUnitModel<T>(value: model?.displayValue ?? "",
											unit: T(rawValue: model?.displayUnit.value ?? -1))
	}

    private static func map<T: RawRepresentable, U: RawRepresentable>(dbVehicleStatusDoubleModel model: DBVehicleStatusDoubleModel?) -> StatusAttributeType<T, U> where T.RawValue == Double, U.RawValue == Int {
        
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
			guard let value = model?.value.value else {
				return .valid(value: nil, timestamp: timestamp, unit: self.map(dbVehicleStatusDoubleModel: model))
			}
			return .valid(value: T(rawValue: value), timestamp: timestamp, unit: self.map(dbVehicleStatusDoubleModel: model))
        }
    }

	private static func map<T: RawRepresentable>(dbVehicleStatusSpeedAlertModel model: DBVehicleStatusSpeedAlertModel?) -> StatusAttributeType<[VehicleSpeedAlertModel], T> where T.RawValue == Int {
		
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
				return .valid(value: nil, timestamp: timestamp, unit: self.map(dbVehicleStatusSpeedAlertModel: model))
			}
			
			let dbVehicleStatusSpeedAlertModels: [DBVehicleSpeedAlertModel] = values.map { $0 }
			return .valid(value: self.map(dbVehicleStatusSpeedAlertModels: dbVehicleStatusSpeedAlertModels), timestamp: timestamp, unit: self.map(dbVehicleStatusSpeedAlertModel: model))
		}
	}
    
    private static func map(dbVehicleStatusSpeedAlertModels models: [DBVehicleSpeedAlertModel]) -> [VehicleSpeedAlertModel] {
        return models.map { self.map(dbVehicleStatusSpeedAlertModel: $0) }
    }

    private static func map(dbVehicleStatusSpeedAlertModel model: DBVehicleSpeedAlertModel) -> VehicleSpeedAlertModel {
        
        return VehicleSpeedAlertModel(endtime: Int(model.endTime),
                                      threshold: Int(model.threshold),
                                      thresholdDisplayValue: model.thresholdDisplayValue)
    }

    private static func map<T: RawRepresentable>(dbVehicleStatusSpeedAlertModel model: DBVehicleStatusSpeedAlertModel?) -> VehicleAttributeUnitModel<T> where T.RawValue == Int {

        return VehicleAttributeUnitModel<T>(value: model?.displayValue ?? "", unit: nil)
    }

	private static func map<T: RawRepresentable>(dbVehicleStatusIntModel model: DBVehicleStatusIntModel?) -> StatusAttributeType<Int, T> where T.RawValue == Int {
		
		let timestamp = model?.timestamp ?? 0
		
		guard let statusType = StatusType(rawValue: model?.status ?? -1) else {
			return .invalid(timestamp: timestamp)
		}
		
		switch statusType {
		case .invalid:	    return .invalid(timestamp: timestamp)
		case .notAvailable: return .notAvailable(timestamp: timestamp)
		case .noValue:	    return .noValue(timestamp: timestamp)
		case .valid:	    return .valid(value: model?.value.value, timestamp: timestamp, unit: self.map(dbVehicleStatusIntModel: model))
		}
	}

	private static func map<T: RawRepresentable>(dbVehicleStatusIntModel model: DBVehicleStatusIntModel?) -> VehicleAttributeUnitModel<T> where T.RawValue == Int {
		return VehicleAttributeUnitModel<T>(value: model?.displayValue ?? "",
											unit: T(rawValue: model?.displayUnit.value ?? -1))
	}
	
	private static func map<T: RawRepresentable, U: RawRepresentable>(dbVehicleStatusIntModel model: DBVehicleStatusIntModel?) -> StatusAttributeType<T, U> where T.RawValue == Int, U.RawValue == Int {

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
			guard let value = model?.value.value else {
				return .valid(value: nil, timestamp: timestamp, unit: self.map(dbVehicleStatusIntModel: model))
			}
			return .valid(value: T(rawValue: value), timestamp: timestamp, unit: self.map(dbVehicleStatusIntModel: model))
		}
	}
	
	private static func map<T: RawRepresentable>(dbVehicleStatusSocProfileModel model: DBVehicleStatusSocProfileModel?) -> StatusAttributeType<[VehicleZEVSocProfileModel], T> where T.RawValue == Int {
		
		let timestamp = model?.timestamp ?? 0
		
		guard let statusType = StatusType(rawValue: model?.status ?? -1) else {
			return .invalid(timestamp: timestamp)
		}
		
		switch statusType {
		case .invalid:	    return .invalid(timestamp: timestamp)
		case .notAvailable: return .notAvailable(timestamp: timestamp)
		case .noValue:	    return .noValue(timestamp: timestamp)
		case .valid:	    return .valid(value: self.map(dbVehicleStatusSocProfileModel: model), timestamp: timestamp, unit: self.map(dbVehicleStatusSocProfileModel: model))
		}
	}
	
	private static func map<T: RawRepresentable>(dbVehicleStatusSocProfileModel model: DBVehicleStatusSocProfileModel?) -> VehicleAttributeUnitModel<T> where T.RawValue == Int {
		return VehicleAttributeUnitModel<T>(value: model?.displayValue ?? "",
											unit: nil)
	}
	
	private static func map(dbVehicleStatusSocProfileModel model: DBVehicleStatusSocProfileModel?) -> [VehicleZEVSocProfileModel]? {
		
		guard let socs = model?.socs,
			let times = model?.times else {
				return nil
		}
		
		return zip(socs, times).map { VehicleZEVSocProfileModel(soc: $0, time: $1) }
	}
	
    private static func map(int64Value: Int64?) -> Int64 {
        return int64Value ?? 0
    }
	
	private static func map<T: RawRepresentable>(statusAttribute: StatusAttributeType<Bool, T>, dbModel: DBVehicleStatusBoolModel?) -> DBVehicleStatusBoolModel where T.RawValue == Int {

		let newDbModel: DBVehicleStatusBoolModel = {
			guard let dbModel = dbModel else {
				return DBVehicleStatusBoolModel()
			}
			return dbModel
		}()
		newDbModel.displayUnit.value = statusAttribute.unit?.unit?.rawValue
		newDbModel.displayValue      = statusAttribute.unit?.value ?? ""
		newDbModel.status            = statusAttribute.status
		newDbModel.timestamp         = statusAttribute.timestamp ?? 0
		newDbModel.value.value       = statusAttribute.value
		return newDbModel
	}
	
	private static func map<T: RawRepresentable, U: RawRepresentable>(statusAttribute: StatusAttributeType<T, U>, dbModel: DBVehicleStatusBoolModel?) -> DBVehicleStatusBoolModel where T.RawValue == Bool, U.RawValue == Int {
		
		let boolStatusAttribute: StatusAttributeType<Bool, U> = {
			switch statusAttribute {
			case .invalid(let timestamp):						return .invalid(timestamp: timestamp)
			case .notAvailable(let timestamp):					return .notAvailable(timestamp: timestamp)
			case .noValue(let timestamp):						return .noValue(timestamp: timestamp)
			case .valid(let value, let timestamp, let unit):	return .valid(value: value?.rawValue, timestamp: timestamp, unit: unit)
			}
		}()
		
		return self.map(statusAttribute: boolStatusAttribute, dbModel: dbModel)
	}
	
	private static func map<T: RawRepresentable>(statusAttribute: StatusAttributeType<[DayTimeModel], T>, dbModel: DBVehicleStatusDayTimeModel?) -> DBVehicleStatusDayTimeModel where T.RawValue == Int {
		
		let newDbModel: DBVehicleStatusDayTimeModel = {
			guard let dbModel = dbModel else {
				return DBVehicleStatusDayTimeModel()
			}
			return dbModel
		}()
		newDbModel.displayValue = statusAttribute.unit?.value ?? ""
		newDbModel.status       = statusAttribute.status
		newDbModel.timestamp    = statusAttribute.timestamp ?? 0
		
		newDbModel.days.removeAll()
		newDbModel.days.append(objectsIn: statusAttribute.value?.map { $0.day.rawValue } ?? [])
		newDbModel.times.removeAll()
		newDbModel.times.append(objectsIn: statusAttribute.value?.map { $0.time } ?? [])
		
		return newDbModel
	}
	
	private static func map<T: RawRepresentable>(statusAttribute: StatusAttributeType<WeeklyProfileModel, T>, dbModel: DBVehicleStatusWeeklyProfileModel?) -> DBVehicleStatusWeeklyProfileModel where T.RawValue == Int {
		
		let newDbModel: DBVehicleStatusWeeklyProfileModel = {
			guard let dbModel = dbModel else {
				return DBVehicleStatusWeeklyProfileModel()
			}
			return dbModel
		}()
		newDbModel.displayValue = statusAttribute.unit?.value ?? ""
		newDbModel.status       = statusAttribute.status
		newDbModel.timestamp    = statusAttribute.timestamp ?? 0
		
		newDbModel.currentNumberOfTimeProfiles = Int32(statusAttribute.value?.currentTimeProfiles ?? 0)
		newDbModel.currentNumberOfTimeProfileSlots = Int32(statusAttribute.value?.currentSlots ?? 0)
		newDbModel.maxNumberOfTimeProfiles = Int32(statusAttribute.value?.maxTimeProfiles ?? 0)
		newDbModel.maxNumberOfWeeklyTimeProfileSlots = Int32(statusAttribute.value?.maxSlots ?? 0)
		newDbModel.singleTimeProfileEntriesActivatable = statusAttribute.value?.singleEntriesActivatable ?? false
		
		newDbModel.timeProfiles.removeAll()
		newDbModel.timeProfiles.append(objectsIn: statusAttribute.value?.timeProfiles.map { self.map(timeProfile: $0, dbModel: DBVehicleStatusTimeProfileModel()) } ?? [])
		
		return newDbModel
	}
	
	private static func map(timeProfile: TimeProfile, dbModel: DBVehicleStatusTimeProfileModel?) -> DBVehicleStatusTimeProfileModel {
		
		let newDbModel: DBVehicleStatusTimeProfileModel = {
			guard let dbModel = dbModel else {
				return DBVehicleStatusTimeProfileModel()
			}
			return dbModel
		}()
		
		if let id = timeProfile.identifier {
			newDbModel.identifier = Int32(id)
		}
		
		newDbModel.active = timeProfile.active
		newDbModel.hour = Int32(timeProfile.hour)
		newDbModel.minute = Int32(timeProfile.minute)
		newDbModel.days.append(objectsIn: timeProfile.days.map { Int32($0.rawValue) })
		
		return newDbModel
	}
	
	private static func map<T: RawRepresentable>(statusAttribute: StatusAttributeType<Double, T>, dbModel: DBVehicleStatusDoubleModel?) -> DBVehicleStatusDoubleModel where T.RawValue == Int {
		
		let newDbModel: DBVehicleStatusDoubleModel = {
			guard let dbModel = dbModel else {
				return DBVehicleStatusDoubleModel()
			}
			return dbModel
		}()
		newDbModel.displayUnit.value = statusAttribute.unit?.unit?.rawValue
		newDbModel.displayValue      = statusAttribute.unit?.value ?? ""
		newDbModel.status            = statusAttribute.status
		newDbModel.timestamp         = statusAttribute.timestamp ?? 0
		newDbModel.value.value       = statusAttribute.value
		return newDbModel
	}
	
	private static func map<T: RawRepresentable, U: RawRepresentable>(statusAttribute: StatusAttributeType<T, U>, dbModel: DBVehicleStatusDoubleModel?) -> DBVehicleStatusDoubleModel where T.RawValue == Double, U.RawValue == Int {
		
		let doubleStatusAttribute: StatusAttributeType<Double, U> = {
			switch statusAttribute {
			case .invalid(let timestamp):						return .invalid(timestamp: timestamp)
			case .notAvailable(let timestamp):					return .notAvailable(timestamp: timestamp)
			case .noValue(let timestamp):						return .noValue(timestamp: timestamp)
			case .valid(let value, let timestamp, let unit):	return .valid(value: value?.rawValue, timestamp: timestamp, unit: unit)
			}
		}()
		
		return self.map(statusAttribute: doubleStatusAttribute, dbModel: dbModel)
	}
	
	private static func map<T: RawRepresentable>(statusAttribute: StatusAttributeType<Int, T>, dbModel: DBVehicleStatusIntModel?) -> DBVehicleStatusIntModel where T.RawValue == Int {
		
		let newDbModel: DBVehicleStatusIntModel = {
			guard let dbModel = dbModel else {
				return DBVehicleStatusIntModel()
			}
			return dbModel
		}()
		newDbModel.displayUnit.value = statusAttribute.unit?.unit?.rawValue
		newDbModel.displayValue      = statusAttribute.unit?.value ?? ""
		newDbModel.status            = statusAttribute.status
		newDbModel.timestamp         = statusAttribute.timestamp ?? 0
		newDbModel.value.value       = statusAttribute.value
		return newDbModel
	}
	
	private static func map<T: RawRepresentable, U: RawRepresentable>(statusAttribute: StatusAttributeType<T, U>, dbModel: DBVehicleStatusIntModel?) -> DBVehicleStatusIntModel where T.RawValue == Int, U.RawValue == Int {
		
		let intStatusAttribute: StatusAttributeType<Int, U> = {
			switch statusAttribute {
			case .invalid(let timestamp):						return .invalid(timestamp: timestamp)
			case .notAvailable(let timestamp):					return .notAvailable(timestamp: timestamp)
			case .noValue(let timestamp):						return .noValue(timestamp: timestamp)
			case .valid(let value, let timestamp, let unit):	return .valid(value: value?.rawValue, timestamp: timestamp, unit: unit)
			}
		}()
		
		return self.map(statusAttribute: intStatusAttribute, dbModel: dbModel)
	}
    
    private static func map<T: RawRepresentable>(statusAttribute: StatusAttributeType<[VehicleChargeProgramModel], T>, dbModel: DBVehicleStatusChargeProgramModel?) -> DBVehicleStatusChargeProgramModel where T.RawValue == Int {
        
        let newDbModel: DBVehicleStatusChargeProgramModel = {
            guard let dbModel = dbModel else {
                return DBVehicleStatusChargeProgramModel()
            }
            return dbModel
        }()
        newDbModel.displayValue = statusAttribute.unit?.value ?? ""
        newDbModel.status       = statusAttribute.status
        newDbModel.timestamp    = statusAttribute.timestamp ?? 0
        
        newDbModel.values.removeAll()
        newDbModel.values.append(objectsIn: statusAttribute.value?.map { self.map(vehicleChargeProgramModel: $0) } ?? [])
        return newDbModel
    }
    
    private static func map<T: RawRepresentable>(statusAttribute: StatusAttributeType<[VehicleSpeedAlertModel], T>, dbModel: DBVehicleStatusSpeedAlertModel?) -> DBVehicleStatusSpeedAlertModel where T.RawValue == Int {
        
        let newDbModel: DBVehicleStatusSpeedAlertModel = {
            guard let dbModel = dbModel else {
                return DBVehicleStatusSpeedAlertModel()
            }
            return dbModel
        }()
        newDbModel.displayValue = statusAttribute.unit?.value ?? ""
        newDbModel.status       = statusAttribute.status
        newDbModel.timestamp    = statusAttribute.timestamp ?? 0
        
        newDbModel.values.removeAll()
        newDbModel.values.append(objectsIn: statusAttribute.value?.map { self.map(vehicleStatusSpeedAlertModel: $0) } ?? [])
        return newDbModel
    }
	
	private static func map<T: RawRepresentable>(statusAttribute: StatusAttributeType<[VehicleZEVSocProfileModel], T>, dbModel: DBVehicleStatusSocProfileModel?) -> DBVehicleStatusSocProfileModel where T.RawValue == Int {
		
		let newDbModel: DBVehicleStatusSocProfileModel = {
			guard let dbModel = dbModel else {
				return DBVehicleStatusSocProfileModel()
			}
			return dbModel
		}()
		newDbModel.displayValue = statusAttribute.unit?.value ?? ""
		newDbModel.status       = statusAttribute.status
		newDbModel.timestamp    = statusAttribute.timestamp ?? 0
		
		newDbModel.socs.removeAll()
		newDbModel.socs.append(objectsIn: statusAttribute.value?.map { $0.soc } ?? [])
		newDbModel.times.removeAll()
		newDbModel.times.append(objectsIn: statusAttribute.value?.map { $0.time } ?? [])
		
		return newDbModel
	}
	
	private static func map<T: RawRepresentable>(statusAttribute: StatusAttributeType<[VehicleZEVTariffModel], T>, dbModel: DBVehicleStatusTariffModel?) -> DBVehicleStatusTariffModel where T.RawValue == Int {
		
		let newDbModel: DBVehicleStatusTariffModel = {
			guard let dbModel = dbModel else {
				return DBVehicleStatusTariffModel()
			}
			return dbModel
		}()
		newDbModel.displayValue = statusAttribute.unit?.value ?? ""
		newDbModel.status       = statusAttribute.status
		newDbModel.timestamp    = statusAttribute.timestamp ?? 0
		
		newDbModel.rates.removeAll()
		newDbModel.rates.append(objectsIn: statusAttribute.value?.map { $0.rate } ?? [])
		newDbModel.times.removeAll()
		newDbModel.times.append(objectsIn: statusAttribute.value?.map { $0.time } ?? [])

		return newDbModel
	}
}

// swiftlint:enable function_body_length
// swiftlint:enable line_length
// swiftlint:enable type_body_length
// swiftlint:enable file_length

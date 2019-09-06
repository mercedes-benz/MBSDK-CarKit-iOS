//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

class NetworkModelMapper {
	
	// MARK: - BusinessModel
	
	static func map(apiDealerSearchAddressModel: APIDealerSearchAddressModel?) -> DealerSearchAddressModel {
		return DealerSearchAddressModel(street: apiDealerSearchAddressModel?.street,
										zipCode: apiDealerSearchAddressModel?.zipCode,
										city: apiDealerSearchAddressModel?.city)
	}
	
	static func map(apiDealerSearchOpeningModel: APIDealerSearchOpeningModel?) -> DealerOpeningStatus {
		
		guard apiDealerSearchOpeningModel?.status == .open else {
			return .closed
		}
		return .open(until: apiDealerSearchOpeningModel?.periods.last?.until)
	}
	
	static func map(apiDealerSearchOpeningDaysModel: APIDealerSearchOpeningDaysModel?) -> DealerOpeningStatus {
		
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "en_EN")
        dateFormater.dateFormat = DateFormat.weekDayName
		let weekDayName = dateFormater.string(from: Date())
        
		switch weekDayName {
		case "Monday": 		return self.map(apiDealerSearchOpeningModel: apiDealerSearchOpeningDaysModel?.monday)
		case "Tuesday":		return self.map(apiDealerSearchOpeningModel: apiDealerSearchOpeningDaysModel?.tuesday)
		case "Wednesday":	return self.map(apiDealerSearchOpeningModel: apiDealerSearchOpeningDaysModel?.wednesday)
		case "Thursday":	return self.map(apiDealerSearchOpeningModel: apiDealerSearchOpeningDaysModel?.thursday)
		case "Friday":		return self.map(apiDealerSearchOpeningModel: apiDealerSearchOpeningDaysModel?.friday)
		case "Saturday":	return self.map(apiDealerSearchOpeningModel: apiDealerSearchOpeningDaysModel?.saturday)
		case "Sunday":		return self.map(apiDealerSearchOpeningModel: apiDealerSearchOpeningDaysModel?.sunday)
		default:			return .closed
		}
	}
	
	static func map(apiDealerSearchDealerModels: [APIDealerSearchDealerModel]) -> [DealerSearchDealerModel] {
		return apiDealerSearchDealerModels.map { self.map(apiDealerSearchDealerModel: $0) }
	}
	
    static func map(apiDealerSearchDealerModel: APIDealerSearchDealerModel) -> DealerSearchDealerModel {

		let coordinate: CoordinateModel? = {
			guard let apiCoordinate = apiDealerSearchDealerModel.coordinate else {
				return nil
			}
			return CoordinateModel(latitude: apiCoordinate.latitude, longitude: apiCoordinate.longitude)
		}()
		
        return DealerSearchDealerModel(address: self.map(apiDealerSearchAddressModel: apiDealerSearchDealerModel.address),
									   coordinate: coordinate,
									   name: apiDealerSearchDealerModel.legalName,
									   openingHour: self.map(apiDealerSearchOpeningDaysModel: apiDealerSearchDealerModel.openingHours),
                                       phone: apiDealerSearchDealerModel.phone,
                                       id: apiDealerSearchDealerModel.id)
    }

	static func map(apiServiceGroupModels: [APIVehicleServiceGroupModel]) -> [VehicleServiceGroupModel] {
		return apiServiceGroupModels.map { self.map(apiServiceGroupModel: $0) }
	}
	
	static func map(apiServiceGroupModel: APIVehicleServiceGroupModel) -> VehicleServiceGroupModel {
		return VehicleServiceGroupModel(group: apiServiceGroupModel.group,
										services: self.map(apiServiceModels: apiServiceGroupModel.services))
	}
	
	static func map(apiServiceModels: [APIVehicleServiceModel]) -> [VehicleServiceModel] {
		return apiServiceModels.map({ self.map(apiServiceModel: $0) })
	}
	
	static func map(apiServiceModel: APIVehicleServiceModel) -> VehicleServiceModel {
		return VehicleServiceModel(activationStatus: apiServiceModel.activationStatus,
								   allowedActions: apiServiceModel.allowedActions,
								   description: apiServiceModel.shortDescription ?? "",
								   id: apiServiceModel.id,
								   name: apiServiceModel.name,
								   prerequisites: self.map(apiServicePrerequisiteModels: apiServiceModel.prerequisiteChecks ?? []),
								   shortName: apiServiceModel.shortName,
								   rights: apiServiceModel.rights)
	}
	
	static func map(apiServicePrerequisiteModels: [APIVehicleServicePrerequisiteModel]) -> [VehicleServicePrerequisiteModel] {
		return apiServicePrerequisiteModels.map { self.map(apiServicePrerequisiteModel: $0) }
	}
	
	static func map(apiServicePrerequisiteModel: APIVehicleServicePrerequisiteModel) -> VehicleServicePrerequisiteModel {
		return VehicleServicePrerequisiteModel(actions: apiServicePrerequisiteModel.actions,
											   missingFields: apiServicePrerequisiteModel.missingFields ?? [],
											   name: apiServicePrerequisiteModel.name)
	}
	
	static func map(apiVehicleConsumptionDataModel: APIVehicleConsumptionDataModel?) -> ConsumptionDataModel {
		
		let value = apiVehicleConsumptionDataModel?.value.map { self.map(apiVehicleConsumptionValueModel: $0) } ?? []
		return ConsumptionDataModel(changed: apiVehicleConsumptionDataModel?.changed ?? false,
									value: value)
	}
	
	static func map(apiVehicleConsumptionEntryModel: APIVehicleConsumptionEntryModel?) -> ConsumptionEntryModel? {
		
		guard let apiVehicleConsumptionEntryModel = apiVehicleConsumptionEntryModel else {
			return nil
		}
		return ConsumptionEntryModel(changed: apiVehicleConsumptionEntryModel.changed ?? false,
									 value: apiVehicleConsumptionEntryModel.value)
	}
	
	static func map(apiVehicleConsumptionModel: APIVehicleConsumptionModel) -> ConsumptionModel {
		return ConsumptionModel(averageConsumption: self.map(apiVehicleConsumptionEntryModel: apiVehicleConsumptionModel.averageConsumption),
								consumptionData: self.map(apiVehicleConsumptionDataModel: apiVehicleConsumptionModel.consumptionData),
								individualLifetimeConsumption: self.map(apiVehicleConsumptionEntryModel: apiVehicleConsumptionModel.individualLifetimeConsumption),
								individualResetConsumption: self.map(apiVehicleConsumptionEntryModel: apiVehicleConsumptionModel.individualResetConsumption),
								individualStartConsumption: self.map(apiVehicleConsumptionEntryModel: apiVehicleConsumptionModel.individualStartConsumption),
								wlptCombinded: self.map(apiVehicleConsumptionEntryModel: apiVehicleConsumptionModel.wlptCombinded))
	}
	
	static func map(apiVehicleConsumptionValueModel: APIVehicleConsumptionValueModel) -> ConsumptionValueModel {
		return ConsumptionValueModel(consumption: apiVehicleConsumptionValueModel.consumption ?? 0,
									 group: apiVehicleConsumptionValueModel.group ?? 0,
									 percentage: apiVehicleConsumptionValueModel.percentage ?? 0)
	}
	
	static func map(apiVehicleDataModels: [APIVehicleDataModel]) -> [VehicleModel] {
		return apiVehicleDataModels.map { self.map(apiVehicleDataModel: $0) }
	}
	
	static func map(apiVehicleDataModel: APIVehicleDataModel) -> VehicleModel {
		
		let model: String = apiVehicleDataModel.technicalInformation?.salesDesignation ?? ""
		return VehicleModel(baumuster: apiVehicleDataModel.salesRelatedInformation?.baumuster?.baumuster ?? "",
							carline: apiVehicleDataModel.carline,
							dataCollectorVersion: apiVehicleDataModel.dataCollectorVersion,
							dealers: self.map(apiVehicleDealerItemsModel: apiVehicleDataModel.dealers),
							doorsCount: apiVehicleDataModel.doorsCount,
							fin: apiVehicleDataModel.fin ?? "",
							fuelType: apiVehicleDataModel.fuelType,
							handDrive: apiVehicleDataModel.handDrive,
							hasAuxHeat: apiVehicleDataModel.hasAuxHeat ?? false,
							hasFacelift: apiVehicleDataModel.mopf ?? false,
							licensePlate: apiVehicleDataModel.licensePlate ?? "",
							model: model.isEmpty == false ? model : apiVehicleDataModel.salesRelatedInformation?.baumuster?.baumusterDescription ?? "",
							pending: nil,
							roofType: apiVehicleDataModel.roofType,
							starArchitecture: apiVehicleDataModel.starArchitecture,
							tcuHardwareVersion: apiVehicleDataModel.tcuHardwareVersion,
							tcuSoftwareVersion: apiVehicleDataModel.tcuSoftwareVersion,
							tirePressureMonitoringType: apiVehicleDataModel.tirePressureMonitoringType,
							trustLevel: apiVehicleDataModel.trustLevel ?? 0,
							vin: apiVehicleDataModel.vin ?? "",
							windowsLiftCount: apiVehicleDataModel.windowsLiftCount,
							vehicleConnectivity: apiVehicleDataModel.vehicleConnectivity,
							vehicleSegment: apiVehicleDataModel.vehicleSegment ?? .default)
	}
	
	private static func map(apiVehicleDealerItemsModel: APIVehicleDealerItemsModel?) -> [VehicleDealerItemModel] {
		return apiVehicleDealerItemsModel?.items.compactMap { VehicleDealerItemModel(dealerId: $0.dealerId, role: $0.role) } ?? []
	}
	
	static func map(apiVehicleImagesModel: [APIVehicleImageModel]) -> [ImageModel] {
		return apiVehicleImagesModel.map { self.map(apiVehicleImageModel: $0) }
	}
	
	static func map(apiVehicleImageModel: APIVehicleImageModel) -> ImageModel {
		return ImageModel(errorDescription: apiVehicleImageModel.error?.message,
						  imageKey: apiVehicleImageModel.imageKey,
						  url: apiVehicleImageModel.url)
	}
	
	static func map(apiVehicleMasterDataModel: APIVehicleMasterDataModel) -> [VehicleModel] {
		
		let masterData = NetworkModelMapper.map(apiVehicleDataModels: apiVehicleMasterDataModel.vehicleMasterDataResponse)
		let pending    = NetworkModelMapper.map(apiVehiclePendingModels: apiVehicleMasterDataModel.pending)
		
		return masterData + pending
	}
	
	static func map(apiVehicleRifModel: APIVehicleRifModel) -> VehicleSupportableModel {
        return VehicleSupportableModel(canReceiveVACs: apiVehicleRifModel.canCarReceiveVACs,
                                       vehicleConnectivity: apiVehicleRifModel.vehicleConnectivity)
	}
	
	static func map(apiVehicleVinImagesModel: [APIVehicleVinImageModel]) -> [VehicleImageModel] {
		return apiVehicleVinImagesModel.map { self.map(apiVehicleVinImageModel: $0) }
	}
	
	static func map(apiVehicleVinImageModel: APIVehicleVinImageModel) -> VehicleImageModel {
		return VehicleImageModel(images: self.map(apiVehicleImagesModel: apiVehicleVinImageModel.images),
								 vin: apiVehicleVinImageModel.vinOrFin)
	}
	
	static func map(apiVehiclePendingModels: [APIVehiclePendingModel]) -> [VehicleModel] {
		return apiVehiclePendingModels.map { self.map(apiVehiclePendingModel: $0) }
	}
	
	static func map(apiVehiclePendingModel: APIVehiclePendingModel) -> VehicleModel {
		return VehicleModel(baumuster: "",
							carline: nil,
							dataCollectorVersion: nil,
							dealers: [],
							doorsCount: nil,
							fin: apiVehiclePendingModel.vin,
							fuelType: nil,
							handDrive: nil,
							hasAuxHeat: false,
							hasFacelift: false,
							licensePlate: "",
							model: "",
							pending: apiVehiclePendingModel.state,
							roofType: nil,
							starArchitecture: nil,
							tcuHardwareVersion: nil,
							tcuSoftwareVersion: nil,
							tirePressureMonitoringType: nil,
							trustLevel: 0,
							vin: apiVehiclePendingModel.vin,
                            windowsLiftCount: nil,
							vehicleConnectivity: nil,
							vehicleSegment: .default)
	}
	
	
	// MARK: - NetworkModel
	
	static func map(dealerItemModel: VehicleDealerItemModel) -> APIVehicleDealerItemModel {
		return APIVehicleDealerItemModel(dealerId: dealerItemModel.dealerId,
										 role: dealerItemModel.role,
										 updatedAt: nil)
	}
	
	static func map(dealerItemModels: [VehicleDealerItemModel]) -> [APIVehicleDealerItemModel] {
		return dealerItemModels.map { self.map(dealerItemModel: $0) }
	}
	
    static func map(dealerSearchRequestModel: DealerSearchRequestModel) -> APIDealerSearchRequestModel {

        let searchArea = { () -> APIDealerSearchSearchAreaRequestModel? in

            if let location = dealerSearchRequestModel.location {

                let centerModel = self.map(dealerSearchCoordinateModel: location)
                let radiusModel = APIDealerSearchRadiusModel(value: String(APIDealerSearchRadiusModel.defaultValue), unit: .km)

                return APIDealerSearchSearchAreaRequestModel(center: centerModel, radius: radiusModel)
            }

            return nil
        }()

        return APIDealerSearchRequestModel(
            zipCodeOrCityName: dealerSearchRequestModel.zipCode,
            countryIsoCode: dealerSearchRequestModel.countryIsoCode,
            searchArea: searchArea
        )
    }

    static func map(dealerSearchCoordinateModel: CoordinateModel) -> APIDealerSearchCoordinateRequestModel {
        return APIDealerSearchCoordinateRequestModel(
            latitude: String(dealerSearchCoordinateModel.latitude),
            longitude: String(dealerSearchCoordinateModel.longitude)
        )
    }
	
	static func map(serviceModels: [VehicleServiceModel]) -> [APIVehicleServiceActivationModel] {
		return serviceModels.map { self.map(serviceModel: $0) }
	}
	
	static func map(serviceModel: VehicleServiceModel) -> APIVehicleServiceActivationModel {
		return APIVehicleServiceActivationModel(desiredServiceStatus: serviceModel.activationStatus.toogled,
												serviceId: serviceModel.id)
	}
}

//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

class NetworkModelMapper {
	
	// MARK: - BusinessModel
	
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
							indicatorImageUrl: URL(string: apiVehicleDataModel.indicatorImageUrl ?? ""),
							isOwner: apiVehicleDataModel.isOwner,
							licensePlate: apiVehicleDataModel.licensePlate ?? "",
							model: model.isEmpty == false ? model : apiVehicleDataModel.salesRelatedInformation?.baumuster?.baumusterDescription ?? "",
							pending: nil,
							roofType: apiVehicleDataModel.roofType,
							starArchitecture: StarArchitecture(rawValue: apiVehicleDataModel.starArchitecture ?? "") ?? .unknown,
							tcuHardwareVersion: TcuHardwareVersion(rawValue: apiVehicleDataModel.tcuHardwareVersion ?? "") ?? .unknown,
							tcuSoftwareVersion: TcuSoftwareVersion(rawValue: apiVehicleDataModel.tcuSoftwareVersion ?? "") ?? .unknown,
							tirePressureMonitoringType: apiVehicleDataModel.tirePressureMonitoringType,
							trustLevel: apiVehicleDataModel.trustLevel ?? 0,
							vin: apiVehicleDataModel.vin ?? "",
							windowsLiftCount: apiVehicleDataModel.windowsLiftCount,
							vehicleConnectivity: apiVehicleDataModel.vehicleConnectivity,
							vehicleSegment: apiVehicleDataModel.vehicleSegment ?? .default)
	}
	
	static func map(apiVehicleImagesModel: [APIVehicleImageModel]) -> [ImageModel] {
		return apiVehicleImagesModel.map { self.map(apiVehicleImageModel: $0) }
	}
	
	static func map(apiVehicleImageModel: APIVehicleImageModel) -> ImageModel {
		return ImageModel(errorDescription: apiVehicleImageModel.error?.message,
						  imageKey: apiVehicleImageModel.imageKey,
						  url: apiVehicleImageModel.url)
	}
    
    static func map(apiVehicleTopViewImageModel model: APIVehicleTopViewImageModel) -> TopImageModel {
        return TopImageModel(
            vin: model.vin,
            components: model.components.map { NetworkModelMapper.map(apiVehicleTopViewImageComponentModel: $0) })
    }
    
    static func map(apiVehicleTopViewImageComponentModel model: APIVehicleTopViewImageComponentModel) -> TopImageComponentModel {
        return TopImageComponentModel(name: model.name, imageData: model.imageData)
    }
	
	static func map(apiVehicleMasterDataModel: APIVehicleMasterDataModel) -> [VehicleModel] {
		
		let masterData = NetworkModelMapper.map(apiVehicleDataModels: apiVehicleMasterDataModel.vehicleMasterDataResponse)
		let pending    = NetworkModelMapper.map(apiVehiclePendingModels: apiVehicleMasterDataModel.pending)
		
		return masterData + pending
	}
	
	static func map(apiVehicleRifModel: APIVehicleRifModel) -> VehicleSupportableModel {
        return VehicleSupportableModel(canReceiveVACs: apiVehicleRifModel.canCarReceiveVACs,
                                       vehicleConnectivity: apiVehicleRifModel.vehicleConnectivity ?? .none)
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
							indicatorImageUrl: nil,
							isOwner: nil,
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
	
	static func map(serviceModels: [VehicleServiceModel]) -> [APIVehicleServiceActivationModel] {
		return serviceModels.map { self.map(serviceModel: $0) }
	}
	
	static func map(serviceModel: VehicleServiceModel) -> APIVehicleServiceActivationModel {
		return APIVehicleServiceActivationModel(desiredServiceStatus: serviceModel.activationStatus.toogled,
												serviceId: serviceModel.id)
	}
}

//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBNetworkKit

/// Service to call all vehicle service related requests
public class ServicesService {
	
	// MARK: Typealias
	
	/// Completion for grouped based services
	///
	/// Returns array of VehicleServiceGroupModel
	public typealias ServicesGroupResult = ([VehicleServiceGroupModel]) -> Void
	
	internal typealias ServiceAPIResult = NetworkResult<[APIVehicleServiceGroupModel]>
	internal typealias ServiceResult = (ValueResult<[VehicleServiceGroupModel], String>) -> Void
	internal typealias ServiceUpdateResult = (NonValueResult<String>) -> Void

	
	// MARK: - Public
	
	/// Fetch the vehicle data and update the cache immediately
	///
	/// - Parameters:
    ///   - finOrVin: fin or vin of the car
	///   - groupedOption: enum based sort option for the service groups
	///   - services: get status for id based services
	///   - completion: Closure with ServicesGroupResult
	///   - onError: Error closure with error message string
	public func fetchVehicleServices(
		finOrVin: String,
		groupedOption: ServiceGroupedOption,
		services: [Int]?,
		completion: @escaping ServicesGroupResult,
		onError: @escaping MBCarKit.ErrorDescription) {

        MBCarKit.tokenProvider.requestToken { token in
			
            let endpoint = BffEndpointRouter.serviceGet(accessToken: token.accessToken,
                                                        vin: finOrVin,
                                                        locale: MBCarKit.localeIdentifier,
                                                        grouped: groupedOption == .none ? nil : groupedOption.rawValue,
                                                        services: services)
			self.fetchServices(router: endpoint, finOrVin: finOrVin) { (result) in

                switch result {
                case .failure(let responseError):
                    LOG.E(responseError)
                    onError(self.handle(responseError: responseError))

                case .success(let vehicleServiceGroupModels):
                    completion(vehicleServiceGroupModels)
                }
            }
        }
	}
	
	/// Change the service activation status for given services
	///
	/// - Parameters:
	///   - finOrVin: fin or vin of the car
	///   - models: Array of services to be changed
	///   - completion: Void closure
	///   - onError: Error closure with error message string
	public func requestServiceActivationChanges(finOrVin: String, models: [VehicleServiceModel], completion: @escaping () -> Void, onError: @escaping MBCarKit.ErrorDescription) {

        MBCarKit.tokenProvider.requestToken { token in

            let apiModels = NetworkModelMapper.map(serviceModels: models)
			let json      = try? apiModels.toJson()
            let endpoint  = BffEndpointRouter.serviceUpdate(accessToken: token.accessToken,
                                                           	vin: finOrVin,
                                                           	locale: MBCarKit.localeIdentifier,
                                                           	requestModel: json as? [[String: Any]])

            self.updateServices(router: endpoint) { (result) in

                switch result {
                case .failure(let responseError):
                    onError(self.handle(responseError: responseError))

                case .success:
					let desiredStatus = apiModels.map { $0.desiredServiceStatus }
					let zipServices = zip(models, desiredStatus)
					
					DatabaseVehicleServicesService.setPendingType(finOrVin: finOrVin, services: zipServices, completion: {
						completion()
					})
                }
            }
        }
	}
	
	
	// MARK: - Helper
	
    private func fetchServices(router: BffEndpointRouter, finOrVin: String, completion: @escaping ServiceResult) {

		NetworkLayer.requestDecodable(router: router) { (result: ServiceAPIResult) in
			
			switch result {
			case .failure(let error):
				LOG.E(error.localizedDescription)
				completion(ValueResult.failure(self.handle(error: error)))
				
			case .success(let apiServiceGroupModels):
				LOG.D(apiServiceGroupModels)
				
				let serviceGroups = NetworkModelMapper.map(apiServiceGroupModels: apiServiceGroupModels)
				
				DatabaseVehicleServicesService.update(finOrVin: finOrVin, serviceGroups: serviceGroups, completion: {
					completion(ValueResult.success(serviceGroups))
				})
			}
		}
    }
	
	private func handle(error: Error) -> ResponseError<String> {
		
		let handleError   = NetworkLayer.handle(error: error, type: APIErrorDescriptionModel.self)
		let responseError = NetworkLayer.responseError(networkError: handleError.responseError?.networkError, model: handleError.errorModel?.description)
		return responseError
	}
	
	private func handle(responseError: ResponseError<String>) -> String {
		return responseError.requestError ?? responseError.localizedDescription ?? ""
	}
	
    private func updateServices(router: BffEndpointRouter, completion: @escaping ServiceUpdateResult) {
		
		NetworkLayer.requestData(router: router) { (result) in
			
			switch result {
			case .failure(let error):
				LOG.E(error.localizedDescription)
				completion(NonValueResult.failure(self.handle(error: error)))
				
			case .success:
				completion(NonValueResult.success)
			}
		}
    }
}

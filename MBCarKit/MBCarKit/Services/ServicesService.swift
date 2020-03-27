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
    public typealias ServicesGroupCompletion = (Result<[VehicleServiceGroupModel], MBError>) -> Void
    public typealias ServiceUpdateCompletion = (EmptyResult) -> Void
	
	internal typealias ServiceAPIResult = NetworkResult<[APIVehicleServiceGroupModel]>

	
	// MARK: - Public
	
    /// Fetch the vehicle data and update the cache immediately
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the car
    ///   - groupedOption: enum based sort option for the service groups
    ///   - services: get status for id based services
    ///   - completion: Closure with ServicesGroupCompletion
    public func fetchVehicleServices(
        finOrVin: String,
        groupedOption: ServiceGroupedOption,
        services: [Int]?,
        completion: @escaping ServicesGroupCompletion) {

        CarKit.tokenProvider.requestToken { token in
            
            let router = BffServicesRouter.get(accessToken: token.accessToken,
                                               vin: finOrVin,
                                               locale: CarKit.localeIdentifier,
                                               grouped: groupedOption == .none ? nil : groupedOption.rawValue,
                                               services: services)
            
            NetworkLayer.requestDecodable(router: router) { (result: ServiceAPIResult) in
                
                switch result {
                case .failure(let error):
                    LOG.E(error.localizedDescription)
                    
                    completion(.failure(ErrorHandler.handle(error: error)))
                    
                case .success(let apiServiceGroupModels):
                    LOG.D(apiServiceGroupModels)
                    
                    let serviceGroups = NetworkModelMapper.map(apiServiceGroupModels: apiServiceGroupModels)
                    
                    DatabaseVehicleServicesService.update(finOrVin: finOrVin, serviceGroups: serviceGroups, completion: {
                        completion(.success(serviceGroups))
                    })
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
    public func requestServiceActivationChanges(finOrVin: String, models: [VehicleServiceModel], completion: @escaping ServiceUpdateCompletion) {

        CarKit.tokenProvider.requestToken { token in

            let apiModels = NetworkModelMapper.map(serviceModels: models)
            let json      = try? apiModels.toJson()
            let router    = BffServicesRouter.update(accessToken: token.accessToken,
                                                     vin: finOrVin,
                                                     locale: CarKit.localeIdentifier,
                                                     requestModel: apiModels.isEmpty ? nil : json as? [[String: Any]])
            
            NetworkLayer.requestData(router: router) { (result) in
                
                switch result {
                case .failure(let error):
                    LOG.E(error.localizedDescription)
                    
                    completion(.failure(ErrorHandler.handle(error: error)))
                    
                case .success:
                    let desiredStatus = apiModels.map { $0.desiredServiceStatus }
                    let zipServices = zip(models, desiredStatus)
                    
                    DatabaseVehicleServicesService.setPendingType(finOrVin: finOrVin, services: zipServices, completion: {
                        completion(.success)
                    })
                }
            }
        }
    }
}

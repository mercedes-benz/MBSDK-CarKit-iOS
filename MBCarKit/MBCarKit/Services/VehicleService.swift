//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBNetworkKit

/// Service to call all vehicle data related requests
public class VehicleService {
	
	// MARK: Typealias
	
	/// Completion for vehicle consumption
	public typealias ConsumptionResult = (ValueResult<ConsumptionModel, String>) -> Void
	
	/// Completion for vehicle data
	///
	/// Returns array of VehicleModel
	public typealias VehiclesResult = ([VehicleModel]) -> Void
	
	/// Empty completion for vehicle data
	public typealias VehicleUpdateSucceeded = () -> Void
	
	typealias ConsumptionAPIResult = NetworkResult<APIVehicleConsumptionModel>

	typealias VehiclesAPIResult = NetworkResult<[APIVehicleDataModel]>
	typealias VehicleSelectionUpdate = (String) -> Void

	
	// MARK: - Public
	
	/// Fetch the consumption history and information about the vehicle and the model (Baumuster)
	///
	/// - Parameters:
	///   - finOrVin: fin or vin of the vehicle
	///   - completion: Closure with consumption data of the vehicle
	public func fetchConsumption(finOrVin: String, completion: @escaping ConsumptionResult) {
		
		MBCarKit.tokenProvider.requestToken { token in
			
			let router = BffEndpointRouter.consumption(accessToken: token.accessToken,
													   vin: finOrVin)
			
			NetworkLayer.requestDecodable(router: router) { (result: ConsumptionAPIResult) in
				
				switch result {
				case .failure(let error):
					LOG.E(error.localizedDescription)
					
					completion(ValueResult.failure(self.handle(error: error)))
					
				case .success(let apiVehicleConsumption):
					LOG.D(apiVehicleConsumption)
					
					let model = NetworkModelMapper.map(apiVehicleConsumptionModel: apiVehicleConsumption)
					completion(ValueResult.success(model))
				}
			}
		}
	}
	
	/// Fetch the vehicle data and update the cache immediately
	///
	/// - Parameters:
	///   - completion: Optional closure with vehicle data
	public func fetchVehicles(completion: VehiclesResult? = nil) {
		self.fetchVehicles(returnError: true,
						   completion: completion,
						   needsVehicleSelectionUpdate: nil)
	}
	
	/// Fetch the vehicle data at and select the first vehicle in data set
	///
	/// - Parameters:
	///   - completion: Closure with optional vehicle identifier
	public func instantSelectVehicle(completion: @escaping (String?) -> Void) {
		
		self.fetchVehicles { [weak self] (vehicles) in
			
            guard let finOrVin = self?.handleInstantVehicleSelection(vehicles: vehicles) else {
				completion(nil)
				return
			}
			
			DatabaseService.update(finOrVin: finOrVin) {
				
				completion(finOrVin)
				MBCarKit.sharedVehicleSelection = nil
			}
		}
	}
	
	/// Update the license plate of a given vehicle
	///
	/// - Parameters:
	///   - finOrVin: The fin or Vin of the car
	///   - onSuccess: Success closure
	///   - onError: Error closure with error message string
	public func updateLicense(finOrVin: String, licensePlate: String, onSuccess: @escaping VehicleUpdateSucceeded, onError: @escaping MBCarKit.ErrorDescription) {

        MBCarKit.tokenProvider.requestToken { token in

            let router = BffEndpointRouter.vehicleLicense(accessToken: token.accessToken,
														  vin: finOrVin,
														  locale: MBCarKit.localeIdentifier,
														  license: licensePlate)

			NetworkLayer.requestData(router: router) { [weak self] (result) in
				
				switch result {
				case .failure(let error):
					let errorDescription: String? = self?.handle(error: error)
					LOG.E(errorDescription ?? error.localizedDescription)
					onError(errorDescription ?? "")
					
				case .success(let value):
					LOG.D(value)
					
					DatabaseVehicleService.update(licensePlate: licensePlate, for: finOrVin, completion: nil)
					onSuccess()
				}
			}
        }
	}
	
	/// Update the preferred dealers of a given vehicle
	///
	/// - Parameters:
	///   - finOrVin: The fin or Vin of the car
	///   - onSuccess: Success closure
	///   - onError: Error closure with error message string
	public func updatePreferredDealer(finOrVin: String, preferredDealers: [VehicleDealerItemModel], onSuccess: @escaping VehicleUpdateSucceeded, onError: @escaping MBCarKit.ErrorDescription) {
		
		MBCarKit.tokenProvider.requestToken { token in
			
			let apiModels = NetworkModelMapper.map(dealerItemModels: preferredDealers)
			let json      = try? apiModels.toJson()
			let router    = BffEndpointRouter.dealersPreferred(accessToken: token.accessToken,
															   vin: finOrVin,
															   requestModel: json as? [[String: Any]])

			NetworkLayer.requestData(router: router) { (result) in
				
				switch result {
				case .failure(let error):
					let handleError      = NetworkLayer.handle(error: error, type: APIError.self)
					let responseError    = NetworkLayer.responseError(networkError: handleError.responseError?.networkError, model: handleError.errorModel)
					let errorDescription = responseError.requestError?.errors?.first?.description ?? responseError.localizedDescription ?? ""
					onError(errorDescription)
					
				case .success:
					onSuccess()
				}
			}
		}
	}
	
	
	// MARK: - Internal
	
	func fetchVehicles(completion: @escaping VehicleUpdateSucceeded, needsVehicleSelectionUpdate: @escaping VehicleSelectionUpdate) {

		self.fetchVehicles(returnError: false, completion: { (_) in
			completion()
		}, needsVehicleSelectionUpdate: needsVehicleSelectionUpdate)
	}
	
	
	// MARK: - Helper
	
	private func fetchVehicles(returnError: Bool, completion: VehiclesResult?, needsVehicleSelectionUpdate: VehicleSelectionUpdate?) {
		
		MBCarKit.tokenProvider.requestToken { token in
			
			let router = BffEndpointRouter.vehicles(accessToken: token.accessToken,
													countryCode: MBCarKit.countryCode,
													locale: MBCarKit.localeIdentifier)
			
			NetworkLayer.requestDecodable(router: router) { [weak self] (result: VehiclesAPIResult) in
				
				switch result {
				case .failure(let error):
					LOG.E(error.localizedDescription)
					
					if returnError {
						completion?(DatabaseVehicleService.fetch())
					}
					
				case .success(let apiVehicleDataModels):
					LOG.D(apiVehicleDataModels)
					self?.handle(apiVehicleDataModels: apiVehicleDataModels, completion: completion, needsVehicleSelectionUpdate: { (selectedVin) in
						needsVehicleSelectionUpdate?(selectedVin)
					})
				}
			}
		}
	}

	private func handle(apiVehicleDataModels: [APIVehicleDataModel], completion: VehiclesResult?, needsVehicleSelectionUpdate: @escaping VehicleSelectionUpdate) {
		
		let vehicles = NetworkModelMapper.map(apiVehicleDataModels: apiVehicleDataModels)
		DatabaseVehicleService.save(vehicleModels: vehicles, completion: {
			
			completion?(vehicles)
			
			if vehicles.isEmpty {
				DatabaseVehicleSelectionService.delete(completion: nil)
			}
		}, needsVehicleSelectionUpdate: { (selectedVin) in
			
			guard let selectedVin = selectedVin else {
				return
			}
			
			LOG.D("change vin selection: \(selectedVin)")
			needsVehicleSelectionUpdate(selectedVin)
		})
	}
	
	private func handle(error: Error) -> ResponseError<String> {
		
		let handleError   = NetworkLayer.handle(error: error, type: APIErrorMessageModel.self)
		return NetworkLayer.responseError(networkError: handleError.responseError?.networkError, model: handleError.errorModel?.message)
	}
	
	private func handle(error: Error) -> String {
		
		let handleError   = NetworkLayer.handle(error: error, type: APIErrorMessageModel.self)
		let responseError = NetworkLayer.responseError(networkError: handleError.responseError?.networkError, model: handleError.errorModel?.message)
		return responseError.requestError ?? responseError.localizedDescription ?? ""
	}
	
	private func handleInstantVehicleSelection(vehicles: [VehicleModel]) -> String? {
		
		let firstIndex = vehicles.firstIndex(where: { (vehicle) -> Bool in
			return vehicle.trustLevel > 1 && vehicle.pending == nil
		})
		
		guard let index = firstIndex else {
			return nil
		}
		
		let selectedVin: String = MBCarKit.sharedVehicleSelection ?? MBCarKit.selectedFinOrVin
		let filterFinOrVin = vehicles.first(where: { $0.finOrVin == selectedVin })?.finOrVin
		return filterFinOrVin ?? vehicles.item(at: index)?.finOrVin
	}
}

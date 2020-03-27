//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBNetworkKit

/// Service to call all vehicle assignment related requests
public class AssignmentService {
	
	// MARK: Typealias
	
	/// Completion for rif support
	///
	/// Returns a VehicleSupportableModel
    public typealias RifResult = (Result<VehicleSupportableModel, MBError>) -> Void
	
	/// Completion for assignment
    public typealias AssignmentResult = (EmptyResult) -> Void

	/// Completion for vin based assignment
	///
	/// Returns a AssignmentModel
	public typealias AssignmentFinishResult = (Result<AssignmentModel, MBError>) -> Void
	
	/// Completion for vin based assignment with precondition fails
	///
	/// Returns a AssignmentPreconditionModel
	public typealias AssignmentPreconditionResult = (AssignmentPreconditionModel) -> Void

	internal typealias AssignmentAPIResult = NetworkResult<APIAssignmentModel>
	internal typealias AssignmentError = (Error) -> Void
	internal typealias AssignmentSuccess = () -> Void
	internal typealias RifAPIResult = NetworkResult<APIVehicleRifModel>
	
    // MARK: - Public
	
    /// Start a qr-based vehicle assignment
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the car
    ///   - link: Link inkluded from the qr code
    ///   - completion: Completion with AssignmentFinishResult
    ///   - onPreconditionFailed: Precondition fails for this assignment
    public func addVehicleQR(link: String, completion: @escaping AssignmentFinishResult, onPreconditionFailed: @escaping AssignmentPreconditionResult) {

        CarKit.tokenProvider.requestToken { token in

            let router = BffAssignmentRouter.addQR(accessToken: token.accessToken,
                                                   link: link)

            NetworkLayer.requestDecodable(router: router) { [weak self] (result: AssignmentAPIResult) in

                switch result {
                case .failure(let error):
                    LOG.E(error.localizedDescription)

					self?.handle(error: error,
								 completion: completion,
								 onPreconditionFailed: onPreconditionFailed)

                case .success(let apiAssignmentModel):
                    LOG.D(apiAssignmentModel)

                    let assignmentModel = NetworkModelMapper.map(apiAssignmentModel: apiAssignmentModel)
                    let vehicleModel = VehicleModel(baumuster: "",
                                                    carline: nil,
                                                    dataCollectorVersion: nil,
                                                    dealers: [],
                                                    doorsCount: nil,
                                                    fin: apiAssignmentModel.vin,
                                                    fuelType: nil,
                                                    handDrive: nil,
                                                    hasAuxHeat: false,
                                                    hasFacelift: false,
                                                    indicatorImageUrl: nil,
                                                    isOwner: assignmentModel.assignmentType != .user,
                                                    licensePlate: "",
                                                    model: "",
                                                    pending: .assigning,
                                                    roofType: nil,
                                                    starArchitecture: nil,
                                                    tcuHardwareVersion: nil,
                                                    tcuSoftwareVersion: nil,
                                                    tirePressureMonitoringType: nil,
                                                    trustLevel: 0,
                                                    vin: apiAssignmentModel.vin,
                                                    windowsLiftCount: nil,
                                                    vehicleConnectivity: nil,
                                                    vehicleSegment: .default)

                    DatabaseVehicleService.save(vehicleModel: vehicleModel, completion: {
                        completion(.success(assignmentModel))
                    })

                    let vehicleSupportable = VehicleSupportableModel(canReceiveVACs: true,
                                                                     vehicleConnectivity: .builtin)
                    DatabaseVehicleSupportableService.update(finOrVin: apiAssignmentModel.vin,
                                                             vehicleSupportableModel: vehicleSupportable,
                                                             completion: nil)
                }
            }
        }
    }

    /// Start a vin-based vehicle assignment
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the car
    ///   - completion: Closure with information wheather vehicle rifable
    public func addVehicleVIN(finOrVin: String, completion: @escaping RifResult) {

        CarKit.tokenProvider.requestToken { token in

            let router = BffAssignmentRouter.addVIN(accessToken: token.accessToken,
                                                    vin: finOrVin)
            self.canCarReceiveVACs(for: router, finOrVin: finOrVin, completion: completion)
        }
    }

    /// Check if the vehicle can receive vac's
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the car
    ///   - completion: Closure with information wheather vehicle rifable
    public func canCarReceiveVACs(finOrVin: String, completion: @escaping RifResult) {

        CarKit.tokenProvider.requestToken { token in

            let router = BffVehicleRouter.rifability(accessToken: token.accessToken,
                                                     vin: finOrVin)
            self.canCarReceiveVACs(for: router, finOrVin: finOrVin, completion: completion)
        }
    }

    /// Confirm the vehicle assignment
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the car
    ///   - vac: VAC of assigment process
    ///   - completion: Completion with AssignmentResult
    ///   - onPreconditionFailed: Precondition fails for this assignment
    public func confirmVehicle(finOrVin: String, vac: String, completion: @escaping AssignmentResult, onPreconditionFailed: @escaping AssignmentPreconditionResult) {

        CarKit.tokenProvider.requestToken { token in

            let router = BffAssignmentRouter.confirm(accessToken: token.accessToken,
                                                     vac: vac,
                                                     vin: finOrVin)

            self.assignment(router: router, onSuccess: {

                DatabaseVehicleService.update(pendingState: .assigning, for: finOrVin) {
                    completion(.success)
                }

                if finOrVin.isEmpty == false {
                    DatabaseVehicleSelectionService.update(finOrVin: finOrVin, completion: {})
                }
            }, onError: { [weak self] (error) in
				
				self?.handle(error: error, completion: { (result) in
					
					switch result {
					case .failure(let error):	completion(.failure(error))
					case .success:				completion(.success)
					}
				}, onPreconditionFailed: onPreconditionFailed)
            })
        }
    }

    /// Unassign a vehicle
    ///
    /// - Parameters:
    ///   - finOrVin: fin or vin of the car
    ///   - completion: Completion with AssignmentResult
    public func deleteVehicle(finOrVin: String, completion: @escaping AssignmentResult) {

        CarKit.tokenProvider.requestToken { token in

            let router = BffAssignmentRouter.delete(accessToken: token.accessToken,
                                                    vin: finOrVin)

            self.assignment(router: router, onSuccess: {

                let selectedVin = CarKit.selectedFinOrVin
                if selectedVin == finOrVin,
                    selectedVin?.isEmpty == false &&
                        finOrVin.isEmpty == false {
                    CacheService.deleteStatus(for: finOrVin, completion: nil)
                }

                DatabaseVehicleService.update(pendingState: .deleting, for: finOrVin) {

                    if let newAssignedVehicle = DatabaseVehicleService.firstAssignedVehicle() {
                        DatabaseVehicleSelectionService.update(finOrVin: newAssignedVehicle.finOrVin, completion: {})
                    } else {
                        DatabaseVehicleSelectionService.delete(completion: nil)
                    }
                }

                DatabaseVehicleSupportableService.delete(with: finOrVin)
                DatabaseVehicleServicesService.delete(finOrVin: finOrVin)

                completion(.success)
            }, onError: { (error) in
                completion(.failure(ErrorHandler.handle(error: error)))
            })
        }
    }
    
    
    // MARK: - Helper
    
    private func assignment(router: EndpointRouter, onSuccess: @escaping AssignmentSuccess, onError: @escaping AssignmentError) {
        
        NetworkLayer.requestData(router: router) { (result) in
            
            switch result {
            case .failure(let error):
                LOG.E(error.localizedDescription)
                
                onError(error)
                
            case .success:
                onSuccess()
            }
        }
    }
    
    private func canCarReceiveVACs(for router: EndpointRouter, finOrVin: String, completion: @escaping RifResult) {
        
        NetworkLayer.requestDecodable(router: router) { (result: RifAPIResult) in
            
            switch result {
            case .failure(let error):
                LOG.E(error.localizedDescription)
                
                completion(.failure(ErrorHandler.handle(error: error)))
                
            case .success(let apiRif):
                LOG.D(apiRif)
                
                let vehicleSupportable = NetworkModelMapper.map(apiVehicleRifModel: apiRif)
                DatabaseVehicleSupportableService.update(finOrVin: finOrVin, vehicleSupportableModel: vehicleSupportable, completion: nil)
                
                completion(.success(vehicleSupportable))
            }
        }
    }
    
	private func handle(error: Error, completion: @escaping AssignmentFinishResult, onPreconditionFailed: @escaping AssignmentPreconditionResult) {
		
		let error: MBError = ErrorHandler.handle(error: error)
		
		switch error.type {
		case .http(let httpError):

			if let apiAssignmentPreconditionModel: APIAssignmentPreconditionModel = NetworkLayer.parse(httpError: httpError) {

				let assignmentPreconditionModel = NetworkModelMapper.map(apiAssignmentPreconditionModel: apiAssignmentPreconditionModel)
				LOG.E(assignmentPreconditionModel)
				onPreconditionFailed(assignmentPreconditionModel)
			} else {
				completion(.failure(error))
			}
			
		case .network,
			 .unknown:
			completion(.failure(error))
		}
	}
}

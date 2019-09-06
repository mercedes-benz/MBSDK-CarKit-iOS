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
    public typealias RifResult = (ValueResult<VehicleSupportableModel, String>) -> Void
	
	/// Completion for assignment
	public typealias AssignmentResult = () -> Void

	/// Completion for vin based assignment
	///
	/// Returns a string based vin
	public typealias AssignmentVINResult = (String) -> Void
	
	internal typealias AssignmentAPIResult = NetworkResult<APIVehicleMasterDataModel>
	internal typealias AssignmentAPIVinResult = NetworkResult<APIAssignmentVinModel>
	internal typealias RifAPIResult = NetworkResult<APIVehicleRifModel>
	
	
	// MARK: - Public
	
	/// Start a qr-based vehicle assignment
	///
	/// - Parameters:
    ///   - finOrVin: fin or vin of the car
	///   - link: Link inkluded from the qr code
	///   - onSuccess: Success closure
	///   - onError: Error closure with error message string
	public func addVehicleQR(link: String, onSuccess: @escaping AssignmentVINResult, onError: @escaping MBCarKit.ErrorDescription) {

        MBCarKit.tokenProvider.requestToken { token in

            let router = BffEndpointRouter.assignmentQr(accessToken: token.accessToken,
                                                        link: link)

            NetworkLayer.requestDecodable(router: router) { (result: AssignmentAPIVinResult) in

                switch result {
                case .failure(let error):
                    LOG.E(error.localizedDescription)
                    onError(self.handle(error: error))

                case .success(let apiAssignmentVinModel):
                    LOG.D(apiAssignmentVinModel)

                    let vehicleModel = VehicleModel(baumuster: "",
													carline: nil,
													dataCollectorVersion: nil,
													dealers: [],
													doorsCount: nil,
                                                    fin: apiAssignmentVinModel.vin,
													fuelType: nil,
													handDrive: nil,
													hasAuxHeat: false,
													hasFacelift: false,
                                                    licensePlate: "",
                                                    model: "",
                                                    pending: .assigning,
													roofType: nil,
													starArchitecture: nil,
													tcuHardwareVersion: nil,
													tcuSoftwareVersion: nil,
													tirePressureMonitoringType: nil,
                                                    trustLevel: 0,
                                                    vin: apiAssignmentVinModel.vin,
                                                    windowsLiftCount: nil,
                                                    vehicleConnectivity: nil,
													vehicleSegment: .default)
					
                    DatabaseVehicleService.save(vehicleModel: vehicleModel, completion: {
                        onSuccess(apiAssignmentVinModel.vin)
                    })
					
                    let vehicleSupportable = VehicleSupportableModel(canReceiveVACs: true, vehicleConnectivity: .builtin)
					DatabaseVehicleSupportableService.update(finOrVin: apiAssignmentVinModel.vin, vehicleSupportableModel: vehicleSupportable, completion: nil)
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

        MBCarKit.tokenProvider.requestToken { token in
			
            let router = BffEndpointRouter.assignmentAdd(accessToken: token.accessToken,
                                                         vin: finOrVin)
            self.canCarReceiveVACs(for: router, finOrVin: finOrVin) { (result) in
                completion(result)
            }
        }
	}
	
	/// Check if the vehicle can receive vac's
	///
	/// - Parameters:
    ///   - finOrVin: fin or vin of the car
	///   - completion: Closure with information wheather vehicle rifable
	public func canCarReceiveVACs(finOrVin: String, completion: @escaping RifResult) {

        MBCarKit.tokenProvider.requestToken { token in
			
            let router = BffEndpointRouter.rif(accessToken: token.accessToken,
                                               vin: finOrVin)
            self.canCarReceiveVACs(for: router, finOrVin: finOrVin) { (result) in
                completion(result)
            }
        }
	}
	
	/// Confirm the vehicle assignment
	///
	/// - Parameters:
    ///   - finOrVin: fin or vin of the car
	///   - vac: VAC of assigment process
	///   - onSuccess: Success closure
	///   - onError: Error closure with error message string
    public func confirmVehicle(finOrVin: String, vac: String, onSuccess: @escaping AssignmentResult, onError: @escaping MBCarKit.ErrorDescription) {
		
        MBCarKit.tokenProvider.requestToken { token in
			
            let router = BffEndpointRouter.assignmentConfirm(accessToken: token.accessToken,
                                                             vac: vac,
                                                             vin: finOrVin)

            self.assignment(router: router, onSuccess: {

                DatabaseVehicleService.update(pendingState: .assigning, for: finOrVin) {
                    onSuccess()
                }

                if finOrVin.isEmpty == false {
                    DatabaseVehicleSelectionService.update(finOrVin: finOrVin, completion: {})
                }
            }, onError: { (error) in
                onError(error)
            })
        }
    }
	
	/// Unassign a vehicle
	///
	/// - Parameters:
	///   - finOrVin: fin or vin of the car
	///   - onSuccess: Success closure
	///   - onError: Error closure with error message string
	public func deleteVehicle(finOrVin: String, onSuccess: @escaping AssignmentResult, onError: @escaping MBCarKit.ErrorDescription) {
		
        MBCarKit.tokenProvider.requestToken { token in
			
            let router = BffEndpointRouter.assignmentDelete(accessToken: token.accessToken,
                                                            vin: finOrVin)
            self.assignment(router: router, onSuccess: {

				let selectedVin = DatabaseService.selectedFinOrVin
				if selectedVin == finOrVin,
					selectedVin.isEmpty == false &&
						finOrVin.isEmpty == false {
							CacheService.deleteStatus(for: finOrVin)
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
				
				onSuccess()
            }, onError: { (error) in
                onError(error)
            })
        }
	}
	
	
	// MARK: - Helper
	
	private func assignment(router: BffEndpointRouter, onSuccess: @escaping AssignmentResult, onError: @escaping MBCarKit.ErrorDescription) {
		
		NetworkLayer.requestData(router: router) { (result) in
			
			switch result {
			case .failure(let error):
				LOG.E(error.localizedDescription)
				onError(self.handle(error: error))
				
			case .success:
				onSuccess()
			}
		}
	}
	
	private func canCarReceiveVACs(for router: BffEndpointRouter, finOrVin: String, completion: @escaping RifResult) {
		
		NetworkLayer.requestDecodable(router: router) { (result: RifAPIResult) in
			
			switch result {
			case .failure(let error):
				LOG.E(error.localizedDescription)
				completion(ValueResult.failure(self.handle(error: error)))
				
			case .success(let apiRif):
				LOG.D(apiRif)
				
				let vehicleSupportable = NetworkModelMapper.map(apiVehicleRifModel: apiRif)
				DatabaseVehicleSupportableService.update(finOrVin: finOrVin, vehicleSupportableModel: vehicleSupportable, completion: nil)
				
				completion(ValueResult.success(vehicleSupportable))
			}
		}
	}
	
	private func handle(error: Error) -> ResponseError<String> {
		
		let handleError = NetworkLayer.handle(error: error, type: APIErrorDescriptionModel.self)
		return NetworkLayer.responseError(networkError: handleError.responseError?.networkError, model: handleError.errorModel?.description)
	}
	
	private func handle(error: Error) -> String {
		
		let handleError   = NetworkLayer.handle(error: error, type: APIErrorDescriptionModel.self)
		let responseError = NetworkLayer.responseError(networkError: handleError.responseError?.networkError, model: handleError.errorModel?.description)
		return responseError.requestError ?? responseError.localizedDescription ?? ""
	}
}

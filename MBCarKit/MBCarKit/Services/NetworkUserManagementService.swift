//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

internal final class NetworkUserManagementService {


	// MARK: - Types

	/// Completion for subuser qr-code invitation
	///
	/// Returns an image data object
	typealias VehicleQrCodeInvitationCompletion = (Result<Data, MBError>) -> Void
	private typealias VehicleQrCodeIntivationResult = NetworkResult<Data>

	typealias VehicleAssignedUserSucceeded = (Result<APIVehicleUserManagementModel, MBError>) -> Void
	private typealias VehicleUserManagementResult = NetworkResult<APIVehicleUserManagementModel>
    
    typealias RemoveUserAuthorizationCompletion = (EmptyResult) -> Void
    typealias SetProfileSyncCompletion = (EmptyResult) -> Void
    typealias UpgradeTemporaryUserCompletion = (EmptyResult) -> Void


	// MARK: - Internal Interface

	/// Fetch the assigned users with basic information (Owner, Subuser)
	///
	/// - Parameters:
	///   - finOrVin: fin or vin of the vehicle
	///   - completion: Closure with consumption data of the vehicle
	internal static func fetchVehicleAssignedUsers(finOrVin: String, completion: @escaping VehicleAssignedUserSucceeded) {

		CarKit.tokenProvider.requestToken { token in

			let router = BffUserManagementRouter.get(accessToken: token.accessToken, vin: finOrVin, locale: CarKit.localeIdentifier)

			NetworkLayer.requestDecodable(router: router) { (result: VehicleUserManagementResult) in

				switch result {
				case .failure(let error):
					LOG.E(error.localizedDescription)

					completion(.failure(ErrorHandler.handle(error: error)))

				case .success(let apiVehicleUserManagement):
					LOG.D(apiVehicleUserManagement)

					completion(.success(apiVehicleUserManagement))
				}
			}
		}
	}

	internal static func fetchInvitationQrCode(finOrVin: String, profileId: VehicleProfileID, completion: @escaping VehicleQrCodeInvitationCompletion) {

		CarKit.tokenProvider.requestToken { token in

			let router = BffUserManagementRouter.inviteQR(accessToken: token.accessToken, vin: finOrVin, profileId: profileId)

			NetworkLayer.requestData(router: router) { (result) in

				switch result {
				case .failure(let error):
					LOG.E(error.localizedDescription)

					completion(.failure(ErrorHandler.handle(error: error)))

				case .success(let data):
					LOG.D(data)

					completion(.success(data))
				}
			}
		}
	}
    
    internal static func removeUserAuthorization(finOrVin: String, authorizationID: String, completion: @escaping RemoveUserAuthorizationCompletion) {

        CarKit.tokenProvider.requestToken { token in

            let router = BffUserManagementRouter.delete(accessToken: token.accessToken,
														vin: finOrVin,
														authorizationID: authorizationID)
			self.request(router: router, completion: completion)
        }
    }
    
    internal static func setProfileSync(enabled: Bool, finOrVin: String, completion: @escaping SetProfileSyncCompletion) {

        CarKit.tokenProvider.requestToken { token in

            let router = BffUserManagementRouter.setProfileSync(accessToken: token.accessToken,
																vin: finOrVin,
																enabled: enabled)
			self.request(router: router, completion: completion)
        }
    }
	
    internal static func upgradeTemporaryUser(authorizationID: String, finOrVin: String, completion: @escaping UpgradeTemporaryUserCompletion) {

        CarKit.tokenProvider.requestToken { token in

            let router = BffUserManagementRouter.upgradeTemporaryUser(accessToken: token.accessToken,
                                                                      authorizationID: authorizationID,
                                                                      finOrVin: finOrVin)
            self.request(router: router, completion: completion)
        }
    }
    
	
	// MARK: - Helper
	
	private static func request(router: BffUserManagementRouter, completion: @escaping (EmptyResult) -> Void) {
		
		NetworkLayer.requestData(router: router) { (result) in
			
			switch result {
			case .failure(let error):
				LOG.E(error.localizedDescription)
				
				completion(.failure(ErrorHandler.handle(error: error)))
				
			case .success:
				LOG.D()
				
				completion(.success)
			}
		}
	}
}

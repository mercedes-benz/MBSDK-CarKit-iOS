//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift

extension DatabaseModelMapper {

	static func map(dbUserManagement: DBVehicleUserManagementModel?) -> VehicleUserManagementModel? {

		guard let userManagement = dbUserManagement,
			let owner = userManagement.owner else {
				return nil
		}

		return VehicleUserManagementModel(finOrVin: userManagement.finOrVin,
										  metaData: self.map(dbMetaData: userManagement.metaData),
										  owner: self.map(dbVehicleAssignedUser: owner),
										  users: self.map(dbVehicleAssignedUserList: userManagement.users),
										  unassignedProfiles: [])
	}

	fileprivate static func map(dbMetaData: DBUserManagementMetaDataModel?) -> UserManagementMetaDataModel {
		return UserManagementMetaDataModel(maxProfileNumber: dbMetaData?.maxProfileNumber ?? 0,
										   occupiedProfilesNumber: dbMetaData?.occupiedProfilesNumber ?? 0,
										   profileSyncStatus: VehicleProfileSyncStatus(rawValue: dbMetaData?.profileSyncStatus ?? "") ?? .unsupported)
	}

	fileprivate static func map(dbVehicleAssignedUserList: List<DBVehicleAssignedUserModel>?) -> [VehicleAssignedUserModel] {

		guard let users = dbVehicleAssignedUserList else {
			return []
		}

		return users.compactMap { (assignedUserItem) -> VehicleAssignedUserModel? in
			return self.map(dbVehicleAssignedUser: assignedUserItem)
		}
	}

	fileprivate static func map(dbVehicleAssignedUser: DBVehicleAssignedUserModel) -> VehicleAssignedUserModel {
        return VehicleAssignedUserModel(authorizationId: dbVehicleAssignedUser.authorizationId,
										displayName: dbVehicleAssignedUser.displayName,
										email: dbVehicleAssignedUser.email,
										mobileNumber: dbVehicleAssignedUser.mobileNumber,
										status: VehicleAssignedUserStatus(rawValue: dbVehicleAssignedUser.status) ?? .unknown,
										userImageURL: dbVehicleAssignedUser.userImageUrl,
                                        validUntil: DateFormattingHelper.date(dbVehicleAssignedUser.validUntil, format: DateFormat.iso8601))
	}

	static func map(userManagement: VehicleUserManagementModel, dbUserManagement: DBVehicleUserManagementModel) -> DBVehicleUserManagementModel {

		dbUserManagement.metaData = self.map(metaData: userManagement.metaData)
		dbUserManagement.owner = self.map(vehicleAssignedUser: userManagement.owner)

		dbUserManagement.users.removeAll()
		if let users = userManagement.users?.map({ self.map(vehicleAssignedUser: $0) }) {
			dbUserManagement.users.append(objectsIn: users)
		}

		return dbUserManagement
	}

	fileprivate	static func map(metaData: UserManagementMetaDataModel) -> DBUserManagementMetaDataModel {

		let dbMetaData = DBUserManagementMetaDataModel()
		dbMetaData.maxProfileNumber = metaData.maxProfileNumber
		dbMetaData.occupiedProfilesNumber = metaData.occupiedProfilesNumber
		dbMetaData.profileSyncStatus = metaData.profileSyncStatus.rawValue
		return dbMetaData
	}

	fileprivate	static func map(vehicleAssignedUser: VehicleAssignedUserModel) -> DBVehicleAssignedUserModel {

		let user = DBVehicleAssignedUserModel()
		user.authorizationId = vehicleAssignedUser.authorizationId
		user.displayName = vehicleAssignedUser.displayName
		user.email = vehicleAssignedUser.email
		user.status = vehicleAssignedUser.status.rawValue
        user.userImageUrl = vehicleAssignedUser.userImageURL?.absoluteString
        user.validUntil = DateFormattingHelper.string(vehicleAssignedUser.validUntil, format: DateFormat.iso8601)
		return user
	}
}

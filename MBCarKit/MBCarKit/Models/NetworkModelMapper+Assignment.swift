//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - Assignment

extension NetworkModelMapper {
	
	// MARK: - BusinessModel
	
	static func map(apiAssignmentModel: APIAssignmentModel) -> AssignmentModel {
		return AssignmentModel(assignmentType: AssignmentUserType(rawValue: apiAssignmentModel.assignmentType ?? "") ?? .unknown,
							   vin: apiAssignmentModel.vin)
	}
	
	static func map(apiAssignmentPreconditionModel: APIAssignmentPreconditionModel) -> AssignmentPreconditionModel {
		return AssignmentPreconditionModel(assignmentType: AssignmentUserType(rawValue: apiAssignmentPreconditionModel.assignmentType ?? "") ?? .unknown,
										   mercedesMePinRequired: apiAssignmentPreconditionModel.mercedesMePinRequired ?? false,
										   model: apiAssignmentPreconditionModel.salesDesignation ?? apiAssignmentPreconditionModel.baumusterDescription ?? "",
										   termsOfUseRequired: apiAssignmentPreconditionModel.termsOfUseRequired ?? false,
										   vin: apiAssignmentPreconditionModel.vin)
	}
}

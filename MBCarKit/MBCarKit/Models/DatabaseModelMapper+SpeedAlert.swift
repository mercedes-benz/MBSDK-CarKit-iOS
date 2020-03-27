//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift

extension DatabaseModelMapper {

    static func map(vehicleStatusSpeedAlertModel model: VehicleSpeedAlertModel) -> DBVehicleSpeedAlertModel {
        let dbModel = DBVehicleSpeedAlertModel()
        dbModel.endTime = Int64(model.endtime)
        dbModel.threshold = Int64(model.threshold)
        dbModel.thresholdDisplayValue = model.thresholdDisplayValue
        return dbModel
    }
}

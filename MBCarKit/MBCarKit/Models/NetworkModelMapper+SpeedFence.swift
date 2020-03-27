//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//


import Foundation

extension NetworkModelMapper {
    
    static func map(apiSpeedfencesModel: [APISpeedFenceModel]) -> [SpeedFenceModel] {
        return apiSpeedfencesModel.map { self.map(apiSpeedfenceModel: $0) }
    }
    
    static func map(apiSpeedfenceModel: APISpeedFenceModel) -> SpeedFenceModel {
        return SpeedFenceModel(armtype: apiSpeedfenceModel.armtype,
							   endtime: apiSpeedfenceModel.endtime,
							   geofenceid: apiSpeedfenceModel.geofenceid,
                               name: apiSpeedfenceModel.name,
                               speedfenceid: apiSpeedfenceModel.speedfenceid,
                               syncstatus: apiSpeedfenceModel.syncstatus,
                               threshold: apiSpeedfenceModel.threshold,
							   ts: apiSpeedfenceModel.ts,
                               violationdelay: apiSpeedfenceModel.violationdelay,
                               violationtypes: apiSpeedfenceModel.violationtypes)
    }
}

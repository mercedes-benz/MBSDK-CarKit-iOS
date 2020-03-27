//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import RealmSwift

@objcMembers public class DBSendToCarCapabilitiesModel: Object {

    // MARK: Properties
    dynamic var finOrVin: String = ""

    let capabilities = List<DBSendToCarCapabilityModel>()


    // MARK: - Realm
    
    override public static func primaryKey() -> String? {
        return "finOrVin"
    }
}

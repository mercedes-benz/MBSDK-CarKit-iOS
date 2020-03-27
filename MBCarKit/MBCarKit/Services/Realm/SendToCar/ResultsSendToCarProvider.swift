//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBRealmKit

    class ResultsSendToCarProvider: RealmDataSourceProvider<DBSendToCarCapabilitiesModel, SendToCarCapabilitiesModel> {

    override func map(model: DBSendToCarCapabilitiesModel) -> SendToCarCapabilitiesModel? {
        return DatabaseModelMapper.map(dbSendToCarCapabilitiesModel: model)
    }
}

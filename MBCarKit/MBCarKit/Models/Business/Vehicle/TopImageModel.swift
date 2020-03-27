//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct TopImageModel {
    let vin: String
    let components: [TopImageComponentModel]
}

struct TopImageComponentModel {
    let name: String
    let imageData: Data?
}

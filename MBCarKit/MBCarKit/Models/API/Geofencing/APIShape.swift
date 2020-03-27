//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public struct APIShape: Decodable {
    let center: APICoordinate?
    let radius: Double?
    let coordinates: [APICoordinate]?
}

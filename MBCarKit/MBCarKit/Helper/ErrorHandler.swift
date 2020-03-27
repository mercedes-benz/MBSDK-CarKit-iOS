//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import MBNetworkKit

struct ErrorHandler {
    
    /// Default error handling with APIError
    static func handle(error: Error) -> MBError {
        return NetworkLayer.errorDecodable(error: error, parsingType: APIError.self)
    }
}

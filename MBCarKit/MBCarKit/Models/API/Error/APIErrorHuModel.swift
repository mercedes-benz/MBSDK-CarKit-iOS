//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

struct APIErrorHuModel: Decodable {
	
	let description: String?
	let errorType: ErrorType?
	let fieldName: String?
}

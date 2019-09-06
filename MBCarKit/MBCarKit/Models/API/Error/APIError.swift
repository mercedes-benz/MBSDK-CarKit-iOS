//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public struct APIError: Decodable {
	
	/// Localized error message
	public let message: String?
	
	/// Form related errors
	public let errors: [APIErrorDescription]?
}


public struct APIErrorDescription: Codable {
	
	public let description: String
	public let fieldName: String?
}

//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBCommonKit

internal final class MockTokenProvider: TokenProviding {
	func requestToken(onComplete: @escaping (TokenConformable) -> Void) {

		onComplete(MockToken())
	}
}

internal class MockToken: TokenConformable {
	var accessToken: String {
		return "mock_token"
	}

	var accessExpirationDate: Date {
		return Date()
	}

	var expirationDate: Date? {
		return Date()
	}

	var refreshToken: String {
		return "mock_refresh_token"
	}
}

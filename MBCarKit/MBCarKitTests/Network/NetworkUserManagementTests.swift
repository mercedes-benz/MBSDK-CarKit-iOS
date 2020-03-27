//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import XCTest
import OHHTTPStubs
import MBCommonKit

@testable import MBCarKit

class  NetworkUserManagementTests: XCTestCase {

	private struct Constants {

		static let vin: String = "WDD1770871Z000099"
		static let locale: String = "en_GB"
		static let statusCode200: String = "usermanagement_success.json"
	}


	// MARK: - Setup

    override func setUp() {

		CarKit.tokenProvider = MockTokenProvider()
		CarKit.bffProvider = MockBffProvider()

        HTTPStubs.onStubActivation { (request: URLRequest, stub: HTTPStubsDescriptor, response: HTTPStubsResponse) in
			print("[OHHTTPStubs] Request to \(request.url!) has been stubbed with \(String(describing: stub.name))")
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	
	// MARK: - Tests

    func testSuccessResponse200() {

		self.installStatusCode200Stub()

		let expectation = XCTestExpectation(description: "Fetch user management data")

		NetworkUserManagementService.fetchVehicleAssignedUsers(finOrVin: Constants.vin) { (result) in

			switch (result) {

			case .success(let model):
				XCTAssertNotNil(model, "No data was mapped.")

				XCTAssertEqual(model.metaData.profileSyncStatus, VehicleProfileSyncStatus.headUnitActivationNeeded.rawValue)
				XCTAssertEqual(model.metaData.maxNumberOfProfiles, 7)
				XCTAssertEqual(model.metaData.numberOfOccupiedProfiles, 3)

				XCTAssertEqual(model.owner.authorizationId, "0C9B54E83B")
				XCTAssertEqual(model.owner.displayName, "Peter Quill")

				XCTAssertEqual(model.users.validSubusers?.count, 2)
				XCTAssertEqual(model.users.pendingSubusers?.count, 1)

				expectation.fulfill()
			case .failure:
				XCTFail()
			}
		}

		wait(for: [expectation], timeout: 3.0)
    }


	// MARK: - Helper

	private func installStatusCode200Stub() {

		let stubPath = OHPathForFile(Constants.statusCode200, type(of: self))

		let mock: HTTPStubsDescriptor = stub(condition: isPath(BffUserManagementRouter.get(accessToken: "", vin: Constants.vin, locale: Constants.locale).path)) { _ in

			return fixture(filePath: stubPath!, status: 200, headers: nil)
				.requestTime(0.0, responseTime:OHHTTPStubsDownloadSpeedWifi)
		}

		mock.name = Constants.statusCode200
	}
}

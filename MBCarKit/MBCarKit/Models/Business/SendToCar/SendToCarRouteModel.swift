//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of coordinates
public struct SendToCarRouteModel: Codable {
	
	public let notificationText: String?
	public let routeTitle: String?
	public let routeType: HuCapability
	public let waypoints: [SendToCarWaypointModel]

	
	// MARK: - Init
	
	public init(routeType: HuCapability, waypoints: [SendToCarWaypointModel], routeTitle: String? = nil, notificationText: String? = nil) {

		self.notificationText = notificationText
		self.routeTitle       = routeTitle
		self.routeType        = routeType
		self.waypoints        = waypoints
	}
}

//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public extension Notification.Name {
	
	/// Will be sent when the services of the selected vehicle was changed in cache
	///
	/// Returns the vehicle service status as object of the notification grouped by category name
	static let didChangeServiceGroups = Notification.Name("MyCar.DidChangeServiceGroups")
	
	/// Will be sent when the services of the selected vehicle was changed in cache
	///
	/// Returns the vehicle service status as object of the notification
	static let didChangeServices = Notification.Name("MyCar.DidChangeServices")
	
	/// Will be sent when the vehicle masterdata was changed in cache
	///
	/// - Returns:
	///   - object: ResultsVehicleProvider as object of the notification
	///   - userInfo: A dictionary consists of the keys \"deletions\", \"insertions\” and \”modifications\”. Each key contains an array of Int that represents the changed indexes in the cache.
	static let didChangeVehicles = Notification.Name("MyCar.DidChangeVehicles")
	
	/// Will be sent when the selected vehicle was changed in cache
	///
	/// Returns the current vehicle status as object of the notification
	static let didChangeVehicleSelection = Notification.Name("MyCar.DidChangeVehicleSelection")
}

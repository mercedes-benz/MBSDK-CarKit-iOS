//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// The process error of vehicle commands
public enum CommandProcessError: CaseIterable {
	/// Error on creating a command
	case createCommand
	/// Can't send a command to a vehicle because there is no vehicle selected
	case noVehicleSelected
	/// Socket is dosconnected
	case socketDisconnect
	/// Can't send command because the time limit was exceeded
	case timeout
}

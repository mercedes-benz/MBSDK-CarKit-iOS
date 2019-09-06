//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Socket connection state for the my car socket connection
public enum MyCarSocketConnectionState {
	
	/// Socket is closed and has no listener
	case closed
	/// Socket is connected
	case connected
	/// The setup of the socket connection has started
	case connecting
	/// Socket lost the connection with the indication of wheter a refresh of the jwt is needed
	case connectionLost(needsTokenUpdate: Bool)
	/// Socket is disconnected with all available listeners
	case disconnected
}

/// Socket state for the my car socket connection
@available(*, deprecated, message: "Use MyCarSocketConnectionState instead.")
public enum MyCarSocketState {
	
	/// Socket is closed and has no listener
	case closed
	/// Socket is connected with observables
	case connected(socketObservable: SocketObservableProtocol)
	/// The setup of the socket connection has started with the current cached vehicle attribute status
	case connecting(vehicleStatusModel: VehicleStatusModel)
	/// Socket lost the connection with the indication of wheter a refresh of the jwt is needed
	case connectionLost(needsTokenUpdate: Bool)
	/// Socket is disconnected with all available listeners
	case disconnected
}


// MARK: - Equatable

extension MyCarSocketState: Equatable {

	public static func == (lhs: MyCarSocketState, rhs: MyCarSocketState) -> Bool {
		switch (lhs, rhs) {
		
		case (.closed, .closed):					return true
		case (.connected, .connected):				return true
		case (.connecting, .connecting):			return true
		case (.connectionLost, .connectionLost):	return true
		case (.disconnected, .disconnected):		return true
		default: 										return false
		}
	}
}

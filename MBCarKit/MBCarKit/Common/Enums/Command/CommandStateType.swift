//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

// MARK: - CommandStateType

/// State type of vehicle commands
@available(*, deprecated, message: "Use CommandVehicleApiStateType instead.")
public enum CommandStateType: CaseIterable {
	case created
	case enqueued
	case finished
	case processing
	case suspended
	case unknown
}


// MARK: - Extension

extension CommandStateType {
	
	public var title: String {
		switch self {
		case .created:		return "created"
		case .enqueued:		return "enqueued"
		case .finished:		return "finished"
		case .processing:	return "processing"
		case .suspended:	return "suspended"
		case .unknown:		return "-"
		}
	}
}


// MARK: - CommandVehicleApiStateType

/// State type of vehicle api based commands
public enum CommandVehicleApiStateType: CaseIterable {
	case enqueued
	case failed
	case finished
	case initiation
	case processing
	case waiting
	case unknown
}


// MARK: - Extension

extension CommandVehicleApiStateType {
	
	public var title: String {
		switch self {
		case .enqueued:		return "enqueued"
		case .failed:		return "failed"
		case .finished:		return "finished"
		case .initiation:	return "initiation"
		case .processing:	return "processing"
		case .waiting:		return "waiting"
		case .unknown:		return "-"
		}
	}
}


// MARK: - CommandState

/// Command state type of vehicle api based commands
public enum CommandState: CaseIterable {
	case cancelled
	case enqueued
	case initiation
	case processing
	case waiting
}

// MARK: - Extension

extension CommandState {
	
	public var title: String {
		switch self {
		case .cancelled:	return "cancelled"
		case .enqueued:		return "enqueued"
		case .initiation:	return "initiation"
		case .processing:	return "processing"
		case .waiting:		return "waiting"
		}
	}
}

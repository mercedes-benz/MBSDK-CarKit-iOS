//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit
import MBNetworkKit

let LOG = MBLogger.shared

/// Main part of the MBCarKir-module
///
/// Fascade to communicate with all provided services
public class MBCarKit {
	
	// MARK: Typealias
	
	/// Completion for commands
	///
	/// Returns a CommandProcessState
	public typealias CommandResult = (CommandProcessState) -> Void
	
	/// Completion for vehicle api based commands
	///
	/// Returns a CommandProcessVehicleApiState
	public typealias CommandVehicleApiResult = (CommandProcessVehicleApiState) -> Void
	
	/// Completion for vehicle api based commands
	public typealias CommandUpdateCallback<T: CommandErrorProtocol> = (CommandProcessingState<T>, CommandProcessingMetaData) -> Void

	/// Completion for error message
	///
	/// Returns a string
	public typealias ErrorDescription = (String) -> Void

	// MARK: Properties
	private static let shared = MBCarKit()
	private let serviceAssignment: AssignmentService
	private let serviceDealer: DealerService
	private let serviceServices: ServicesService
	private let serviceSendToCar: SendToCarService
	private let serviceSocket: SocketService
	private let serviceVehicle: VehicleService
	private let serviceVehicleImage: VehicleImageService
	
	static var defaultRequestTimeout: TimeInterval = 10
	
	
	// MARK: - Public
	
	/// Access to assignment services
	public static var assignmentService: AssignmentService {
		return self.shared.serviceAssignment
	}
	
	/// Access to dealer services
	public static var dealerService: DealerService {
		return self.shared.serviceDealer
	}
	
	/// Access to service services
	public static var servicesService: ServicesService {
		return self.shared.serviceServices
	}
	
	/// Access to send to car services
	public static var sendToCarService: SendToCarService {
		return self.shared.serviceSendToCar
	}
	
	/// Access to socket services
	public static var socketService: SocketService {
		return self.shared.serviceSocket
	}

	/// Access to vehicle image services
	public static var vehicleImageService: VehicleImageService {
		return self.shared.serviceVehicleImage
	}
	
	/// Access to vehicle service
	public static var vehicleService: VehicleService {
		return self.shared.serviceVehicle
	}
	
	/// Returns the cached status of the selected vehicle
	public class func currentVehicleStatus() -> VehicleStatusModel {
		return CacheService.getCurrentStatus()
	}
	
	/// Web socket has connection to network
	public class var isConnectToWebSocket: Bool {
		return Socket.service.isConnected
	}
	
	/// Returns whether a vehicle has been selected
	public class var isVehicleSelected: Bool {
		return MBCarKit.selectedFinOrVin.isEmpty == false
	}
	
	/// Returns the vin for a selected vehicle
	public class var selectedFinOrVin: String {
		return DatabaseService.selectedFinOrVin
	}
	
	/// Returns the vehicle for the selected vin
	public class var selectedVehicle: VehicleModel? {
		return DatabaseVehicleService.item(with: MBCarKit.selectedFinOrVin)
	}

	/// Returns the vehicle for a finOrVin
	public class func vehicle(for finOrVin: String) -> VehicleModel? {
		return DatabaseVehicleService.item(with: finOrVin)
	}
	
	/// Returns the cached status of vehicle, finOrVin-based
	public class func vehicleStatus(for finOrVin: String) -> VehicleStatusModel {
		return CacheService.getStatus(for: finOrVin)
	}
	
	/// CountryCode
	public static var countryCode = Locale.current.regionCode ?? ""

	/// Locale identifier
	public static var localeIdentifier = Locale.current.identifier.replacingOccurrences(of: "_", with: "-")
	
	/// Returns the bff provider
	public static var bffProvider: BffProviding?
	
	/// Returns the bluetooth provider for send to car feature
	public static var bluetoothProvider: BluetoothProviding?
	
	/// Returns the cdn provider
	public static var cdnProvider: UrlProviding?

	/// Returns the custom pin provider
	public static var pinProvider: PinProviding?
	
	/// Shared vehicle selection for app family concept
	public static var sharedVehicleSelection: String?
	
	/// Returns the custom token provider
	public static var tokenProvider: TokenProviding = TokenProviderArchetype()

	private var databaseNotificationService: DatabaseNotificationService
	
	
	// MARK: - Initializer
	
	private init() {
		
		self.serviceAssignment   = AssignmentService()
		self.serviceDealer       = DealerService()
		self.serviceSendToCar    = SendToCarService()
		self.serviceServices     = ServicesService()
		self.serviceSocket       = SocketService()
		self.serviceVehicle      = VehicleService()
		self.serviceVehicleImage = VehicleImageService()

		self.databaseNotificationService = DatabaseNotificationService()
	}
	
	
	// MARK: - Socket

	public class func logout() {

		CacheService.deleteAll()
		ImageCacheService.deleteAll(method: .async)
	}
}

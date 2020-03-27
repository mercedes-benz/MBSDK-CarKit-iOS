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
public class CarKit {
	
	// MARK: Typealias
	
	/// Completion for vehicle api based commands
	public typealias CommandUpdateCallback<T: CommandErrorProtocol> = (CommandProcessingState<T>, CommandProcessingMetaData) -> Void

	/// Completion for error message
	///
	/// Returns a string
	public typealias ErrorDescription = (String) -> Void

	// MARK: Properties
	private static let shared = CarKit()
	private let assignmentService: AssignmentService
	private let dealerService: DealerService
    private let geofencingService: GeofencingService
    private let geofencingViolationsService: GeofencingViolationService
	private let sendToCarService: SendToCarService
	private let servicesService: ServicesService
	private let socketService: SocketService
    private let speedAlertService: SpeedAlertService
    private let speedFenceService: SpeedFenceService
    private let topViewService: TopViewService
    private let valetProtectService: ValetProtectService
	private let vehicleImageService: VehicleImageService
	private let vehicleService: VehicleService

	static var defaultRequestTimeout: TimeInterval = 10
	
	
	// MARK: - Public
	
	/// Access to assignment services
	public static var assignmentService: AssignmentService {
		return self.shared.assignmentService
	}
	
	/// Access to dealer services
	public static var dealerService: DealerService {
		return self.shared.dealerService
	}
	
	/// Access to geofencing service
    public static var geofencingService: GeofencingService {
        return self.shared.geofencingService
    }
    
    /// Access to geofencing violations service
    public static var geofencingViolationsService: GeofencingViolationService {
        return self.shared.geofencingViolationsService
    }
	
	/// Access to service services
	public static var servicesService: ServicesService {
		return self.shared.servicesService
	}
	
	/// Access to send to car services
	public static var sendToCarService: SendToCarFunctions {
		return self.shared.sendToCarService
	}
	
	/// Access to socket services
	public static var socketService: SocketService {
		return self.shared.socketService
	}

	/// Access to speed alert service
    public static var speedAlertService: SpeedAlertService {
        return self.shared.speedAlertService
    }
    
    /// Access to speedfence service
    public static var speedFenceService: SpeedFenceService {
        return self.shared.speedFenceService
    }
	
	/// Access to top view services
    public static var topViewService: TopViewService {
        return self.shared.topViewService
    }
	
	/// Access to valet protect service
    public static var valetProtectService: ValetProtectService {
        return self.shared.valetProtectService
    }
	
	/// Access to vehicle service
	public static var vehicleService: VehicleService {
		return self.shared.vehicleService
	}
	
	/// Access to vehicle image services
	public static var vehicleImageService: VehicleImageService {
		return self.shared.vehicleImageService
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
		return CarKit.selectedFinOrVin?.isEmpty == false
	}
	
	/// Returns the vin for a selected vehicle
	public class var selectedFinOrVin: String? {
		return DatabaseVehicleSelectionService.selectedVehicle?.finOrVin
	}
	
	/// Returns the vehicle for the selected vin
	public class var selectedVehicle: VehicleModel? {
		guard let selectedFinOrVin = CarKit.selectedFinOrVin else {
			return nil
		}
		return DatabaseVehicleService.item(with: selectedFinOrVin)
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
		
		self.assignmentService   = AssignmentService()
		self.dealerService       = DealerService()
        self.geofencingService   = GeofencingService()
        self.geofencingViolationsService = GeofencingViolationService()
		self.sendToCarService    = SendToCarService()
		self.servicesService     = ServicesService()
		self.socketService       = SocketService()
        self.speedAlertService   = SpeedAlertService()
        self.speedFenceService   = SpeedFenceService()
        self.topViewService      = TopViewService()
        self.valetProtectService = ValetProtectService()
		self.vehicleImageService = VehicleImageService()
		self.vehicleService      = VehicleService()
		
		self.databaseNotificationService = DatabaseNotificationService()
	}
	
	
	// MARK: - Socket

	public class func logout() {

		CacheService.deleteAll()
		ImageCacheService.deleteAll(method: .async)
	}
}

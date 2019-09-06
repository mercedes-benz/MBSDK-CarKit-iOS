//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift
import MBRealmKit

public class DatabaseVehicleServicesService {
	
	// MARK: Typealias
	public typealias Completion = () -> Void
	typealias InitialProvider = (_ results: Results<DBVehicleServicesModel>) -> Void
	typealias UpdateProvider = (_ results: Results<DBVehicleServicesModel>, _ deletions: [Int], _ insertions: [Int], _ modifications: [Int]) -> Void
	
	internal typealias BusinessModelType = VehicleServiceModel
	internal typealias DatabaseModelType = DBVehicleServicesModel
	
	// MARK: Properties
	private static let config = DatabaseConfig()
	private static let realm = RealmLayer<DatabaseModelType>(config: DatabaseVehicleServicesService.config)

	
	// MARK: - Public
	
	public static func fetchProvider(with finOrVin: String) -> ResultsServicesProvider? {
		
		guard let results = self.realm.item(with: finOrVin)?.services else {
			return nil
		}
		
		return ResultsServicesProvider(collection: AnyBidirectionalCollection(results))
	}
	
	public static func fetchProvider(with finOrVin: String, categoryName: String) -> ResultsServicesProvider? {
		
		guard let results = self.realm.item(with: finOrVin)?.services.filter("categoryName = %@", categoryName) else {
			return nil
		}
		
		return ResultsServicesProvider(results: results)
	}
	
	public static func fetchServiceGroupProvider(with finOrVin: String) -> ResultsServiceGroupProvider? {
		
		guard let results = self.realm.item(with: finOrVin)?.services.sorted(byKeyPath: "sortIndex").distinct(by: ["categoryName"]) else {
			return nil
		}
		
		return ResultsServiceGroupProvider(results: results)
	}
	
	
	// MARK: - Internal
	
	static func delete(finOrVin: String) {
		
		guard let item = self.realm.item(with: finOrVin) else {
			return
		}
		
		self.realm.delete(object: item, method: .cascade, completion: nil)
	}
	
	static func fetch(initial: @escaping InitialProvider, update: @escaping UpdateProvider, error: RealmConstants.ErrorCompletion?) -> NotificationToken? {
		
		let results = self.realm.all()
		return self.realm.observe(results: results, error: { (observeError) in
			RealmLayer.handle(observeError: observeError, completion: error)
		}, initial: { (results) in
			initial(results)
		}, update: { (results, deletions, insertions, modifications) in
			update(results, deletions, insertions, modifications)
		})
	}
	
	static func setPendingType(finOrVin: String, services: Zip2Sequence<[BusinessModelType], [ServiceActivationStatus]>, completion: @escaping Completion) {
		
		guard let item = self.realm.item(with: finOrVin) else {
			return
		}
		
		self.realm.edit(item: item, method: .async, editBlock: { (_, item, editCompletion) in
			
			if item.isInvalidated == false {
				
				let predicates = services.map { NSPredicate(format: "id == %i", $0.0.id) }
				let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
				
				let results = item.services.filter(predicate)
				services.forEach {
					self.pendingStatus(results: results, service: $0)
				}
			}
			
			editCompletion()
		}, completion: completion)
	}
	
	static func setPendingType(services: [VehicleServicesStatusUpdateModel], completion: @escaping Completion) {
		
		let predicates = services.map { NSPredicate(format: "finOrVin = %@", $0.finOrVin) }
		let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
		
		guard let results = self.realm.all()?.filter(predicate) else {
			return
		}
		
		self.realm.edit(results: results, editBlock: { (_, results, editCompletion) in
			
			services.forEach {
				
				if let item = results.filter("finOrVin = %@", $0.finOrVin).first,
					item.isInvalidated == false {
					self.setPendingType(item: item, updates: $0.services)
				}
			}
			
			editCompletion()
		}, completion: completion)
	}
	
	private static func setPendingType(item: DatabaseModelType, updates: [VehicleServiceStatusUpdateModel]) {
		
		updates.forEach {
			
			if let service = item.services.filter("id = %@", $0.id).first,
				service.isInvalidated == false {
				
				service.activationStatus = $0.status.rawValue
				let pendingStatus = self.pendingStatus(item: service, status: $0.status, allowedActions: [])
				service.pending = self.map(pendingStatus: pendingStatus)
			}
		}
	}
	
	static func update(finOrVin: String, serviceGroups: [VehicleServiceGroupModel], completion: @escaping Completion) {
		
		guard let item = self.realm.item(with: finOrVin) else {
			self.save(finOrVin: finOrVin, serviceGroups: serviceGroups, completion: completion)
			return
		}
		
		self.realm.edit(item: item, method: .async, editBlock: { (_, item, editCompletion) in

			if item.isInvalidated == false {

				let incomingServicesCount = serviceGroups.flatMap { $0.services }.count
				
				/// pre assigned vehicles
				let prePendingResults = item.services.filter("pending != %@", "")
				
				if item.services.count <= incomingServicesCount {
					
					/// remove and add all services again
					let dbServiceItems = DatabaseModelMapper.map(serviceGroups: serviceGroups)
					
					dbServiceItems.forEach {
						self.pendingStatus(results: prePendingResults, dbServiceModel: $0)
					}
					
					item.services.delete(method: .cascade, type: DBVehicleServiceModel.self)
					item.services.append(objectsIn: dbServiceItems)
				} else {
					
					/// selected update
					let services = serviceGroups.flatMap { $0.services }
					let predicates = services.map { NSPredicate(format: "id = %i", $0.id) }
					let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
					
					item.services.filter(predicate).forEach { (dbServiceModel) in
						
						if dbServiceModel.isInvalidated == false {
							
							if let service = services.first(where: { $0.id == dbServiceModel.id }) {

								dbServiceModel.prerequisites.delete(method: .cascade, type: DBVehicleServicePrerequisiteModel.self)
								DatabaseModelMapper.map(service: service, dbService: dbServiceModel)
								
								let pendingStatus = self.pendingStatus(item: dbServiceModel, status: service.activationStatus, allowedActions: service.allowedActions)
								dbServiceModel.pending = self.map(pendingStatus: pendingStatus)
							}
						}
					}
				}
			}

			editCompletion()
		}, completion: completion)
	}
	
	
	// MARK: - Helper
	
	private static func map(pendingStatus: ServicePendingState) -> String {
		
		switch pendingStatus {
		case .activation:	return pendingStatus.rawValue
		case .deactivation:	return pendingStatus.rawValue
		case .none:			return ""
		}
	}
	
	private static func pendingStatus(item: DBVehicleServiceModel, status: ServiceActivationStatus, allowedActions: [ServiceAction]) -> ServicePendingState {

		let currentPendingStatus: ServicePendingState = ServicePendingState(rawValue: item.pending) ?? .none
		switch currentPendingStatus {
		case .activation:
			let canResetPendingState = status == .active || (status == .activationPending && allowedActions.contains(.setDesiredInactive))
			return canResetPendingState ? .none : currentPendingStatus
			
		case .deactivation:
			let canResetPendingState = status == .inactive || (status == .deactivationPending && allowedActions.contains(.setDesiredActive))
			return canResetPendingState ? .none : currentPendingStatus
			
		case .none:
			switch status {
			case .activationPending:			return .activation
			case .active:						return .none
			case .deactivationPending:			return .deactivation
			case .inactive:						return .none
			case .unknown:						return .none
			case .unknownActivationPending:		return .none
			case .unknownDeactivationPending:	return .none
			}
		}
	}
	
	private static func pendingStatus(item: DBVehicleServiceModel, status: ServiceActivationStatus, allowedActions: String) -> ServicePendingState {
		
		let actions: [ServiceAction] = allowedActions.components(separatedBy: ",").compactMap { ServiceAction(rawValue: $0) }
		return self.pendingStatus(item: item, status: status, allowedActions: actions)
	}
	
	private static func pendingStatus(results: Results<DBVehicleServiceModel>, dbServiceModel: DBVehicleServiceModel) {
		
		guard let item = results.filter("id = %@", dbServiceModel.id).first else {
			return
		}

		let status = ServiceActivationStatus(rawValue: dbServiceModel.activationStatus) ?? .unknown
		let pendingStatus = self.pendingStatus(item: item, status: status, allowedActions: dbServiceModel.allowedActions)
		dbServiceModel.pending = self.map(pendingStatus: pendingStatus)
		
		LOG.D("change service status 1: \(dbServiceModel.id) to: \(pendingStatus.rawValue)")
	}
	
	private static func pendingStatus(results: Results<DBVehicleServiceModel>, service: (model: BusinessModelType, desiredStatus: ServiceActivationStatus)) {
		
		guard let item = results.filter("id = %@", service.model.id).first else {
			return
		}
		
		guard service.model.activationStatus != service.desiredStatus else {
			LOG.D("change service status 2: \(item.id) to: \(ServicePendingState.none.rawValue)")
			item.pending = ""
			return
		}
		
		let newPendingStatus: ServicePendingState = {
			switch service.desiredStatus {
			case .activationPending:			return .activation
			case .active:						return .activation
			case .deactivationPending:			return .deactivation
			case .inactive:						return .deactivation
			case .unknown:						return .none
			case .unknownActivationPending:		return .activation
			case .unknownDeactivationPending:	return .deactivation
			}
		}()
		
		item.pending = newPendingStatus.rawValue
		LOG.D("change service status 3: \(item.id) to: \(newPendingStatus.rawValue)")
	}
	
	private static func save(finOrVin: String, serviceGroups: [VehicleServiceGroupModel], completion: @escaping Completion) {
		
		let object = DatabaseModelMapper.map(finOrVin: finOrVin, serviceGroups: serviceGroups)
		self.realm.save(object: object,
						update: true,
						method: .async) {
							completion()
		}
	}
}

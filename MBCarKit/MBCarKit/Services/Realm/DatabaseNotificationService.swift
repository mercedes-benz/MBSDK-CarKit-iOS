//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBCommonKit
import MBRealmKit
import RealmSwift

class DatabaseNotificationService {
	
	// MARK: Struct
	private struct Keys {
		static let deletions = "deletions"
		static let insertions = "insertions"
		static let modifications = "modifications"
		static let selectedFinOrVin = "selectedFinOrVin"
	}
	
	private struct Token {
		static let select = "select"
		static let services = "services"
		static let vehicles = "vehicles"
	}
	
	// MARK: Lazy
	private lazy var tokenName: String = {
		return String(describing: self)
	}()
	
	
	// MARK: - Init
	
	init() {
		
		self.observeVehicles()
		self.observeSelectVehicle()
		self.observeServices()
	}
	
	
	// MARK: - Object life cycle
	
	deinit {
		LOG.V()
		
		RealmToken.invalide(for: self.tokenName + Token.vehicles)
		RealmToken.invalide(for: self.tokenName + Token.select)
		RealmToken.invalide(for: self.tokenName + Token.services)
	}
	
	
	// MARK: - Helper
	
	private func didChangeServices(results: Results<DBVehicleServicesModel>, deletions: [Int]?, insertions: [Int]?, modifications: [Int]?) {
		
		let selectedFinOrVin = DatabaseService.selectedFinOrVin
		guard results.isEmpty == false,
			selectedFinOrVin.isEmpty == false else {
				return
		}
		
		insertions?.forEach {
			
			if let item = results.item(at: $0),
				item.finOrVin == selectedFinOrVin {
				self.postServicesNotifications(item: item)
			}
		}
		
		modifications?.forEach {
			
			if let item = results.item(at: $0),
				item.finOrVin == selectedFinOrVin {
				self.postServicesNotifications(item: item)
			}
		}
		
		if insertions == nil && modifications == nil {
			if let item = results.filter("finOrVin = %@", selectedFinOrVin).first {
				self.postServicesNotifications(item: item)
			}
		}
	}
	
	private func didChangeVehicles(provider: ResultsVehicleProvider, deletions: [Int]?, insertions: [Int]?, modifications: [Int]?) {
		
		LOG.D("post didChangeVehicles")
		
		let userInfo: [String: [Int]]? = {
			
			guard let deletions = deletions,
				let insertions = insertions,
				let modifications = modifications else {
					return nil
			}
			
			return [
				Keys.deletions: deletions,
				Keys.insertions: insertions,
				Keys.modifications: modifications
			]
		}()
		NotificationCenter.default.post(name: NSNotification.Name.didChangeVehicles,
										object: provider,
										userInfo: userInfo)
	}
	
	private func didChangeVehicleSelection(updateObservables: Bool) {
		
		let selectedFinOrVin = DatabaseService.selectedFinOrVin
		
		LOG.D("post didChangeVehicleSelection: \(selectedFinOrVin)")
		
		if selectedFinOrVin.isEmpty == false {
			MBCarKit.servicesService.fetchVehicleServices(finOrVin: selectedFinOrVin, groupedOption: .categoryName, services: nil, completion: { (_) in
				
			}, onError: { (_) in
				
			})
		}
		
		let currentVehicleStatus = MBCarKit.currentVehicleStatus()
		let userInfo = [
			Keys.selectedFinOrVin: selectedFinOrVin
		]
		
		if updateObservables {
			MBCarKit.socketService.updateObservables()
		}
		
		NotificationCenter.default.post(name: NSNotification.Name.didChangeVehicleSelection,
										object: currentVehicleStatus,
										userInfo: userInfo)
	}
	
	private func observeSelectVehicle() {
		
		let token = DatabaseService.fetchSelectVehicle(initial: { [weak self] in
			self?.didChangeVehicleSelection(updateObservables: false)
		}, update: { [weak self] in
			self?.didChangeVehicleSelection(updateObservables: true)
		}, error: nil)
		
		RealmToken.set(token: token, for: self.tokenName + Token.select)
	}
	
	private func observeServices() {
		
		let token = DatabaseVehicleServicesService.fetch(initial: { [weak self] (results) in
			self?.didChangeServices(results: results,
									deletions: nil,
									insertions: nil,
									modifications: nil)
		}, update: { [weak self] (results, deletions, insertions, modifications) in
			self?.didChangeServices(results: results,
									deletions: deletions,
									insertions: insertions,
									modifications: modifications)
		}, error: nil)
		
		RealmToken.set(token: token, for: self.tokenName + Token.services)
	}
	
	private func observeVehicles() {
		
		let token = DatabaseVehicleService.fetch(initial: { [weak self] (provider) in
			self?.didChangeVehicles(provider: provider,
									deletions: nil,
									insertions: nil,
									modifications: nil)
		}, update: { [weak self] (provider, deletions, insertions, modifications) in
			self?.didChangeVehicles(provider: provider,
									deletions: deletions,
									insertions: insertions,
									modifications: modifications)
		}, error: nil)
		
		RealmToken.set(token: token, for: self.tokenName + Token.vehicles)
	}
	
	private func postServicesNotifications(item: DBVehicleServicesModel) {
		LOG.D("post didChangeServices")
		
		let servicesProvider = ResultsServicesProvider(collection: AnyBidirectionalCollection(item.services))
		NotificationCenter.default.post(name: NSNotification.Name.didChangeServices,
										object: servicesProvider)
		
		let serviceGroupProvider = DatabaseVehicleServicesService.fetchServiceGroupProvider(with: item.finOrVin)
		NotificationCenter.default.post(name: NSNotification.Name.didChangeServiceGroups,
										object: serviceGroupProvider)
	}
}

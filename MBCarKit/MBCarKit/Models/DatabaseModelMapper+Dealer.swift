//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift

extension DatabaseModelMapper {
	
	// MARK: BusinessModel
	
	static func map(dbVehicleDealerItemList: List<DBVehicleDealerItemModel>) -> [VehicleDealerItemModel] {
		return dbVehicleDealerItemList.compactMap { (dealerItem) -> VehicleDealerItemModel? in

			guard let role = DealerRole(rawValue: dealerItem.role) else {
				return nil
			}

			return VehicleDealerItemModel(dealerId: dealerItem.dealerId,
										  role: role,
										  merchant: self.map(dbDealerMerchantModel: dealerItem.merchant))
		}
	}
	
	
	// MARK: DatabaseModel
	
	static func map(vehicleDealerItemModels: [VehicleDealerItemModel]) -> [DBVehicleDealerItemModel] {
		return vehicleDealerItemModels.map { self.map(vehicleDealerItemModel: $0) }
	}
	
	
	// MARK: Helper
	
	private static func map(dbDealerMerchantModel: DBDealerMerchantModel?) -> DealerMerchantModel? {

		guard let merchant = dbDealerMerchantModel else {
			return nil
		}
		return DealerMerchantModel(legalName: merchant.legalName,
								   address: self.map(dbDealerAddress: merchant.address),
								   openingHours: self.map(dbDealerOpeningHours: merchant.openingHours))
	}

	private static func map(dbDealerAddress: DBDealerAddressModel?) -> DealerAddressModel? {

		guard let address = dbDealerAddress else {
			return nil
		}
		return DealerAddressModel(street: address.street,
								  addressAddition: address.addressAddition,
								  zipCode: address.zipCode,
								  city: address.city,
								  district: address.district,
								  countryIsoCode: address.countryIsoCode)
	}

	private static func map(dbDealerOpeningHours: DBDealerOpeningHoursModel?) -> DealerOpeningHoursModel? {

		guard let openingHours = dbDealerOpeningHours else {
			return nil
		}
		return DealerOpeningHoursModel(monday: self.map(dbDealerOpeningDay: openingHours.monday),
									   tuesday: self.map(dbDealerOpeningDay: openingHours.tuesday),
									   wednesday: self.map(dbDealerOpeningDay: openingHours.wednesday),
									   thursday: self.map(dbDealerOpeningDay: openingHours.thursday),
									   friday: self.map(dbDealerOpeningDay: openingHours.friday),
									   saturday: self.map(dbDealerOpeningDay: openingHours.saturday),
									   sunday: self.map(dbDealerOpeningDay: openingHours.sunday))
	}

	private static func map(dbDealerOpeningDay: DBDealerOpeningDayModel?) -> DealerOpeningDay {

		guard let day = dbDealerOpeningDay else {
			return DealerOpeningDay(status: nil)
		}
		return DealerOpeningDay(status: self.map(dbDealerOpeningDay: day))
	}

	private static func map(dbDealerOpeningDay: DBDealerOpeningDayModel) -> DealerOpeningStatus {

		let lastPeriod = dbDealerOpeningDay.periods.last
		switch dbDealerOpeningDay.status {
		case "OPEN":
			return DealerOpeningStatus.open(from: lastPeriod?.from ?? "", until: lastPeriod?.until ?? "")
		case "CLOSE":
			return DealerOpeningStatus.closed
		default:
			return DealerOpeningStatus.closed
		}
	}

	private static func map(vehicleDealerItemModel: VehicleDealerItemModel) -> DBVehicleDealerItemModel {

		let dbVehicleDealerItemModel      = DBVehicleDealerItemModel()
		dbVehicleDealerItemModel.dealerId = vehicleDealerItemModel.dealerId
		dbVehicleDealerItemModel.role     = vehicleDealerItemModel.role.rawValue
		dbVehicleDealerItemModel.merchant = self.map(dealerMerchantModel: vehicleDealerItemModel.merchant)
		return dbVehicleDealerItemModel
	}

	private static func map(dealerMerchantModel: DealerMerchantModel?) -> DBDealerMerchantModel? {

		guard let merchant = dealerMerchantModel else {
			return nil
		}

		let dbDealerMerchantModel = DBDealerMerchantModel()
		dbDealerMerchantModel.legalName = merchant.legalName ?? ""
		dbDealerMerchantModel.address = self.map(dealerAddress: merchant.address)
		dbDealerMerchantModel.openingHours = self.map(dealerOpeningHours: merchant.openingHours)
		return dbDealerMerchantModel
	}

	private static func map(dealerAddress: DealerAddressModel?) -> DBDealerAddressModel? {

		guard let address = dealerAddress else {
			return nil
		}

		let dbDealerAddressModel = DBDealerAddressModel()
		dbDealerAddressModel.addressAddition = address.addressAddition ?? ""
		dbDealerAddressModel.city = address.city ?? ""
		dbDealerAddressModel.countryIsoCode = address.countryIsoCode ?? ""
		dbDealerAddressModel.district = address.district ?? ""
		dbDealerAddressModel.street = address.street ?? ""
		dbDealerAddressModel.zipCode = address.zipCode ?? ""
		return dbDealerAddressModel
	}

	private static func map(dealerOpeningHours: DealerOpeningHoursModel?) -> DBDealerOpeningHoursModel? {

		guard let openingHours = dealerOpeningHours else {
			return nil
		}

		let dbDealerOpeningHoursModel = DBDealerOpeningHoursModel()
		dbDealerOpeningHoursModel.monday = self.map(dealerOpeningDay: openingHours.monday)
		dbDealerOpeningHoursModel.tuesday = self.map(dealerOpeningDay: openingHours.tuesday)
		dbDealerOpeningHoursModel.wednesday = self.map(dealerOpeningDay: openingHours.wednesday)
		dbDealerOpeningHoursModel.thursday = self.map(dealerOpeningDay: openingHours.thursday)
		dbDealerOpeningHoursModel.friday = self.map(dealerOpeningDay: openingHours.friday)
		dbDealerOpeningHoursModel.sunday = self.map(dealerOpeningDay: openingHours.sunday)
		dbDealerOpeningHoursModel.saturday = self.map(dealerOpeningDay: openingHours.saturday)
		return dbDealerOpeningHoursModel
	}

	private static func map(dealerOpeningDay: DealerOpeningDay?) -> DBDealerOpeningDayModel? {

		guard let openingDay = dealerOpeningDay else {
			return nil
		}
		let dbDealerOpeningDayModel = DBDealerOpeningDayModel()
		switch openingDay.status {
		case .some(.open(let from, let until)):
			dbDealerOpeningDayModel.status = "OPEN"
			let period = DBDealerDayPeriodModel()
			period.until = until ?? ""
			period.from = from ?? ""
			dbDealerOpeningDayModel.periods.append(period)
		case .some(.closed):
			dbDealerOpeningDayModel.status = "CLOSE"
		default:
			break
		}
		return dbDealerOpeningDayModel
	}
}

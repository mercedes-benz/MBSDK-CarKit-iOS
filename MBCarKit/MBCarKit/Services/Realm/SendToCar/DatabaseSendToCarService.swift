//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//
import Foundation
import RealmSwift
import MBRealmKit

 class DatabaseSendToCarService {

    // MARK: Typealias
    internal typealias SaveCompletion = () -> Void

    internal typealias BusinessModelType = ResultsSendToCarProvider.BusinessModelType
    internal typealias DatabaseModelType = ResultsSendToCarProvider.DatabaseModelType

    internal typealias ChangeItem = (_ properties: [PropertyChange]) -> Void
    internal typealias DeletedItems = () -> Void
    internal typealias InitialItem = (BusinessModelType) -> Void
    internal typealias InitialProvider = (_ provider: ResultsSendToCarProvider) -> Void
    internal typealias UpdateProvider = (_ provider: ResultsSendToCarProvider, _ deletions: [Int], _ insertions: [Int], _ modifications: [Int]) -> Void

    // MARK: Properties
    private static let config = DatabaseConfig()
    private static let realm = RealmLayer<DatabaseModelType>(config: DatabaseSendToCarService.config)


    // MARK: - Public
    
    static func delete(with finOrVin: String) {

        guard let item = self.realm.item(with: finOrVin) else {
            return
        }

        self.realm.delete(object: item, method: .cascade, completion: nil)
    }

    static func deleteAll(completion: DeletedItems?) {

        guard let results = self.realm.all(), results.isEmpty == false else {
            completion?()
            return
        }

        self.realm.delete(results: results, method: .cascade) {
            completion?()
        }
    }

    static func item(with finOrVin: String?) -> BusinessModelType {

        guard let finOrVin = finOrVin,
            let item = self.realm.item(with: finOrVin) else {
                return DatabaseModelMapper.map(dbSendToCarCapabilitiesModel: DBSendToCarCapabilitiesModel())
            }

        return DatabaseModelMapper.map(dbSendToCarCapabilitiesModel: item)
    }

    static func item(with finOrVin: String,
                     initial: @escaping InitialItem,
                     change: @escaping ChangeItem,
                     deleted: @escaping DeletedItems,
                     error: RealmConstants.ErrorCompletion?) -> NotificationToken? {

        let item = self.realm.item(with: finOrVin)
        return self.realm.observe(item: item, error: { (observeError) in
            RealmLayer.handle(observeError: observeError, completion: error)
        }, initial: { (item) in
            initial(DatabaseModelMapper.map(dbSendToCarCapabilitiesModel: item))
        }, change: { (properties) in
            change(properties)
        }, deleted: {
            deleted()
        })
    }

     static func save(sendToCarModel: BusinessModelType, finOrVin: String, completion: @escaping SaveCompletion) {

         guard let item = self.realm.item(with: finOrVin) else {

            let DBSendToCarCapabilitiesModel      = DatabaseModelMapper.map(sendToCarCapabilitiesModel: sendToCarModel)
            DBSendToCarCapabilitiesModel.finOrVin = finOrVin

             self.realm.save(object: DBSendToCarCapabilitiesModel,
                            update: true,
                            method: .async) {
                                completion()
            }

             return
        }

        self.realm.edit(item: item, method: .async, editBlock: { (_, item, editCompletion) in

            if item.isInvalidated == false {
                
				let sendToCarItem = DatabaseModelMapper.map(sendToCarCapabilitiesModel: sendToCarModel)
				item.capabilities.delete(method: .cascade, type: DBSendToCarCapabilityModel.self)
				item.capabilities.append(objectsIn: sendToCarItem.capabilities)
            }
            editCompletion()
        }, completion: {
            completion()
        })
    }
}

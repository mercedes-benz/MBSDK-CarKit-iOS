//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift
import MBRealmKit

/// Service for database-based image caching
class TopImageCacheService {
	
	// MARK: Typealias
	
	/// Completion for database transactions
	public typealias Completion = () -> Void
	
	internal typealias BusinessModelType = TopImageModel
	internal typealias DatabaseModelType = DBTopImageModel
	
	// MARK: Properties
	private static let config = ImageCacheConfig()
	private static let realm = RealmLayer<DBTopImageModel>(config: TopImageCacheService.config)
	
	
	// MARK: - Public
	
	/// Delete a single image from database
	///
	/// - Parameters:
	///   - finOrVin: Vehicle identifier
	public static func delete(with finOrVin: String) {
		
		guard let item = self.realm.item(with: finOrVin) else {
			return
		}
		self.realm.delete(object: item, method: .cascade, completion: nil)
	}
    
    /// Delete the complete vahicle image database
    ///
    /// - Parameters:
    ///   - method: Write method async or sync
    public static func deleteAll(method: RealmConstants.RealmWriteMethod) {
        
        switch method {
        case .async:
            guard let results = self.realm.all() else {
                return
            }
            
            self.realm.delete(results: results, method: .cascade, completion: nil)
            
        case .sync:
            self.realm.deleteAll()
        }
    }
	
	/// Fetch a top image from database
	///
	/// - Parameters:
	///   - finOrVin: Vehicle identifier
	/// - Returns: Optional TopImageCacheModel. If there no image exists the return value is nil.
	public static func item(with finOrVin: String) -> BusinessModelType? {
		
		guard let item = self.realm.item(with: finOrVin) else {
			return nil
		}
		return DatabaseModelMapper.map(dbTopImageModel: item)
	}

    static func save(topImageModel model: TopImageModel, completion: @escaping Completion) {
		
		guard let item = self.realm.item(with: model.vin) else {

			self.realm.save(object: DatabaseModelMapper.map(topImageModel: model),
							update: true,
							method: .async,
							completion: completion)
			return
		}
		
		self.realm.edit(item: item, method: .async, editBlock: { (_, item, editCompletion) in
			
			if item.isInvalidated == false {
                item.components = DatabaseModelMapper.map(topImageModel: model).components
			}
			
			editCompletion()
		}, completion: completion)
	}
}

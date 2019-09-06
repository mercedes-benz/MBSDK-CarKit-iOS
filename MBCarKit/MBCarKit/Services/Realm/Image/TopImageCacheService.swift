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
	
	/// Completion for an image
	///
	/// Returns optional image data
	public typealias ImageDataItem = (Data?) -> Void
	
	internal typealias BusinessModelType = TopImageCacheModel
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
	
	/// Fetch a top image from database with the possibility to observe any changes of that
	///
	/// - Parameters:
	///   - finOrVin: Vehicle identifier
	///   - imageData: Closure with ImageDataItem
	///   - error: Closure with ErrorCompletion
	/// - Returns: Optional NotificationToken to observe any changes
	public static func item(with finOrVin: String, imageData: @escaping ImageDataItem, error: RealmConstants.ErrorCompletion?) -> NotificationToken? {
		
		let item = self.realm.item(with: finOrVin)
		return self.realm.observe(item: item, error: { (observeError) in
			RealmLayer.handle(observeError: observeError, completion: error)
		}, initial: { (item) in
			imageData(item.imageData)
		}, change: { (properties) in

			guard let item = properties.first(where: { $0.name == "imageData" }) else {
				return
			}
			imageData(item.newValue as? Data)
		}, deleted: {})
	}
	
	static func save(finOrVin: String, etag: String, imageData: Data?, completion: @escaping Completion) {
		
		guard let item = self.realm.item(with: finOrVin) else {
			
			let dbTopImage = DatabaseModelMapper.map(finOrVin: finOrVin, etag: etag, imageData: imageData)
			self.realm.save(object: dbTopImage,
							update: true,
							method: .async,
							completion: completion)
			return
		}
		
		self.realm.edit(item: item, method: .async, editBlock: { (_, item, editCompletion) in
			
			if item.isInvalidated == false {
				item.etag = etag
				item.imageData = imageData
			}
			
			editCompletion()
		}, completion: completion)
	}
}

//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift
import MBCommonKit
import MBRealmKit

/// Service for database-based image caching
class ImageCacheService {
	
	// MARK: Typealias
	
	/// Completion for database transactions
	public typealias Completion = () -> Void
	
	/// Completion for an image
	///
	/// Returns optional image data
	public typealias ImageDataItem = (Data?) -> Void
	
	internal typealias BusinessModelType = VehicleImageRequest
	internal typealias DatabaseModelType = DBImageModel
	
	// MARK: Properties
	private static let config = ImageCacheConfig()
	private static let realm = RealmLayer<DBImageModel>(config: ImageCacheService.config)
	
	
	// MARK: - Public
	
	/// Delete a single image from database
	///
	/// - Parameters:
	///   - finOrVin: Vehicle identifier
	///   - requestImage: VehicleImageRequest with image definition
	public static func delete(with finOrVin: String, requestImage: VehicleImageRequest) {
		
		let dbItem: DatabaseModelType? = self.item(with: finOrVin, requestImage: requestImage)
		guard let item = dbItem else {
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
	
	/// Fetch a image from database
	///
	/// - Parameters:
	///   - finOrVin: Vehicle identifier
	///   - requestImage: VehicleImageRequest with image definition
	/// - Returns: Optional image data. If there no image exists the return value is nil.
	public static func item(with finOrVin: String, requestImage: VehicleImageRequest) -> Data? {
		return self.item(with: finOrVin, requestImage: requestImage)?.imageData
	}
	
	/// Fetch a image from database with the possibility to observe any changes of that
	///
	/// - Parameters:
	///   - finOrVin: Vehicle identifier
	///   - requestImage: VehicleImageRequest with image definition
	///   - imageData: Closure with ImageDataItem
	///   - error: Closure with ErrorCompletion
	/// - Returns: Optional NotificationToken to observe any changes
	public static func item(with finOrVin: String, requestImage: VehicleImageRequest, imageData: @escaping ImageDataItem, error: RealmConstants.ErrorCompletion?) -> NotificationToken? {
		
		let item: DatabaseModelType? = self.item(with: finOrVin, requestImage: requestImage)
		return self.realm.observe(item: item, error: { (observeError) in
			RealmLayer.handle(observeError: observeError, completion: error)
		}, initial: { (item) in
			imageData(item.imageData)
		}, change: { (properties) in
			
			properties.forEach {
				if $0.name == "imageData" {
					imageData($0.newValue as? Data)
				}
			}
		}, deleted: {})
	}
	
	static func save(finOrVin: String, requestImage: BusinessModelType, imageData: Data?, completion: @escaping Completion) {
		
		let dbImageModel        = DatabaseModelMapper.map(requestImage: requestImage)
		dbImageModel.imageData  = imageData
		dbImageModel.primaryKey = self.primaryKey(with: finOrVin, requestImage: requestImage)
		dbImageModel.vin        = finOrVin
		
		self.realm.save(object: dbImageModel,
						update: true,
						method: .async,
						completion: completion)
	}
	
	
	// MARK: - Helper
	
	private static func item(with finOrVin: String, requestImage: VehicleImageRequest) -> DatabaseModelType? {
		
		let primaryKey = self.primaryKey(with: finOrVin, requestImage: requestImage)
		return self.realm.item(with: primaryKey)
	}
	
	private static func primaryKey(with finOrVin: String, requestImage: VehicleImageRequest) -> String {
		
		let boolFlagBasedString = (requestImage.centered ? "Centered" : "") +
			(requestImage.fallbackImage ? "FallbackImage" : "") +
			(requestImage.night ? "Night" : "") +
			(requestImage.roofOpen ? "RoofOpen" : "")
		return finOrVin +
			requestImage.background.parameter +
			requestImage.degrees.parameter +
			requestImage.size.parameter +
			boolFlagBasedString +
			requestImage.cropOption.parameter
	}
}

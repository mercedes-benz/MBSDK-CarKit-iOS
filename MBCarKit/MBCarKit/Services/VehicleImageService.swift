//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBNetworkKit

/// Service to call all vehicle image related requests
public class VehicleImageService {

	// MARK: Typealias
	
	/// Completion for fetching one image
	///
	/// Returns an enum with image data in succeeded case and a error string in failure case
	public typealias ImageResult = (Result<Data, MBError>) -> Void
	
	/// Completion for fetching images
	///
    /// Returns array of VehicleImageModel
    public typealias ImagesCompletion = (Result<[VehicleImageModel], MBError>) -> Void
    
	internal typealias ImageAPIResult = NetworkResult<[APIVehicleImageModel]>
	internal typealias ImageHelperResult = (Result<[ImageModel], MBError>) -> Void
	internal typealias ImagesAPIResult = NetworkResult<[APIVehicleVinImageModel]>
	internal typealias ImagesHelperResult = (Result<[VehicleImageModel], MBError>) -> Void
	
	// MARK: - Public
	
	/// Checks the cache for image data
	///
	/// - Parameters:
	///   - vin: vehicle identifier (use finOrVin)
	///   - requestImage: VehicleImageRequest with image definition
	/// - Returns: Optional image data
	public func cachedVehicleImage(vin: String, requestImage: VehicleImageRequest) -> Data? {
		return ImageCacheService.item(with: vin, requestImage: requestImage)
	}
	
	/// Delete all cached images
	public func deleteAllImages() {
		ImageCacheService.deleteAll(method: .async)
	}
	
	/// Request a single image for a vehicle. If their exist any cached data for the request you get this data immediately
	///
	/// - Parameters:
	///   - finOrVin: The fin or vin of the car
	///   - requestImage: VehicleImageRequest with image definition
	///   - forceUpdate: If it's true the image is always updated. Recommendation: The default value is false. Set this value to true only in exceptional cases.
	///   - completion: Closure with enum-based ImageResult
    public func fetchVehicleImage(
        finOrVin: String,
        requestImage: VehicleImageRequest,
        forceUpdate: Bool = false,
        completion: @escaping ImageResult) {

        CarKit.tokenProvider.requestToken { token in

            let requestDict = self.getDict(requestImage: requestImage)
            let router      = BffImageRouter.image(accessToken: token.accessToken,
												   vin: finOrVin,
												   requestModel: requestDict)

            let cachedImage = self.cachedVehicleImage(vin: finOrVin, requestImage: requestImage)

            if let image = cachedImage {
                completion(.success(image))
            }

            guard forceUpdate == true || cachedImage == nil else {
                return
            }
            
            NetworkLayer.requestDecodable(router: router) { [weak self] (result: ImageAPIResult) in
                
                switch result {
                case .failure(let error):
                    LOG.E(error.localizedDescription)
                    
                    completion(.failure(ErrorHandler.handle(error: error)))
                    
                case .success(let apiVehicleImagesModel):
                    LOG.D(apiVehicleImagesModel)
                    
                    let images = NetworkModelMapper.map(apiVehicleImagesModel: apiVehicleImagesModel)
                    
                    guard let urlString = images.first?.url,
                        let url = URL(string: urlString) else {
                            completion(.failure(MBError(description: "Invalid Image URL", type: .unknown)))
                            return
                    }

                    self?.fetch(url: url,
                                finOrVin: finOrVin,
                                requestImage: requestImage,
                                completion: completion)
                }
            }
        }
    }
	
	/// Request all images for user assigned vehicles
	///
	/// - Parameters:
	///   - requestImage: VehicleImageRequest with image definition
	///   - completion: Closure with enum-based ImageResult
	public func fetchVehicleImages(requestImage: VehicleImageRequest, completion: @escaping ImagesCompletion) {

        CarKit.tokenProvider.requestToken { token in

            let requestDict = self.getDict(requestImage: requestImage)
            let router      = BffImageRouter.images(accessToken: token.accessToken,
													requestModel: requestDict)
            
            NetworkLayer.requestDecodable(router: router) { [weak self] (result: ImagesAPIResult) in

                switch result {
                case .failure(let error):
                    LOG.E(error.localizedDescription)

                    completion(.failure(ErrorHandler.handle(error: error)))

                case .success(let apiVehicleVinImages):
                    LOG.D(apiVehicleVinImages)

                    let images = NetworkModelMapper.map(apiVehicleVinImagesModel: apiVehicleVinImages)
                    self?.fetch(images: images,
                                requestImage: requestImage,
                                completion: completion)
                }
            }
        }
	}

    
    // MARK: - Helper
    
	private func fetch(images: [VehicleImageModel], requestImage: VehicleImageRequest, completion: @escaping ImagesCompletion) {
		
		let dispatchGroup = DispatchGroup()
		
		for item in images {
			
			guard let urlString = images.first?.images.first?.url,
				let url = URL(string: urlString) else {
					continue
			}
			
			dispatchGroup.enter()
			self.fetch(url: url, finOrVin: item.vin, requestImage: requestImage) { _ in
				dispatchGroup.leave()
			}
		}
		
		dispatchGroup.notify(queue: .main) {
            completion(.success(images))
		}
	}
	
	private func fetch(url: URL, finOrVin: String, etag: String, shouldBeCached: Bool = true, completion: @escaping ImageResult) {
		
		NetworkLayer.requestData(url: url) { (result) in
			
			switch result {
			case .failure(let error):
				completion(.failure(ErrorHandler.handle(error: error)))
				
			case .success(let data):
				completion(.success(data))
			}
		}
	}
	
	private func fetch(url: URL, finOrVin: String, requestImage: VehicleImageRequest, completion: @escaping ImageResult) {
		
		NetworkLayer.requestData(url: url) { (result) in
			
			switch result {
			case .failure(let error):
				completion(.failure(ErrorHandler.handle(error: error)))
				
			case .success(let data):
				completion(.success(data))
				
				if requestImage.shouldBeCached {
					ImageCacheService.save(finOrVin: finOrVin, requestImage: requestImage, imageData: data, completion: {})
				}
			}
		}
	}
	
	private func getDict(requestImage: VehicleImageRequest) -> [String: Any]? {
		
		let imageKeys   = "BE" + requestImage.degrees.parameter + "-" + requestImage.size.parameter + requestImage.cropOption.parameter
		let imageModel  = VehicleImageRequestModel(background: requestImage.background.parameter,
												   centered: requestImage.centered,
												   fallbackImage: requestImage.fallbackImage,
												   imageKeys: imageKeys,
												   night: requestImage.night,
												   roofOpen: requestImage.roofOpen)
		let json        = try? imageModel.toJson()
		return json as? [String: Any]
	}
}

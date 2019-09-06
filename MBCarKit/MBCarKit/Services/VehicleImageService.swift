//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBNetworkKit

/// Service to call all vehicle image related requests
public class VehicleImageService {
	
	// MARK: Typealias
	
	/// Completion for fetching one image
	///
	/// Returns an enum with image data in succeeded case and a error string in failure case
	public typealias ImageResult = (ValueResult<Data, String>) -> Void
	
	/// Completion for fetching images
	///
	/// Returns array of VehicleImageModel
	public typealias ImagesResult = ([VehicleImageModel]) -> Void

	internal typealias ImageAPIResult = NetworkResult<[APIVehicleImageModel]>
	internal typealias ImageHelperResult = (ValueResult<[ImageModel], String>) -> Void
	internal typealias ImagesAPIResult = NetworkResult<[APIVehicleVinImageModel]>
	internal typealias ImagesHelperResult = (ValueResult<[VehicleImageModel], String>) -> Void

	
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
	
	/// Checks the cache for top image data
	///
	/// - Parameters:
	///   - vin: vehicle identifier (use finOrVin)
	/// - Returns: Optional TopImageCacheModel with included image data
	public func cachedVehicleTopImage(vin: String) -> TopImageCacheModel? {
		return TopImageCacheService.item(with: vin)
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
	///   - onError: Error closure with error message string
    public func fetchVehicleImage(
        finOrVin: String,
        requestImage: VehicleImageRequest,
        forceUpdate: Bool = false,
        completion: @escaping ImageResult,
        onError: @escaping MBCarKit.ErrorDescription) {

        MBCarKit.tokenProvider.requestToken { token in

            let requestDict = self.getDict(requestImage: requestImage)
            let endpoint    = BffEndpointRouter.image(accessToken: token.accessToken,
                                                      vin: finOrVin,
                                                      requestModel: requestDict)

            let cachedImage = self.cachedVehicleImage(vin: finOrVin, requestImage: requestImage)

            if let image = cachedImage {
                completion(ValueResult.success(image))
            }

            guard forceUpdate == true || cachedImage == nil else {
                return
            }

            self.image(router: endpoint) { [weak self] (result) in

                switch result {
                case .failure(let responseError):
                    LOG.E(responseError)

                    let errorString = self?.handle(responseError: responseError) ?? ""
                    onError(errorString)

                case .success(let images):
                    guard let urlString = images.first?.url,
                        let url = URL(string: urlString) else {
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
	///   - onError: Error closure with error message string
	public func fetchVehicleImages(requestImage: VehicleImageRequest, completion: @escaping ImagesResult, onError: @escaping MBCarKit.ErrorDescription) {

        MBCarKit.tokenProvider.requestToken { token in

            let requestDict = self.getDict(requestImage: requestImage)
            let endpoint    = BffEndpointRouter.images(accessToken: token.accessToken,
                                                       requestModel: requestDict)

            self.images(router: endpoint) { [weak self] (result) in

                switch result {
                case .failure(let responseError):
                    LOG.E(responseError)

                    let errorString = self?.handle(responseError: responseError) ?? ""
                    onError(errorString)

                case .success(let images):
                    self?.fetch(images: images,
                                requestImage: requestImage,
                                completion: completion)
                }
            }
        }
	}
	
	/// Request a single top image for a vehicle. If their exist any cached data for the request you get this data immediately
	///
	/// - Parameters:
	///   - finOrVin: The fin or vin of the car
	///   - forceUpdate: If it's true the image is always updated. Recommendation: The default value is false. Set this value to true only in exceptional cases.
	///   - completion: Closure with enum-based ImageResult
	public func fetchVehicleTopImage(finOrVin: String, forceUpdate: Bool = true, shouldBeCached: Bool = true, completion: @escaping ImageResult) {
		
		guard let vehicle: VehicleModel = DatabaseVehicleService.item(with: finOrVin),
			let url = CdnEndpoint.getUrl(for: vehicle.baumuster) else {
				return
			}
		
		let topImageCacheModel = self.cachedVehicleTopImage(vin: finOrVin)

		if let imageData = topImageCacheModel?.imageData {
			completion(ValueResult.success(imageData))
		}

		guard forceUpdate == true || topImageCacheModel == nil else {
			return
		}
		
		let etag: String = topImageCacheModel?.etag ?? ""
		self.head(url: url, etag: etag) { [weak self] (etag) in
			self?.fetch(url: url,
						finOrVin: finOrVin,
						etag: etag,
						shouldBeCached: shouldBeCached,
						completion: completion)
		}
	}
	
	
	// MARK: - Helper
	
	private func fetch(images: [VehicleImageModel], requestImage: VehicleImageRequest, completion: @escaping ImagesResult) {
		
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
			completion(images)
		}
	}
	
	private func fetch(url: URL, finOrVin: String, etag: String, shouldBeCached: Bool, completion: @escaping ImageResult) {
		
		NetworkLayer.requestData(url: url) { (result) in
			
			switch result {
			case .failure(let error):
				completion(ValueResult.failure(self.handle(error: error)))
				
			case .success(let data):
				completion(ValueResult.success(data))
				
				if shouldBeCached {
					TopImageCacheService.save(finOrVin: finOrVin,
											  etag: etag,
											  imageData: data,
											  completion: {})
				}
			}
		}
	}
	
	private func fetch(url: URL, finOrVin: String, requestImage: VehicleImageRequest, completion: @escaping ImageResult) {
		
		NetworkLayer.requestData(url: url) { (result) in
			
			switch result {
			case .failure(let error):
				completion(ValueResult.failure(self.handle(error: error)))
				
			case .success(let data):
				completion(ValueResult.success(data))
				
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
	
	private func handle(error: Error) -> ResponseError<String> {
		
		let handleError   = NetworkLayer.handle(error: error, type: APIErrorDescriptionModel.self)
		let responseError = NetworkLayer.responseError(networkError: handleError.responseError?.networkError, model: handleError.errorModel?.description)
		return responseError
	}
	
	private func handle(responseError: ResponseError<String>) -> String {
		return responseError.requestError ?? responseError.localizedDescription ?? ""
	}
	
	private func head(url: URL, etag: String, completion: @escaping (String) -> Void) {
		
		NetworkLayer.requestHead(url: url) { (result) in
			
			switch result {
			case .failure(let error):
				LOG.E(error)
				
			case .success(let response):
				guard let newEtag = response.allHeaderFields["Etag"] as? String,
					newEtag != etag else {
						return
				}
				
				completion(newEtag)
			}
		}
	}
	
	private func image(router: BffEndpointRouter, completion: @escaping ImageHelperResult) {
		
		NetworkLayer.requestDecodable(router: router) { (result: ImageAPIResult) in
			
			switch result {
			case .failure(let error):
				LOG.E(error.localizedDescription)
				completion(ValueResult.failure(self.handle(error: error)))
				
			case .success(let apiVehicleImagesModel):
				LOG.D(apiVehicleImagesModel)
				
				let images = NetworkModelMapper.map(apiVehicleImagesModel: apiVehicleImagesModel)
				completion(ValueResult.success(images))
			}
		}
	}
	
	private func images(router: BffEndpointRouter, completion: @escaping ImagesHelperResult) {
		
		NetworkLayer.requestDecodable(router: router) { (result: ImagesAPIResult) in
			
			switch result {
			case .failure(let error):
				LOG.E(error.localizedDescription)
				completion(ValueResult.failure(self.handle(error: error)))
				
			case .success(let apiVehicleVinImages):
				LOG.D(apiVehicleVinImages)
				
				let images = NetworkModelMapper.map(apiVehicleVinImagesModel: apiVehicleVinImages)
				completion(ValueResult.success(images))
			}
		}
	}
}

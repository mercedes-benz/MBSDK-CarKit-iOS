//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit
import ZIPFoundation
import MBNetworkKit

/// Service to fetch topView image components
public class TopViewService {
    
    /// Completion for fetching the topview images
    ///
    /// Returns the TopImageModel containing all the images for the topview
    public typealias TopViewImageResult = (Result<TopViewComponentModel, MBError>) -> Void
    
    private let topViewUnarchiver = TopViewUnarchiver()
    
    /// Checks the cache for top image data
    ///
    /// - Parameters:
    ///   - vin: vehicle identifier (use finOrVin)
    /// - Returns: Optional TopImageCacheModel with included image data
    public func cachedVehicleTopImage(vin: String) -> TopViewComponentModel? {
        guard let model = TopImageCacheService.item(with: vin) else {
            return nil
        }
        return buildCompontentModel(from: model)
    }
    
    /// Request a single top image for a vehicle. If their exist any cached data for the request you get this data immediately
    ///
    /// - Parameters:
    ///   - finOrVin: The fin or vin of the car
    ///   - onLoading: Closure that is called when a fetch is initiated. Closure param true indicates that the images are loaded from cache; on false the images are loaded from back-end systems
    ///   - onCompletion: Closure with enum-based TopViewImageResult
    public func fetchVehicleTopImage(finOrVin: String, onLoading: ((Bool) -> Void)? = nil, onCompletion: @escaping TopViewImageResult) {
        
        let cachedTopViewImage = self.cachedVehicleTopImage(vin: finOrVin)
        
        if let imageModel = cachedTopViewImage {
            onLoading?(true)
            onCompletion(.success(imageModel))
        } else {
            onLoading?(false)
            CarKit.tokenProvider.requestToken { token in
                let router = BffImageRouter.topViewImage(accessToken: token.accessToken, vin: finOrVin)
                self.topViewImage(router: router, vin: finOrVin, completion: onCompletion)
            }
        }
    }
    
    /// Delete all cached images
    public func deleteAllImages() {
        TopImageCacheService.deleteAll(method: .async)
    }
    
    private func topViewImage(router: EndpointRouter, vin: String, completion: @escaping TopViewImageResult) {
        
        guard let request = router.urlRequest else {
            return
        }
        
        NetworkLayer.download(urlRequest: request).response { [weak self] response in
            guard let destinationURL = response.destinationURL else {
                return
            }
            
            self?.unarchiveTopView(downloadDestination: destinationURL, vin: vin, completion: completion)
        }
    }
    
    private func buildCompontentModel(from model: TopImageModel) -> TopViewComponentModel {
        
        let comps = model.components
            .compactMap { comp -> (key: String, img: UIImage)? in
                guard let imgData = comp.imageData,
                    let img = UIImage(data: imgData),
                    let keyName = componentKeyName(forFileName: comp.name) else {
                    return nil
                }
                
                return (keyName, img)
                
            }.reduce(into: [String: UIImage]()) { result, imgTuple in
                result[imgTuple.key] = imgTuple.img
            }
        
        return TopViewComponentModel(vin: model.vin, components: comps)
    }
    
    private func componentKeyName(forFileName name: String) -> String? {
        guard let key = name.split(separator: ".").first else {
            return nil
        }
        return String(key)
    }
    
    private func unarchiveTopView(downloadDestination destinationURL: URL, vin: String, completion: @escaping TopViewImageResult) {
        
        topViewUnarchiver.unarchive(fileUrl: destinationURL) { result in
            switch result {
                
            case .success(let componentModels):
                let apiModel = APIVehicleTopViewImageModel(vin: vin, components: componentModels)
                
                let topViewModel = NetworkModelMapper.map(apiVehicleTopViewImageModel: apiModel)
                TopImageCacheService.save(topImageModel: topViewModel) {
                    completion(.success(self.buildCompontentModel(from: topViewModel)))
                }
                
            case .failure(let error):
                completion(.failure(ErrorHandler.handle(error: error)))
            }
        }
    }
}

//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of vehicle image request
public struct VehicleImageRequest {
	
	public let background: VehicleImageBackground
	public let centered: Bool
	public let cropOption: VehicleImageCropOption
	public let degrees: VehicleImageDegrees
	@available(*, deprecated, message: "The property is deprecated.")
	public let doorsOpen: Bool
	public let fallbackImage: Bool
	public let night: Bool
	public let roofOpen: Bool
	public let shouldBeCached: Bool
	public let size: VehicleImageType
	
	
	// MARK: - Public
	
	@available(*, deprecated, message: "Please create your own extension for this.")
	public static func standard() -> VehicleImageRequest {
		return VehicleImageRequest(background: .transparent,
								   centered: true,
								   degrees: .d320,
								   fallbackImage: false,
								   night: false,
								   roofOpen: false,
								   shouldBeCached: true,
								   size: .png(size: .size1920x1080))
	}
	
	
	// MARK: - Init
	
	public init(
		background: VehicleImageBackground,
		centered: Bool,
		cropOption: VehicleImageCropOption = .none,
		degrees: VehicleImageDegrees,
		fallbackImage: Bool = false,
		night: Bool,
		roofOpen: Bool,
		shouldBeCached: Bool,
		size: VehicleImageType) {
		
		self.background     = background
		self.centered       = centered
		self.cropOption     = cropOption
		self.degrees        = degrees
		self.doorsOpen      = false
		self.fallbackImage  = fallbackImage
		self.night          = night
		self.roofOpen       = roofOpen
		self.shouldBeCached = shouldBeCached
		self.size           = size
	}
	
	@available(*, deprecated, message: "Use init(background:centered:cropOption:degrees:fallbackImage:night:roofOpen:shouldBeCached:size:) instead. The property doorsOpen is deprecated.")
	public init(
		background: VehicleImageBackground,
		centered: Bool,
		cropOption: VehicleImageCropOption = .none,
		degrees: VehicleImageDegrees,
		doorsOpen: Bool,
		fallbackImage: Bool = false,
		night: Bool,
		roofOpen: Bool,
		shouldBeCached: Bool,
		size: VehicleImageType) {
		
		self.background     = background
		self.centered       = centered
		self.cropOption     = cropOption
		self.degrees        = degrees
		self.doorsOpen      = doorsOpen
		self.fallbackImage  = fallbackImage
		self.night          = night
		self.roofOpen       = roofOpen
		self.shouldBeCached = shouldBeCached
		self.size           = size
	}
}

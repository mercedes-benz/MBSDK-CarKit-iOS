//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of head unit related attributes
public struct VehicleHuModel {
	
	public let isTrackingEnable: StatusAttributeType<ActiveState, NoUnit>
	public let language: StatusAttributeType<LanguageState, NoUnit>
	public let temperatureType: StatusAttributeType<TemperatureType, NoUnit>
	public let timeFormatType: StatusAttributeType<TimeFormatType, NoUnit>
	public let weeklySetHU: StatusAttributeType<[DayTimeModel], NoUnit>
}

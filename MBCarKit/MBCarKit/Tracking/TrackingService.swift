//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBCommonKit

/// Protocol for all myCar related tracking calls
public protocol MyCarTrackingService: TrackingService {
    
    func doorLock(fin: String, state: CommandStateType, condition: CommandConditionType)
    func doorUnlock(fin: String, state: CommandStateType, condition: CommandConditionType)
    func startAuxHeat(fin: String, state: CommandStateType, condition: CommandConditionType)
    func stopAuxHeat(fin: String, state: CommandStateType, condition: CommandConditionType)
    func configureAuxHeat(fin: String, state: CommandStateType, condition: CommandConditionType)
    func engineStart(fin: String, state: CommandStateType, condition: CommandConditionType)
    func engineStop(fin: String, state: CommandStateType, condition: CommandConditionType)
    func openSunroof(fin: String, state: CommandStateType, condition: CommandConditionType)
    func closeSunroof(fin: String, state: CommandStateType, condition: CommandConditionType)
    func liftSunroof(fin: String, state: CommandStateType, condition: CommandConditionType)
    func openWindow(fin: String, state: CommandStateType, condition: CommandConditionType)
    func closeWindow(fin: String, state: CommandStateType, condition: CommandConditionType)
    func sendToCar(fin: String, routeType: HuCapability, state: CommandStateType, condition: CommandConditionType)
    func locateMe(fin: String, state: CommandStateType, condition: CommandConditionType)
    func locateVehicle(fin: String, state: CommandStateType, condition: CommandConditionType)
    func theftAlarmConfirmDamageDetection(fin: String, state: CommandStateType, condition: CommandConditionType)
    func theftAlarmDeselectDamageDetection(fin: String, state: CommandStateType, condition: CommandConditionType)
    func theftAlarmDeselectInterior(fin: String, state: CommandStateType, condition: CommandConditionType)
    func theftAlarmDeselectTow(fin: String, state: CommandStateType, condition: CommandConditionType)
    func theftAlarmSelectDamageDetection(fin: String, state: CommandStateType, condition: CommandConditionType)
    func theftAlarmSelectInterior(fin: String, state: CommandStateType, condition: CommandConditionType)
    func theftAlarmSelectTow(fin: String, state: CommandStateType, condition: CommandConditionType)
    func theftAlarmStart(fin: String, state: CommandStateType, condition: CommandConditionType)
    func theftAlarmStop(fin: String, state: CommandStateType, condition: CommandConditionType)
}

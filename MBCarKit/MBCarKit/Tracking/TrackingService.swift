//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBCommonKit

/// Protocol for all myCar related tracking calls
public protocol MyCarTrackingService: TrackingService {
    
    func doorLock(fin: String, state: CommandState, condition: String)
    func doorUnlock(fin: String, state: CommandState, condition: String)
    func startAuxHeat(fin: String, state: CommandState, condition: String)
    func stopAuxHeat(fin: String, state: CommandState, condition: String)
    func configureAuxHeat(fin: String, state: CommandState, condition: String)
    func engineStart(fin: String, state: CommandState, condition: String)
    func engineStop(fin: String, state: CommandState, condition: String)
    func openSunroof(fin: String, state: CommandState, condition: String)
    func closeSunroof(fin: String, state: CommandState, condition: String)
    func liftSunroof(fin: String, state: CommandState, condition: String)
    func openWindow(fin: String, state: CommandState, condition: String)
    func closeWindow(fin: String, state: CommandState, condition: String)
    func sendToCar(fin: String, routeType: HuCapability, state: CommandState, condition: String)
    func sendToCarBluetooth(fin: String, routeType: SendToCarCapability, state: CommandState, condition: String)
    func locateMe(fin: String, state: CommandState, condition: String)
    func locateVehicle(fin: String, state: CommandState, condition: String)
    func theftAlarmConfirmDamageDetection(fin: String, state: CommandState, condition: String)
    func theftAlarmDeselectDamageDetection(fin: String, state: CommandState, condition: String)
    func theftAlarmDeselectInterior(fin: String, state: CommandState, condition: String)
    func theftAlarmDeselectTow(fin: String, state: CommandState, condition: String)
    func theftAlarmSelectDamageDetection(fin: String, state: CommandState, condition: String)
    func theftAlarmSelectInterior(fin: String, state: CommandState, condition: String)
    func theftAlarmSelectTow(fin: String, state: CommandState, condition: String)
    func theftAlarmStart(fin: String, state: CommandState, condition: String)
    func theftAlarmStop(fin: String, state: CommandState, condition: String)
}

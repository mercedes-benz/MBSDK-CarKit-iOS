//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

/// Representation of a charge program
public struct VehicleChargeProgramModel {
    
    public let autoUnlock: Bool
    public let chargeProgram: ChargingProgram
    public let clockTimer: Bool
    public let ecoCharging: Bool
    public let locationBasedCharging: Bool
    public let maxChargingCurrent: Int
    public let maxSoc: Int
    public let weeklyProfile: Bool
}

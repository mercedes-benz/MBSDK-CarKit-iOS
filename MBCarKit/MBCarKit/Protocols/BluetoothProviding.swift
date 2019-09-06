//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

public protocol BluetoothProviding {
    
    typealias BluetoothSendCompletion = (Bool) -> Void
    
    var isConnected: Bool { get }
    func connectIfNeeded()
    func send<T>(poi: T, allowedCache: Bool, onComplete: @escaping BluetoothSendCompletion)
}

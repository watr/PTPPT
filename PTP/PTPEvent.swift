
import Foundation

enum PTPEventCode: PTPCode {
    case undefined                     = 0x4000
    case cancelTransaction             = 0x4001
    case objectAdded                   = 0x4002
    case objectRemoved                 = 0x4003
    case storeAdded                    = 0x4004
    case storeRemoved                  = 0x4005
    case devicePropChanged             = 0x4006
    case objectInfoChanged             = 0x4007
    case deviceInfoChanged             = 0x4008
    case requestObjectTransfer         = 0x4009
    case storeFull                     = 0x400A
    case deviceReset                   = 0x400B
    case storageInfoChanged            = 0x400C
    case captureComplete               = 0x400D
    case unreportedStatus              = 0x400E
    
    case appleDeviceUnlocked           = 0xC001
    case appleUserAssignedNameChanged  = 0xC002
}

struct PTPEvent {
    let container: PTPContainer
    
    init?(data: Data) {
        guard let container = PTPContainer(type: PTPContainerType.event.rawValue, data: data) else {
            return nil
        }
        self.container = container
    }
}

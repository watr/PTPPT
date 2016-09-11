
import Foundation

enum PTPOperationCode : PTPCode {
    case undefined                   = 0x1000
    case getDeviceInfo               = 0x1001
    case openSession                 = 0x1002
    case closeSession                = 0x1003
    case getStorageIDs               = 0x1004
    case getStorageInfo              = 0x1005
    case getNumObjects               = 0x1006
    case getObjectHandles            = 0x1007
    case getObjectInfo               = 0x1008
    case getObject                   = 0x1009
    case getThumb                    = 0x100A
    case deleteObject                = 0x100B
    case sendObjectInfo              = 0x100C
    case sendObject                  = 0x100D
    case initiateCapture             = 0x100E
    case formatStore                 = 0x100F
    case resetDevice                 = 0x1010
    case selfTest                    = 0x1011
    case setObjectProtection         = 0x1012
    case powerDown                   = 0x1013
    case getDevicePropDesc           = 0x1014
    case getDevicePropValue          = 0x1015
    case setDevicePropValue          = 0x1016
    case resetDevicePropValue        = 0x1017
    case terminateOpenCapture        = 0x1018
    case moveObject                  = 0x1019
    case copyObject                  = 0x101A
    case getPartialObject            = 0x101B
    case initiateOpenCapture         = 0x101C
    
    case getNumDownloadableObjects   = 0x9001
    case getAllObjectInfo            = 0x9002
    case getUserAssignedDeviceName   = 0x9003
}

struct PTPOperation {
    let container: PTPContainer
    
    init(code: PTPCode, parameters: [PTPParameter]) {
        self.container = PTPContainer(code: code, parameters: parameters)
    }
    
    var code: PTPOperationCode? {
        get {
            return PTPOperationCode(rawValue: self.container.code)
        }
    }
    
    var commandBuffer: Data {
        let length = ((MemoryLayout<PTPContainerDataLength>.size + MemoryLayout<PTPContainerTypeRawValue>.size + MemoryLayout<PTPCode>.size + MemoryLayout<PTPTransactionID>.size) + (MemoryLayout<PTPParameter>.size * Int(self.container.numberOfParameters)))
        var bytes = [UInt8](repeating: 0, count: length)
        
        bytes.withUnsafeMutableBufferPointer { (buffer) in
            let rawPointer = UnsafeMutableRawPointer(buffer.baseAddress!)
            var byteOffset: Int = 0
            
            rawPointer.storeBytes(of: PTPContainerDataLength(length), toByteOffset: byteOffset, as: PTPContainerDataLength.self)
            byteOffset += MemoryLayout<PTPContainerDataLength>.size
            
            rawPointer.storeBytes(of: PTPContainerTypeRawValue(PTPContainerType.command.rawValue), toByteOffset: byteOffset, as: PTPContainerTypeRawValue.self)
            byteOffset += MemoryLayout<PTPContainerTypeRawValue>.size

            rawPointer.storeBytes(of: self.container.code, toByteOffset: byteOffset, as: PTPCode.self)
            byteOffset += MemoryLayout<PTPCode>.size
            
            rawPointer.storeBytes(of: PTPTransactionID(self.container.transactionID), toByteOffset: byteOffset, as: PTPTransactionID.self)
            byteOffset += MemoryLayout<PTPTransactionID>.size
            
            for parameter in self.container.parameters {
                rawPointer.storeBytes(of: PTPParameter(parameter), toByteOffset: byteOffset, as: PTPParameter.self)
                byteOffset += MemoryLayout<PTPParameter>.size
            }
        }
        return Data(bytes: bytes)
    }
}

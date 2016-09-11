
import Foundation

typealias PTPContainerDataLength   = UInt32
typealias PTPContainerTypeRawValue = UInt16
typealias PTPTransactionID         = UInt32

typealias PTPCode                  = UInt16
typealias PTPParameter             = UInt32
typealias PTPNumberOfParameters    = UInt16

typealias PTPStringCharacterCount  = UInt8
typealias PTPStringCharacter       = UniChar

typealias PTPArrayElementsCount    = UInt32

enum PTPContainerType: PTPContainerTypeRawValue {
    case undefined = 0
    case command   = 1
    case data      = 2
    case response  = 3
    case event     = 4
}

struct PTPContainer {
    let type: PTPContainerTypeRawValue
    let code: PTPCode
    let transactionID: PTPTransactionID
    let parameters: [PTPParameter]
    
    var numberOfParameters: PTPNumberOfParameters {
        return PTPNumberOfParameters(self.parameters.count)
    }
    
    init(type: PTPContainerTypeRawValue = PTPContainerType.undefined.rawValue, code: PTPCode, transactionID: PTPTransactionID = 0, parameters: [PTPParameter]) {
        self.type = type
        self.code = code
        self.transactionID = transactionID
        self.parameters = parameters
    }
        
    init?(type specify: PTPContainerTypeRawValue? = nil, data: Data) {
        var offset: Int = 0
        var capacity: Int = 0
        
        capacity = MemoryLayout<PTPContainerDataLength>.size
        let containerCapacity: PTPContainerDataLength = data.subdata(in: offset..<(offset + capacity)).withUnsafeBytes({$0.pointee})
        offset += capacity
        
        capacity = MemoryLayout<PTPContainerTypeRawValue>.size
        self.type = data.subdata(in: offset..<(offset + capacity)).withUnsafeBytes({$0.pointee})
        offset += capacity
        
        if let specified = specify {
            if specified != specify {
                return nil
            }
        }
        
        capacity = MemoryLayout<PTPCode>.size
        self.code = data.subdata(in: offset..<(offset + capacity)).withUnsafeBytes({$0.pointee})
        offset += capacity

        capacity = MemoryLayout<PTPTransactionID>.size
        self.transactionID = data.subdata(in: offset..<(offset + capacity)).withUnsafeBytes({$0.pointee})
        offset += capacity
        
        let numberOfParameters = (Int(containerCapacity) - offset) / MemoryLayout<PTPParameter>.size
        var parameters: [PTPParameter] = []
        
        for _ in 0..<numberOfParameters {
            capacity = MemoryLayout<PTPParameter>.size
            let parameter: PTPParameter = data.subdata(in: offset..<(offset + capacity)).withUnsafeBytes({$0.pointee})
            offset += capacity
            parameters.append(parameter)
        }
        self.parameters = parameters
    }
}

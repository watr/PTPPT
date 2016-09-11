
import Foundation

public typealias PTPContainerDataLength   = UInt32
public typealias PTPContainerTypeRawValue = UInt16
public typealias PTPTransactionID         = UInt32

public typealias PTPCode                  = UInt16
public typealias PTPParameter             = UInt32
public typealias PTPNumberOfParameters    = UInt16

public typealias PTPStringCharacterCount  = UInt8
public typealias PTPStringCharacter       = UniChar

public typealias PTPArrayElementsCount    = UInt32

public enum PTPContainerType: PTPContainerTypeRawValue {
    case undefined = 0
    case command   = 1
    case data      = 2
    case response  = 3
    case event     = 4
}

public struct PTPContainer {
    public let type: PTPContainerTypeRawValue
    public let code: PTPCode
    public let transactionID: PTPTransactionID
    public let parameters: [PTPParameter]
    
    public var numberOfParameters: PTPNumberOfParameters {
        return PTPNumberOfParameters(self.parameters.count)
    }
    
    public init(type: PTPContainerTypeRawValue = PTPContainerType.undefined.rawValue, code: PTPCode, transactionID: PTPTransactionID = 0, parameters: [PTPParameter]) {
        self.type = type
        self.code = code
        self.transactionID = transactionID
        self.parameters = parameters
    }
        
    public init?(type specify: PTPContainerTypeRawValue? = nil, data: Data) {
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

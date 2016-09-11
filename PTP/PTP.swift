
import Foundation

typealias PTPContainerDataLength  = UInt32
typealias PTPContainerType_       = UInt16
typealias PTPTransactionID        = UInt32

typealias PTPCode                 = UInt16
typealias PTPParameter            = UInt32
typealias PTPNumberOfParameters   = UInt16

typealias PTPStringCharacterCount = UInt8
typealias PTPStringCharacter      = UniChar

typealias PTPArrayElementsCount   = UInt32

enum PTPContainerType: PTPContainerType_ {
    case undefined = 0
    case command   = 1
    case data      = 2
    case response  = 3
    case event     = 4
}

struct PTPContainer {
    let code: PTPCode
    let transactionID: PTPTransactionID
    let parameters: [PTPParameter]
    
    var numberOfParameters: PTPNumberOfParameters {
        return PTPNumberOfParameters(self.parameters.count)
    }
    
    init(code: PTPCode,transactionID: PTPTransactionID = 0, parameters: [PTPParameter]) {
        self.code = code
        self.transactionID = transactionID
        self.parameters = parameters
    }
    
    init?(type specify: PTPContainerType, data: Data) {
        let dataLength = data.count
        let minLength = (MemoryLayout<PTPContainerDataLength>.size + MemoryLayout<PTPTransactionID>.size + MemoryLayout<PTPCode>.size + MemoryLayout<PTPNumberOfParameters>.size)
        
        guard dataLength >= minLength else {
            return nil
        }
        
        var transactionID: PTPTransactionID? = nil
        var code: PTPCode? = nil
        var parameters: [PTPParameter] = []
        
        do {
            try data.withUnsafeBytes {(bytes: UnsafePointer<UInt8>) -> Void in
                enum ResponseError: Error {
                    case invalidDataLength
                    case invalidContainerType
                    case other
                }
                var offset = 0
                
                let length: Int = {
                    let capacity = MemoryLayout<PTPContainerDataLength>.size
                    let value = bytes.advanced(by: offset).withMemoryRebound(to: PTPContainerDataLength.self, capacity: capacity, { Int($0.pointee)
                    })
                    offset += capacity
                    return value
                }()
                
                guard length >= minLength else {
                    throw ResponseError.invalidDataLength
                }
                
                let type: PTPContainerType? = {
                    let capacity = MemoryLayout<PTPContainerType_>.size
                    let value = bytes.advanced(by: offset).withMemoryRebound(to: PTPContainerType_.self, capacity: capacity, { PTPContainerType(rawValue: $0.pointee)
                    })
                    offset += capacity
                    return value
                }()
                
                guard type == specify else {
                    throw ResponseError.invalidContainerType
                }
                
                code = {
                    let capacity = MemoryLayout<PTPCode>.size
                    let value = bytes.advanced(by: offset).withMemoryRebound(to: PTPCode.self, capacity: capacity, { ($0.pointee)
                    })
                    offset += capacity
                    return value
                }()
                
                transactionID = {
                    let capacity = MemoryLayout<PTPTransactionID>.size
                    let value = bytes.advanced(by: offset).withMemoryRebound(to: PTPTransactionID.self, capacity: capacity, { ($0.pointee)
                    })
                    offset += capacity
                    return value
                }()
                
                let numberOfParameters = (length - minLength) / MemoryLayout<PTPParameter>.size
                for _ in 0..<numberOfParameters {
                    let parameter: PTPParameter = {
                        let capacity = MemoryLayout<PTPParameter>.size
                        let value = bytes.advanced(by: offset).withMemoryRebound(to: PTPParameter.self, capacity: capacity, { ($0.pointee) })
                        offset += capacity
                        return value
                    }()
                    parameters.append(parameter)
                }
            }
            
            guard let transactionID = transactionID, let code = code else {
                return nil
            }
            
            self.transactionID = transactionID
            self.code = code
            self.parameters = parameters
        }
        catch {
            return nil
        }
    }
}

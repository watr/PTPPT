
import Foundation

public protocol PTPDataSet {
    init?(data: Data)
}

public struct GetDeviceInfoDataSet: PTPDataSet, CustomStringConvertible {
    public typealias StandardVersion = UInt16
    public let standardVersion: StandardVersion
    
    public typealias VendorExtensionID = UInt32
    public let vendorExtensionID: VendorExtensionID
    
    public typealias VendorExtensionVersion = UInt16
    public let vendorExtensionVersion: VendorExtensionVersion
    
    public typealias VendorExtensionDesc = String
    public let vendorExtensionDesc: VendorExtensionDesc
    
    public typealias FunctionalMode = UInt16
    public let functionalMode: FunctionalMode
    
    public typealias OperationsSupported = [UInt16]
    public let operationsSupported: OperationsSupported
    
    public typealias EventsSupported = [UInt16]
    public let eventsSupported: EventsSupported
    
    public typealias DevicePropertiesSupported = [UInt16]
    public let devicePropertiesSupported: DevicePropertiesSupported
    
    public typealias CaptureFormats = [UInt16]
    public let captureFormats: CaptureFormats
 
    public typealias ImageFormats = [UInt16]
    public let imageFormats: ImageFormats
    
    public typealias Manufacturer = String
    public let manufacturer: Manufacturer
    
    public typealias Model = String
    public let model: Model
    
    public typealias DeviceVersion = String
    public let deviceVersion: DeviceVersion

    public typealias SerialNumber = String
    public let serialNumber: SerialNumber

    public init?(data: Data) {
        var offset: Int = 0
        var capacity: Int = 0
        
        capacity = MemoryLayout<StandardVersion>.size
        self.standardVersion = data.subdata(in: offset..<(offset + capacity)).withUnsafeBytes({$0.pointee})
        offset += capacity
        
        capacity = MemoryLayout<VendorExtensionID>.size
        self.vendorExtensionID = data.subdata(in: offset..<(offset + capacity)).withUnsafeBytes({$0.pointee})
        offset += capacity
     
        capacity = MemoryLayout<VendorExtensionVersion>.size
        self.vendorExtensionVersion = data.subdata(in: offset..<(offset + capacity)).withUnsafeBytes({$0.pointee})
        offset += capacity

        capacity = data.ptpStringCapacity(from: offset)
        self.vendorExtensionDesc = data.subdata(in: offset..<(offset + capacity)).ptpString()
        offset += capacity
        
        capacity = MemoryLayout<FunctionalMode>.size
        self.functionalMode = data.subdata(in: offset..<(offset + capacity)).withUnsafeBytes({$0.pointee})
        offset += capacity
        
        capacity = data.ptpArrayCapacity(from: offset, each: MemoryLayout<UInt16>.size)
        self.operationsSupported = data.subdata(in: offset..<(offset + capacity)).ptpArray()
        offset += capacity
        
        capacity = data.ptpArrayCapacity(from: offset, each: MemoryLayout<UInt16>.size)
        self.eventsSupported = data.subdata(in: offset..<(offset + capacity)).ptpArray()
        offset += capacity
        
        capacity = data.ptpArrayCapacity(from: offset, each: MemoryLayout<UInt16>.size)
        self.devicePropertiesSupported = data.subdata(in: offset..<(offset + capacity)).ptpArray()
        offset += capacity

        capacity = data.ptpArrayCapacity(from: offset, each: MemoryLayout<UInt16>.size)
        self.captureFormats = data.subdata(in: offset..<(offset + capacity)).ptpArray()
        offset += capacity
        
        capacity = data.ptpArrayCapacity(from: offset, each: MemoryLayout<UInt16>.size)
        self.imageFormats = data.subdata(in: offset..<(offset + capacity)).ptpArray()
        offset += capacity
        
        capacity = data.ptpStringCapacity(from: offset)
        self.manufacturer = data.subdata(in: offset..<(offset + capacity)).ptpString()
        offset += capacity
        
        capacity = data.ptpStringCapacity(from: offset)
        self.model = data.subdata(in: offset..<(offset + capacity)).ptpString()
        offset += capacity
        
        capacity = data.ptpStringCapacity(from: offset)
        self.deviceVersion = data.subdata(in: offset..<(offset + capacity)).ptpString()
        offset += capacity

        capacity = data.ptpStringCapacity(from: offset)
        self.serialNumber = data.subdata(in: offset..<(offset + capacity)).ptpString()
        offset += capacity
    }
    
    public var description: String {
        let descriptions: [String] = [
            "data set \"get deice info\"",
            "           standard version: \(self.standardVersion)",
            "        vendor extension id: \(self.vendorExtensionID)",
            "   vendor extension version: \(self.vendorExtensionVersion)",
            "      vendor extension desc: \(self.vendorExtensionDesc)",
            "            functional mode: \(self.functionalMode)",
            "       operations supported: \(self.operationsSupported.map({String(format: "0x%x", $0)}).joined(separator: ", "))",
            "           events supported: \(self.eventsSupported.map({String(format: "0x%x", $0)}).joined(separator: ", "))",
            "device properties supported: \(self.devicePropertiesSupported.map({String(format: "0x%x", $0)}).joined(separator: ", "))",
            "            capture formats: \(self.captureFormats.map({String(format: "0x%x", $0)}).joined(separator: ", "))",
            "              image formats: \(self.imageFormats.map({String(format: "0x%x", $0)}).joined(separator: ", "))",
            "               manufacturer: \(self.manufacturer)",
            "                      model: \(self.model)",
            "             device version: \(self.deviceVersion)",
            "              serial number: \(self.serialNumber)",
            
        ]
        return descriptions.joined(separator: "\n")
    }
}

public struct GetStorageIDsDataSet: PTPDataSet, CustomStringConvertible {
    public let storageIDs: [UInt32]
    
    public init?(data: Data) {
        var offset: Int = 0
        var capacity: Int = 0
        
        capacity = data.ptpArrayCapacity(from: offset, each: MemoryLayout<UInt32>.size)
        self.storageIDs = data.ptpArray()
        offset += capacity
    }
    
    public var description: String {
        let descriptions: [String] = [
            "data set \"get storage IDs\"",
            "storage IDs: \(self.storageIDs.map({String(format: "0x%x", $0)}).joined(separator: ", "))",
        ]
        return descriptions.joined(separator: "\n")
    }
}


import Foundation

protocol PTPDataSet {
    init?(data: Data)
}

extension Data {
    func ptpStringCapacity(from offset: Int) -> Int {
        let countCapacity = MemoryLayout<PTPStringCharacterCount>.size
        let count: PTPStringCharacterCount = self.subdata(in: offset..<(offset + countCapacity)).withUnsafeBytes({$0.pointee})
        let capacity: Int = MemoryLayout<PTPStringCharacterCount>.size + (Int(count) * MemoryLayout<PTPStringCharacter>.size)
        return capacity
    }
    
    func ptpString(from offset: Int = 0) -> String {
        let data = self.subdata(in: offset..<(offset + self.ptpStringCapacity(from: offset)))
        let count: PTPStringCharacterCount = data.withUnsafeBytes({$0.pointee})
        let characterCapacity = MemoryLayout<PTPStringCharacter>.size
        
        let countCapacity = MemoryLayout<PTPStringCharacterCount>.size
        
        var characters: [Character] = []
        for i in 0..<Int(count) {
            let begin = (countCapacity + i * characterCapacity)
            let end = begin + characterCapacity
            let characterData = data.subdata(in: begin..<end)
            let character: PTPStringCharacter = characterData.withUnsafeBytes({$0.pointee})
            characters.append(Character(UnicodeScalar(character)!))
        }
        return String(characters)
    }
    
    func ptpArrayCapacity(from offset: Int = 0, each elementCapacity: Int ) -> Int {
        let count: PTPArrayElementsCount = self.subdata(in: offset..<(offset + MemoryLayout<PTPArrayElementsCount>.size)).withUnsafeBytes({$0.pointee})
        return MemoryLayout<PTPArrayElementsCount>.size + (Int(count) * elementCapacity)
    }
    
    func ptpArray<T>(from offset: Int = 0) -> [T] {
        let countCapacity = MemoryLayout<PTPArrayElementsCount>.size
        let count: PTPArrayElementsCount = self.subdata(in: offset..<(offset + countCapacity)).withUnsafeBytes({$0.pointee})
        let elementCapacity = MemoryLayout<T>.size
        let capacity = countCapacity + (Int(count) * elementCapacity)
        
        let data = self.subdata(in: offset..<(offset + capacity))
        
        var elements: [T] = []
        for i in 0..<Int(count) {
            let offset = offset + countCapacity + (i * elementCapacity)
            let value: T = data.subdata(in: offset..<(offset + elementCapacity)).withUnsafeBytes({$0.pointee})
            elements.append(value)
        }
        return elements
    }
}

struct GetDeviceInfoDataSet: PTPDataSet, CustomStringConvertible {
    typealias StandardVersion = UInt16
    let standardVersion: StandardVersion
    
    typealias VendorExtensionID = UInt32
    let vendorExtensionID: VendorExtensionID
    
    typealias VendorExtensionVersion = UInt16
    let vendorExtensionVersion: VendorExtensionVersion
    
    typealias VendorExtensionDesc = String
    let vendorExtensionDesc: VendorExtensionDesc
    
    typealias FunctionalMode = UInt16
    let functionalMode: FunctionalMode
    
    typealias OperationsSupported = [UInt16]
    let operationsSupported: OperationsSupported
    
    typealias EventsSupported = [UInt16]
    let eventsSupported: EventsSupported
    
    typealias DevicePropertiesSupported = [UInt16]
    let devicePropertiesSupported: DevicePropertiesSupported
    
    typealias CaptureFormats = [UInt16]
    let captureFormats: CaptureFormats
 
    typealias ImageFormats = [UInt16]
    let imageFormats: ImageFormats
    
    typealias Manufacturer = String
    let manufacturer: Manufacturer
    
    typealias Model = String
    let model: Model
    
    typealias DeviceVersion = String
    let deviceVersion: DeviceVersion

    typealias SerialNumber = String
    let serialNumber: SerialNumber

    init?(data: Data) {
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
    
    var description: String {
        let descriptions: [String] = [
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
        return descriptions.reduce("", {return ($0 + "\n" + $1)})
    }
}

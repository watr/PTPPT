
import Foundation
import ImageCaptureCore

public extension ICCameraDevice {
    var canAcceptPTPCommands: Bool {
        get {
            return self.capabilities.contains(ICCameraDeviceCanAcceptPTPCommands)
        }
    }
}

public extension Data {
    public func ptpStringCapacity(from offset: Int) -> Int {
        let countCapacity = MemoryLayout<PTPStringCharacterCount>.size
        let count: PTPStringCharacterCount = self.subdata(in: offset..<(offset + countCapacity)).withUnsafeBytes({$0.pointee})
        let capacity: Int = MemoryLayout<PTPStringCharacterCount>.size + (Int(count) * MemoryLayout<PTPStringCharacter>.size)
        return capacity
    }
    
    public func ptpString(from offset: Int = 0) -> String {
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
    
    public func ptpArrayCapacity(from offset: Int = 0, each elementCapacity: Int ) -> Int {
        let count: PTPArrayElementsCount = self.subdata(in: offset..<(offset + MemoryLayout<PTPArrayElementsCount>.size)).withUnsafeBytes({$0.pointee})
        return MemoryLayout<PTPArrayElementsCount>.size + (Int(count) * elementCapacity)
    }
    
    public func ptpArray<T>(from offset: Int = 0) -> [T] {
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

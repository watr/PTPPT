
import Foundation
import ImageCaptureCore

public class PTPOperationRequest: NSObject {
    public typealias PTPOperationCompletionHandler = (_ operation:PTPOperation, _ inData: Data, _ resopnse: PTPOperationResponse, _ error: Error) -> Void
    
    public let operation: PTPOperation
    public let outData: Data
    public var completionHandler: PTPOperationCompletionHandler?
    
    public init(operation: PTPOperation, outData: Data, completionHandler: PTPOperationCompletionHandler?) {
        self.operation = operation
        self.outData = outData
        self.completionHandler = completionHandler
    }
    
    public func send(to camera: ICCameraDevice) {
        camera.requestSendPTPCommand(self.operation.commandBuffer, outData: self.outData, sendCommandDelegate: self, didSendCommand: #selector(didSendPTPCommand(command:inData:response:error:contextInfo:)), contextInfo: nil)
    }
    
    // private callback function
    // you should never directly invoke this method
    @objc internal func didSendPTPCommand(command: NSData, inData: NSData, response: NSData, error: NSError, contextInfo: UnsafeMutableRawPointer?) {
        if let completionHandler = self.completionHandler {
            completionHandler(self.operation, Data(referencing: inData), PTPOperationResponse(data: Data(referencing: response))!, error)
        }
    }
}

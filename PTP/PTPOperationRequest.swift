
import Foundation
import ImageCaptureCore

class PTPOperationRequest: NSObject {
    typealias PTPOperationCompletionHandler = (_ operation:PTPOperation, _ inData: Data, _ resopnse: PTPOperationResponse, _ error: Error) -> Void
    
    let operation: PTPOperation
    let outData: Data
    let completionHandler: PTPOperationCompletionHandler?
    
    init(operation: PTPOperation, outData: Data, completionHandler: PTPOperationCompletionHandler?) {
        self.operation = operation
        self.outData = outData
        self.completionHandler = completionHandler
    }
    
    func send(to camera: ICCameraDevice) {
        camera.requestSendPTPCommand(self.operation.commandBuffer, outData: self.outData, sendCommandDelegate: self, didSendCommand: #selector(didSendPTPCommand(command:inData:response:error:contextInfo:)), contextInfo: nil)
    }
    
    // private callback function
    // you should never directly invoke this method
    func didSendPTPCommand(command: NSData, inData: NSData, response: NSData, error: NSError, contextInfo: UnsafeMutableRawPointer?) {
        if let completionHandler = self.completionHandler {
            completionHandler(self.operation, Data(referencing: inData), PTPOperationResponse(data: Data(referencing: response))!, error)
        }
    }
}

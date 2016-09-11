
import Cocoa
import ImageCaptureCore
import PTPPT

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, ICDeviceBrowserDelegate, ICCameraDeviceDelegate {
    var cameraBrowser: ICDeviceBrowser?
    var requests: [PTPOperationRequest] = []

    //MARK: NSApplicationDelegate
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.cameraBrowser = ICDeviceBrowser()
        
        guard let cameraBrowser = self.cameraBrowser else {
            return
        }

        cameraBrowser.delegate = self
        cameraBrowser.browsedDeviceTypeMask = ICDeviceTypeMask(rawValue: ICDeviceTypeMask.camera.rawValue | ICDeviceLocationTypeMask.local.rawValue)!
        cameraBrowser.start()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    //MARK: ICDeviceBrowserDelegate
    
    func deviceBrowser(_ browser: ICDeviceBrowser, didAdd device: ICDevice, moreComing: Bool) {
        print("did **add**    device \(device.name ?? ""), more coming \(moreComing)")
        device.delegate = self
        device.requestOpenSession()
    }
    
    func deviceBrowser(_ browser: ICDeviceBrowser, didRemove device: ICDevice, moreGoing: Bool) {
        print("did **remove** device \(device.name ?? ""), more going \(moreGoing)")
    }
    
    // MARK: ICCDeviceDelegate
    
    func didRemove(_ device: ICDevice) {
        print("did **remove** device \(device.name ?? "")")
    }
    
    func device(_ device: ICDevice, didOpenSessionWithError error: Error?) {
        print("did **open**  session device \(device.name ?? ""), error \(error)")
    }
    
    func deviceDidBecomeReady(_ device: ICDevice) {
        print("device did become ready")
        
        if let cameraDevice = device as? ICCameraDevice{
            print("can accept ptp commands?: \(cameraDevice.canAcceptPTPCommands)")
            let operation = PTPOperation(code: PTPOperationCode.getDeviceInfo.rawValue, parameters: [])
            let request = PTPOperationRequest(operation: operation, outData: Data(), completionHandler: { (_, inData, response, error) in
                if response.container.code == PTPResponseCode.ok.rawValue {
                    print(GetDeviceInfoDataSet(data: inData)!)
                }
            })
            self.requests.append(request)
            request.send(to: cameraDevice)
        }
    }
    
    func device(_ device: ICDevice, didCloseSessionWithError error: Error?) {
        print("did close session device \(device.name ?? ""), error")
    }
    
    func deviceDidChangeName(_ device: ICDevice) {
        print("did change name device \(device.name ?? "")")
    }
    
    func deviceDidChangeSharingState(_ device: ICDevice) {
        print("did change sharing state \(device.name ?? "")")
    }
    
    func device(_ device: ICDevice, didReceiveStatusInformation status: [String : Any]) {
        print("did receive status information \(status) device \(device.name ?? "")")
    }
    
    func device(_ device: ICDevice, didEncounterError error: Error?) {
        print("did encounter error \(device.name ?? ""), error")
    }
    
    func device(_ device: ICDevice, didReceiveButtonPress buttonType: String) {
        print("did receive button press \(buttonType) device \(device.name ?? "")")
    }
    
    func device(_ device: ICDevice, didReceiveCustomNotification notification: [String : Any], data: Data) {
        print("did receive custom notification \(notification) data \(data) device \(device.name ?? "")")
    }
    //MARK: ICCamereDeviceDelegate
    
    func cameraDevice(_ camera: ICCameraDevice, didReceivePTPEvent eventData: Data) {
        if let event = PTPEvent(data: eventData) {
            print("did receive PTP event \(event)")
        }
    }
}


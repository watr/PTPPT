
import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    //MARK: NSApplicationDelegate
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }    
}


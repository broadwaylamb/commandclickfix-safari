import Cocoa
import SafariServices.SFSafariApplication
import SafariServices.SFSafariExtensionManager

let appName = "Command-Click Fix"
let extensionBundleIdentifier = "com.jaskiewiczs.CmdClickFix.Extension"

final class ViewController: NSViewController {

    @IBOutlet var appNameLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appNameLabel.stringValue = "Determining if the extension is installed..."
        SFSafariExtensionManager
            .getStateOfSafariExtension(withIdentifier: extensionBundleIdentifier)
                { state, error in
                    guard let state = state, error == nil else {
                        self.errorAlert(error!)
                        return
                    }

                    DispatchQueue.main.async {
                        self.appNameLabel.stringValue = state.isEnabled
                            ? "\(appName) extension is currently on."
                            : """
                              \(appName) extension is currently off.
                              You can turn it on in Safari Extensions preferences.
                              """
                    }
                }
    }
    
    @IBAction func openSafariExtensionPreferences(_ sender: AnyObject?) {
        SFSafariApplication
            .showPreferencesForExtension(withIdentifier: extensionBundleIdentifier)
                { error in
                    guard error == nil else {
                        self.errorAlert(error!)
                        return
                    }
                    DispatchQueue.main.async {
                        NSApplication.shared.terminate(nil)
                    }
                }
    }

    private func errorAlert(_ error: Error) {
        DispatchQueue.main.async {
            let alert = NSAlert(error: error)
            alert.runModal()
            NSApplication.shared.terminate(nil)
        }
    }
}

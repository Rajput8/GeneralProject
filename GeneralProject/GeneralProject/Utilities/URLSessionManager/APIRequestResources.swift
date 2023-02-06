import UIKit

class APIRequestResources {

    public static func hasApiKey() -> Bool { return getApiKey() != nil }

    public static func getApiKey() -> String? { return UserDefaults.standard.string(forKey: APIConstants.kApiKey) }

    public static func appleDeviceId() -> String {
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? "NO_APPLE_DEVICE_IDENTIFIER"
        return deviceId
    }

    public static func basicAuth(userName: String, password: String) -> String {
        let credentialString = "\(userName):\(password)"
        guard let credentialData = credentialString.data(using: String.Encoding.utf8) else { return "" }
        let base64Credentials = credentialData.base64EncodedString(options: [])
        return base64Credentials
    }

    public static func requestURL(request: URLRequest) -> String {
        return request.url?.absoluteString ?? "null_url".localized()
    }

    public static func remoteErrorAlert(_ title: String, _ msg: String) {
        SwiftSpinner.hide()
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "dismiss".localized(),
                                                style: UIAlertAction.Style.default,
                                                handler: nil))
        DispatchQueue.main.async {
            if let keyWindow = UIWindow.key {
                if let currentVC = keyWindow.topViewController() {
                    currentVC.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}

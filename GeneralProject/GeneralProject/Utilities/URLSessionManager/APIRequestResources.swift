import UIKit

class APIRequestResources {

    static let shared = APIRequestResources()

    func appleDeviceId() -> String {
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? "NO_APPLE_DEVICE_IDENTIFIER"
        return deviceId
    }

    func basicAuth(_ userName: String, _ password: String) -> String {
        let credentialString = "\(userName):\(password)"
        guard let credentialData = credentialString.data(using: String.Encoding.utf8) else { return "" }
        let base64Credentials = credentialData.base64EncodedString(options: [])
        return base64Credentials
    }

    func requestURL(request: URLRequest) -> String {
        return request.url?.absoluteString ?? "null_url".localized()
    }

    func remoteErrorAlert(_ title: String, _ msg: String) {
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

    func parseError(_ error: Error) -> String {
        guard let decodingError = error as? DecodingError else { return "data_not_parseable_to_string".localized() }
        let err = "\(decodingError)"
        let errDesc = String(format: "parse_error_message".localized(), arguments: [err])
        return errDesc
    }
}

import Foundation

// API Constants
struct APIConstants {
    typealias Handler<T: Decodable> = (Result<T, APIFailureTypes>) -> Void
    static var bearerToken = ""
    static var apiKey = ""
    static var deviceTokenId = "123"
    static var deviceType = DeviceType.iOS.rawValue
    static var deviceUUID: String?
    static var authUsername = ""
    static var authPassword = ""
    static var authorizationBearerToken = ""
    static var headers = [String: String]()
    static var observation: NSKeyValueObservation? // manage upload and download packet on remote server
    static var allTasks = [URLSessionDataTask]()
    static var remoteRequestSession: URLSession {
        let config = URLSessionConfiguration.default
        let session = URLSession.init(configuration: config)
        return session
    }
}

// Error Constant
struct ErrorConstant {
    static var UnexpectedError = "unexpected_error".localized()
}

enum DeviceType: Int {
    case iOS = 1
    case android = 2
}

struct APIResourcesForTesting {
    static var upload = "https://dbt.teb.mybluehostin.me/oemage/public/api/update-profile-pic"
    static var employee = "http://dummy.restapiexample.com/api/v1/employees"
    static var login = "http://3.90.125.105/oemage/public/api/login"
    static var bearerToken = ""
}

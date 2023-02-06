import Foundation

// API Constants
class APIConstants {
    static var apiKeyID = "C2329-U5922-APIKEY-20220728-3JvqMN3MrRmm"
    static var apiKeySecret = "pdBuHpsOzZ5H2GJyjJuS2jHN3FXxpl2jyeHZs9VyqqSEyWQ9aOJZbICZxEgAQnTc"
    static var deviceTokenId = ""
    static var deviceType = "1"
    static var deviceUUId: String?
    static var kApiKey = "com.wodhopper.ApiKey"
    static var kLastApiKeyFailure = "com.wodhopper.lastApiKeyAttempt"
    static var authUsername = "techwins"
    static var authPassword = "techwins_labs"
    static var sessionkey = ""
    static var userid = ""
    static var headers = [String: String]()
    static var authorizationBearerToken = ""
    static var observation: NSKeyValueObservation? // manage upload and download packet on remote server
    static var allTasks = [URLSessionDataTask]()
    static var statusCode = (200...209)
    static var encoder = JSONEncoder()
    static var currentAPIEndpoint: APIEndpoints?
    static var remoteRequestSession: URLSession {
        let config = URLSessionConfiguration.default
        let session = URLSession.init(configuration: config)
        return session
    }
}

// Error Constant
class ErrorConstant {
    static var UnexpectedError = "unexpected_error".localized()
}

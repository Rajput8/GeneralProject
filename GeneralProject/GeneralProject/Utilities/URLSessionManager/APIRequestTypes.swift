import Foundation

enum APIRequestEnvironmentType {
    case local
    case qaTesting
    case beta
    case replica
    case prod
}

enum APIRequestMethodType: String {
    case post = "POST"
    case get = "GET"
    case patch = "PATCH"
    case delete = "DELETE"
    case put = "PUT"
}

enum APIRequestContentType {
    case json
    case data
    case form
    case multipartFormData

    public func value(boundary: String? = nil) -> String {
        switch self {
        case .json, .data: return "application/json"
        case .form: return "application/x-www-form-urlencoded"
        case .multipartFormData:
            guard let boundary = boundary else { return "multipart/form-data" }
            return "multipart/form-data; boundary=\(boundary)"
        }
    }
}

enum APIRequestAuthorizationType {
    case basicAuth
    case bearerToken
    case apiKey
    case noAuth

    static func value(type: APIRequestAuthorizationType) -> String? {
        switch type {
        case .bearerToken:
            return "Bearer \(APIConstants.bearerToken)"
        case .basicAuth:
            let basicAuth = APIRequestResources.shared.basicAuth(APIConstants.authUsername, APIConstants.authPassword)
            return "Basic \(basicAuth)"
        case .apiKey:
            return APIConstants.apiKey
        default: break
        }
        return nil
    }
}

import Foundation

enum APIFailureTypes: Error {
    case manuallyOffline
    case connectivity
    case httpError
    case authentication
    case serverError
    case encoding
    case parsingError
    case invalidRequest
    case invalidResponse
    case invalidURL
    case nullData
    case invalidData
    case unknown
    case errorMessageWithError(_ error: Error?, _ errorDesc: String?)
    case errorMessage(_ errorDesc: String?)
}

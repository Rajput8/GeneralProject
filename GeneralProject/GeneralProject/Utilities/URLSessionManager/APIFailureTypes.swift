import Foundation

enum APIFailureTypes: Error {
    case manuallyOffline
    case connectivity
    case httpError
    case authentication
    case noGymId
    case invalidRequest
    case invalidResponse
    case serverError
    case nullData
    case encoding
    case unknown
    case parsingError
}

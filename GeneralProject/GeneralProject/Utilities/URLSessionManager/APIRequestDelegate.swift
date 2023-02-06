import Foundation

protocol APIRequestDelegate: AnyObject {
    func apiRequestFailure(_ errMsg: String, _ failureType: APIFailureTypes)
    func apiRequestSuccess<T: Decodable>(type: T)
}

protocol APIResponse: Codable {
    var responseFull: String? { get set }
    var success: Bool { get set }
    var reloginRequired: Bool? { get set }
    var errorMessage: String? { get set }
    var endpoint: APIEndpoints { get set }
}

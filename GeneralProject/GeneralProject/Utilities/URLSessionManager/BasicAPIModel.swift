import UIKit

class BasicAPIModel: APIResponse {

    var responseFull: String?
    var success: Bool
    var reloginRequired: Bool?
    var errorMessage: String?
    var message: String?
    var endpoint: APIEndpoints = .unspecified
    var error: String?
    var failureType: APIFailureTypes?
    var requestAt: String?
    var requestID: String?

    enum CodingKeys: String, CodingKey {
        case success
        case error
        case errorMessage
        case message
        case requestAt
        case requestID = "requestId"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if container.allKeys.contains(.success) {
            do {
                success = try container.decode(Bool.self, forKey: .success)
            } catch {
                let successString = try container.decode(String.self, forKey: .success)
                success = successString.lowercased() == "true" || successString.lowercased() == "yes" || successString == "1"
            }
        } else { success = true }

        error = try container.decodeIfPresent(String.self, forKey: .error)
        errorMessage = try container.decodeIfPresent(String.self, forKey: .errorMessage)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        requestAt = try container.decodeIfPresent(String.self, forKey: .requestAt)
        requestID = try container.decodeIfPresent(String.self, forKey: .requestID)

        if errorMessage == nil {
            if error != nil {
                errorMessage = error
            } else if message != nil {
                errorMessage = message
            }
        }
        reloginRequired = error == "not_logged_in"
    }

    // this handles the special case of the login response, which contains no info information we use,
    // except a cookie if successful
    init(success: Bool, endpoint: APIEndpoints) {
        self.success = success
        self.reloginRequired = !success
        self.endpoint = endpoint
        self.responseFull = ""
        self.error = ""
    }

    init(_ success: Bool, _ failureType: APIFailureTypes?) {
        self.success = success
        self.reloginRequired = !success
        self.responseFull = ""
        self.error = ""
        self.failureType = failureType
    }

    public func hasAuthenticationError() -> Bool { return "not_logged_in" == error }
}

import Foundation

struct AuthorizationRequestModel: Codable {
    var email: String?
    var password: String?
    var socialUserId: String?
    var deviceType: Int?
    var deviceToken: String?

    enum CodingKeys: String, CodingKey {
        case email, password, socialUserId
        case deviceType = "device_type"
        case deviceToken = "device_token"
    }
}

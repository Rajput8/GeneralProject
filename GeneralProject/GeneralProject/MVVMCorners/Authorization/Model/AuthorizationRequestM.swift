import Foundation

struct AuthorizationRequestModel: Codable {
    var email: String?
    var password: String?
    var socialUserId: String?

    init(email: String? = nil, password: String? = nil, socialUserId: String? = nil) {
        self.email = email
        self.password = password
        self.socialUserId = socialUserId
    }
}

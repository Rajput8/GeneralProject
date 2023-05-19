import Foundation

enum APIEndpoints: String, Codable, CaseIterable {
    case login
    case updateProfilePic
    case unspecified

    public func urlComponent() -> String {
        switch self {
        case .login: return "login"
        case .updateProfilePic: return "update-profile-pic"
        case .unspecified: return ""
        }
    }

    public func logDescription() -> String {
        switch self {
        case .login: return "login account"
        case .updateProfilePic: return "update profile pic"
        case .unspecified: return ""
        }
    }
}

import Foundation

enum APIEndpoints: String, Codable, CaseIterable {
    case login
    case unspecified

    public func urlComponent() -> String {
        switch self {
        case .login: return "login"
        case .unspecified: return ""
        }
    }

    public func logDescription() -> String {
        switch self {
        case .login: return "login account"
        case .unspecified: return ""
        }
    }
}

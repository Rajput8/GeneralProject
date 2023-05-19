import Foundation

enum SocketEndpoints: String, Codable, CaseIterable {
    case host
    case connectUser
    case joinedUsersList
    case sendMessage
    case receiveMessage
    case exitUser
    case onTyping
    case unspecified

    func urlComponent() -> String {
        switch self {
        case .host: return "http://3.90.125.105:8000"
        case .connectUser: return "joinRoom"
        case .joinedUsersList: return "chatroomUsers"
        case .sendMessage: return "sendMessage"
        case .receiveMessage: return "receiveMessage"
        case .exitUser: return "leaveRoom"
        case .onTyping: return "onTyping"
        case .unspecified: return ""
        }
    }
}

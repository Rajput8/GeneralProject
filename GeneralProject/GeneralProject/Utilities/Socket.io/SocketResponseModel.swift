import Foundation

struct User: Codable {
    var id: String?
    var isConnected: Bool?
    var nickname: String?
}

struct JoinedUsersList: Codable {
    var data: [User]?
}

struct Message: Codable {
    var userId: Int?
    var recieverId: Int?
    var threadId: Int?
    var messageType: Int?
    var messageText: String?
    var repliedToMessageId: Int?

    enum CodingKeys: String, CodingKey {
        case userId
        case recieverId = "reciever_id"
        case threadId = "thread_id"
        case messageType = "message_type"
        case messageText = "message_text"
        case repliedToMessageId = "replied_to_message_id"
    }
}

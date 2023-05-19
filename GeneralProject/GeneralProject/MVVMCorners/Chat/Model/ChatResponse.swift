import Foundation

// MARK: - ChatResponse
struct ChatResponse: Codable {
    let statusCode: Int?
    let message: String?
    let data: [ChatData]?
}

// MARK: - ChatData
struct ChatData: Codable {
    let id, senderID, recieverID: Int?
    let message: String?
    let messageType: Int?
    let createdAt, updatedAt, userName, profilePic: String?
    let messageTime: String?
    let threadID: Int?
    let messageText, audioMessage, audioDuration, imageMessage: String?
    let videoMessage: String?
    let repliedToMessageID, isRead: Int?
    let userID: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case senderID = "sender_id"
        case recieverID = "reciever_id"
        case message
        case messageType = "message_type"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userName = "user_name"
        case profilePic = "profile_pic"
        case messageTime = "message_time"
        case threadID = "thread_id"
        case messageText = "message_text"
        case audioMessage = "audio_message"
        case audioDuration = "audio_duration"
        case imageMessage = "image_message"
        case videoMessage = "video_message"
        case repliedToMessageID = "replied_to_message_id"
        case isRead = "is_read"
        case userID = "user_id"
    }
}

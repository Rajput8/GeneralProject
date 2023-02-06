import Foundation

enum PostType {
    case json
    case form
    case multipartFormData
    case data

    public func contentTypeHeader(boundary: String? = nil) -> String {
        switch self {
        case .json: return "application/json"
        case .form: return "application/x-www-form-urlencoded"
        case .multipartFormData:
            guard let boundary = boundary else { return "multipart/form-data" }
            return "multipart/form-data; boundary=\(boundary)"
        case .data: return "application/json"
        }
    }
}

enum HTTPMethodType: String {
    case post = "POST"
    case get = "GET"
    case patch = "PATCH"
    case delete = "DELETE"
    case put = "PUT"
}

enum UploadTaskKey: String {
    case profilePic = "profile_pic"
    case groupImage = "group_image"
}

enum UploadTaskContent: String {
    case imageJPEG = "image/jpeg"
    case imagePNG = "image/png"
    case videoMP4 = "video/mp4"
    case videoMOV = "video/quicktime"
}

import Foundation

struct APIRequestParams {
    var endpoint: APIEndpoints
    var methodType: APIRequestMethodType
    var contentType: APIRequestContentType?
    var requestModelData: Data?
    var params: [String: Any]?
    let mediaContent: [MultipartMediaRequestParams]?

    init(_ endpoint: APIEndpoints,
         _ methodType: APIRequestMethodType,
         _ contentType: APIRequestContentType? = nil,
         _ requestModelData: Data? = nil,
         _ params: [String: Any]? = nil,
         _ mediaContent: [MultipartMediaRequestParams]? = nil) {

        self.endpoint = endpoint
        self.methodType = methodType
        self.contentType = contentType
        self.requestModelData = requestModelData
        self.params = params
        self.mediaContent = mediaContent
    }
}

struct MultipartMediaRequestParams {
    var filename: String
    var data: Data
    var keyname: MediaFileKeyname
    var contentType: MediaContentType

    enum MediaContentType: String {
        case imageJPEG = "image/jpeg"
        case imagePNG = "image/png"
        case videoMP4 = "video/mp4"
        case videoMOV = "video/quicktime"
    }

    enum MediaFileKeyname: String {
        case media = "profile_pic"
    }
}


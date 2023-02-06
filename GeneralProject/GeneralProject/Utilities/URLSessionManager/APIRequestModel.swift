import Foundation

struct UploadFile {
    var contentType: UploadTaskContent?
    var contentName: String?
    var contentData: Data?

    enum CodingKeys: String, CodingKey {
        case contentType, originalNameOfContent, dataFormatOfContent
    }

    init(contentType: UploadTaskContent? = nil, contentName: String? = nil, contentData: Data? = nil) {
        self.contentType = contentType
        self.contentName = contentName
        self.contentData = contentData
    }
}

struct APIRequestParams {
    var endpoint: APIEndpoints
    var delegate: APIRequestDelegate
    var mediaType: PostType?
    var methodType: HTTPMethodType? = .post
    var requestModelData: Data?
    var postBody: [String: Any]?
    var queryParams: [String: Any]?
    var uploadTaskKey: UploadTaskKey?
    let mediaContent: [UploadFile]?
    var assetNum: String?
    var sensorId: String?

    init(_ endpoint: APIEndpoints,
         _ delegate: APIRequestDelegate,
         _ mediaType: PostType?,
         _ methodType: HTTPMethodType?,
         _ requestModelData: Data? = nil,
         _ postBody: [String: Any]? = nil,
         _ queryParams: [String: Any]? = nil,
         _ uploadTaskKey: UploadTaskKey? = nil,
         _ mediaContent: [UploadFile]? = nil,
         _ assetNum: String? = nil,
         _ sensorId: String? = nil) {

        self.endpoint = endpoint
        self.delegate = delegate
        self.mediaType = mediaType
        self.methodType = methodType
        self.requestModelData = requestModelData
        self.postBody = postBody
        self.queryParams = queryParams
        self.uploadTaskKey = uploadTaskKey
        self.mediaContent = mediaContent
        self.assetNum = assetNum
        self.sensorId = sensorId
    }
}

struct URLSessionTaskResponse {
    var request: URLRequest
    var data: Data?
    var response: URLResponse?
    var err: Error?

    init(_ request: URLRequest, _ data: Data?, _ response: URLResponse?, _ err: Error?) {
        self.request = request
        self.data = data
        self.response = response
        self.err = err
    }
}

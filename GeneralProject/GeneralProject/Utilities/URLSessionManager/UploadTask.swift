import Foundation

class SessionUploadTask {

    public static func uploadTask<T: Decodable>(type: T.Type, remoteRequestParams: APIRequestParams) {

        let session = APIConstants.remoteRequestSession
        let boundary = UUID().uuidString
        guard let request = SessionURLRequest.urlRequest(remoteRequestParams, nil, boundary) else {
            SwiftSpinner.hide()
            remoteRequestParams.delegate.apiRequestFailure("unexpected_error".localized(), .invalidRequest)
            return
        }

        LogHandler.requestLog(request)
        let strURL = APIRequestResources.requestURL(request: request)
        let data = uploadTaskParams(request, boundary, remoteRequestParams)

        // Send a POST request to the URL, with the data we created earlier
        let task = session.uploadTask(with: request, from: data, completionHandler: { data, response, err in
            LogHandler.responseLog(strURL, data, response, err)
            let taskResponse = URLSessionTaskResponse.init(request, data, response, err)
            SessionTaskResponseHandler.taskResponseHandler(remoteRequestParams, taskResponse, T.self)
        })
        APIConstants.observation = task.progress.observe(\.fractionCompleted) { progress, _ in
            debugPrint("progress: ", progress.fractionCompleted) }
        task.resume()
    }

    private static func uploadTaskParams( _ request: URLRequest?,
                                          _ boundary: String,
                                          _ remoteRequestParams: APIRequestParams) -> Data? {
        var data = Data()
        let keyName = remoteRequestParams.uploadTaskKey ?? .profilePic
        if let params = remoteRequestParams.postBody {
            print("params", remoteRequestParams.postBody ?? "")
            for(key, value) in params {
                // Add the reqtype field and its value to the raw http request data
                data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                data.append("\(value)".data(using: .utf8)!)
            }
        }

        if let content = remoteRequestParams.mediaContent, content.count > 0 {
            for contentInfo in content {
                if let contentData = contentInfo.contentData {
                    data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                    data.append("Content-Disposition: form-data; name=\"\(keyName.rawValue)\"; filename=\"\(contentInfo.contentName ?? "")\"\r\n".data(using: .utf8)!)
                    data.append("Content-Type: \r\n\r\n".data(using: .utf8)!)
                    data.append(contentData)
                }
            }
        }

        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        return data
    }
}

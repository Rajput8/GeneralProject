import Foundation

final class SessionUploadTask {

    static func uploadTask<T: Decodable>(type: T.Type,
                                         _ requestParams: APIRequestParams,
                                         _ completion: @escaping APIConstants.Handler<T>) {

        let session = APIConstants.remoteRequestSession
        let boundary = UUID().uuidString

        guard let request = SessionURLRequest.urlRequest(requestParams, boundary) else {
            LoaderUtil.shared.hideLoading()
            completion(.failure(.invalidRequest)) // "unexpected_error".localized()
            return
        }

        if !requestParams.isHideLoadingIndicator { LoaderUtil.shared.showLoading() }
        LogHandler.shared.requestLog(request)
        Monitor().startMonitoring { [ ] connection, reachable in
            let reachableStatus = Monitor.getCurrentConnectivityStatus(connection, reachable)
            if reachableStatus == .yes {
                let data = uploadTaskParams(boundary, requestParams)
                // Send a POST request to the URL, with the data we created earlier
                let task = session.uploadTask(with: request, from: data, completionHandler: { data, response, err in
                    LogHandler.shared.responseLog(data, response, err)
                    APIResponse.responseHandler(data, response, err, completion)
                    LoaderUtil.shared.hideLoading()
                })
                APIConstants.observation = task.progress.observe(\.fractionCompleted) { progress, _ in
                    LogHandler.shared.reportLogOnConsole(nil, "progress: \(progress.fractionCompleted)")
                }
                task.resume()
            } else {
                LoaderUtil.shared.hideLoading()
                APIRequestResources.shared.remoteErrorAlert("no_internet_connection".localized(),
                                                            "device_connected_with_internet_warning".localized())
            }
        }
    }

    private static func uploadTaskParams(_ boundary: String, _ requestParams: APIRequestParams) -> Data? {
        var data = Data()
        if let params = requestParams.params {
            LogHandler.shared.reportLogOnConsole(nil, "params is: \(requestParams.params ?? [:])")
            for(key, value) in params {
                // Add the reqtype field and its value to the raw http request data
                data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                data.append("\(value)".data(using: .utf8)!)
            }
        }

        if let medias = requestParams.mediaContent, medias.count > 0 {
            for media in medias {
                let keyname = media.keyname.rawValue
                let filename = media.filename
                let contentType = media.contentType.rawValue
                data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                data.append("Content-Disposition: form-data; name=\"\(keyname)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
                // data.append("Content-Type: \r\n\r\n".data(using: .utf8)!)
                data.append("Content-Type: \(contentType)\r\n\r\n".data(using: .utf8)!)
                data.append(media.data)
            }
        }

        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        return data
    }
}

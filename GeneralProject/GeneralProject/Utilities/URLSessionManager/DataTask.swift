import Foundation

final class SessionDataTask {

    static func dataTask<T: Decodable>(type: T.Type, _ requestParams: APIRequestParams, _ completion: @escaping APIConstants.Handler<T>) {

        guard let request = SessionURLRequest.urlRequest(requestParams) else {
            LoaderUtil.shared.hideLoading()
            completion(.failure(.invalidRequest))
            return
        }

        LoaderUtil.shared.showLoading()
        LogHandler.shared.requestLog(request)
        Monitor().startMonitoring { [ ] connection, reachable in
            let reachableStatus = Monitor.getCurrentConnectivityStatus(connection, reachable)
            if reachableStatus == .yes {
                let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    LogHandler.shared.responseLog(data, response, error)
                    APIResponse.responseHandler(data, response, error, completion)
                    LoaderUtil.shared.hideLoading()
                })
                task.resume()
            } else {
                LoaderUtil.shared.hideLoading()
                APIRequestResources.shared.remoteErrorAlert("no_internet_connection".localized(),
                                                            "device_connected_with_internet_warning".localized())
            }
        }
    }
}

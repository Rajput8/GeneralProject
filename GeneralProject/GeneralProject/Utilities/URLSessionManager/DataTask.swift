import Foundation

final class SessionDataTask {

    static func dataTask<T: Decodable>(type: T.Type, _ requestParams: APIRequestParams, _ completion: @escaping APIConstants.Handler<T>) {

        guard let request = SessionURLRequest.urlRequest(requestParams) else {
            LoaderUtil.hideLoading()
            completion(.failure(.invalidRequest))
            return
        }

        LoaderUtil.showLoading()
        LogHandler.requestLog(request)
        Monitor().startMonitoring { [ ] connection, reachable in
            let reachableStatus = Monitor.getCurrentConnectivityStatus(connection, reachable)
            if reachableStatus == .yes {
                let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    LogHandler.responseLog(data, response, error)
                    APIResponse.responseHandler(data, response, error, completion)
                    LoaderUtil.hideLoading()
                })
                task.resume()
            } else {
                LoaderUtil.hideLoading()
                APIRequestResources.remoteErrorAlert("no_internet_connection".localized(),
                                                     "device_connected_with_internet_warning".localized())
            }
        }
    }
}

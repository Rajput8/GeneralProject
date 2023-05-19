import Foundation

final class SessionDataTask {

    static func dataTask<T: Decodable>(type: T.Type, _ requestParams: APIRequestParams, _ completion: @escaping APIConstants.Handler<T>) {

        guard let request = SessionURLRequest.urlRequest(requestParams) else {
            SwiftSpinner.hide()
            completion(.failure(.invalidRequest))
            return
        }

        // SwiftSpinner.show("Please wait", animated: true)
        LogHandler.requestLog(request)
        Monitor().startMonitoring { [ ] connection, reachable in
            let reachableStatus = Monitor.getCurrentConnectivityStatus(connection, reachable)
            if reachableStatus == .yes {
                let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    LogHandler.responseLog(data, response, error)
                    APIResponse.responseHandler(data, response, error, completion)
                    SwiftSpinner.hide()
                })
                task.resume()
            } else {
                SwiftSpinner.hide()
                APIRequestResources.remoteErrorAlert("no_internet_connection".localized(),
                                                     "device_connected_with_internet_warning".localized())
            }
        }
    }
}

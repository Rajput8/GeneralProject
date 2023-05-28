import Foundation

class APIResponse {

    static func responseHandler<T: Decodable>(_ data: Data?, _ response: URLResponse?, _ error: Error?, _ completion: APIConstants.Handler<T>) {
        guard let response = response as? HTTPURLResponse, let data, error == nil else {
            completion(.failure(.errorMessage("null_data_in_response".localized())))
            return
        }

        guard 200 ... 299 ~= response.statusCode else {
            if response.statusCode == 401 { // Unauthorize user
                DispatchQueue.main.async { if let destVC = R.storyboard.main.loginVC() { HelperUtil.shared.makeRootVC(destVC) } }
            } else {
                decodeResponse(type: T.self, data, completion, false)
            }
            return
        }
        decodeResponse(type: T.self, data, completion, true)
    }

    fileprivate static func decodeResponse<T: Decodable>(type: T.Type, _ data: Data, _ completion: APIConstants.Handler<T>, _ isSuccess: Bool) {
        do {
            switch isSuccess {
            case true:
                let resp = try JSONDecoder().decode(T.self, from: data)
                completion(.success(resp.self))
            case false:
                let resp = try JSONDecoder().decode(APIBasicResponse.self, from: data)
                completion(.failure(.errorMessage(resp.message ?? "")))
            }
        } catch {
            let parseError = APIRequestResources.shared.parseError(error)
            completion(.failure(.errorMessageWithError(error, parseError)))
        }
    }
}

// MARK: - APIBasicResponse
struct APIBasicResponse: Codable {
    let status: Int?
    let message: String?
}

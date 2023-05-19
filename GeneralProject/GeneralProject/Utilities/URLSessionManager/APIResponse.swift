import Foundation

class APIResponse {

    static func responseHandler<T: Decodable>(_ data: Data?, _ response: URLResponse?, _ error: Error?, _ completion: APIConstants.Handler<T>) {
        guard let data, error == nil else {
            completion(.failure(.errorMessage("null_data_in_response".localized())))
            return
        }

        guard let response = response as? HTTPURLResponse, 200 ... 299 ~= response.statusCode else {
            completion(.failure(.errorMessage("failure_api_response".localized())))
            return
        }

        do {
            let resp = try JSONDecoder().decode(T.self, from: data)
            completion(.success(resp.self))
        } catch {
            let parseError = APIRequestResources.parseError(error)
            completion(.failure(.errorMessageWithError(error, parseError)))
        }
    }
}

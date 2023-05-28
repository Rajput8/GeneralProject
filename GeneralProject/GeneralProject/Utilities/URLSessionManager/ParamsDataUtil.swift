import Foundation

class ParamsDataUtil {

    static let shared = ParamsDataUtil()

    func jsonDataToString(_ jsonData: Data?) {
        guard let jsonData = jsonData else { return }
        _ = String(data: jsonData, encoding: .utf8)
    }

    func arrStringDictToString(_ dict: [[String: String]]) -> String? {
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(dict) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        }
        return nil
    }

    func stringAnyDictToStringDict(_ dict: [String: Any]) -> [String: String] {
        var newDict = [String: String]()
        for (key, value) in dict { newDict[key] = "\(value)" }
        return newDict
    }

    func generateModelData<T: Codable>(_ value: T) -> Data? {
        do {
            let jsonData = try JSONEncoder().encode(value)
            return jsonData
        } catch { LogHandler.shared.reportLogOnConsole(nil, "unable_to_generate_data_from_model".localized()) }
        return nil
    }

    func generateModelRawJson<T: Codable>(_ value: T) -> [String: Any]? {
        guard let data = generateModelData(value) else { return nil }
        if let rawJson = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] { return rawJson }
        return nil
    }
}

extension Collection where Iterator.Element == [String: Any] {
    func arrStringAnyDictToString(options: JSONSerialization.WritingOptions = .prettyPrinted) -> String {
        if let arr = self as? [[String: Any]],
           let dat = try? JSONSerialization.data(withJSONObject: arr, options: options),
           let str = String(data: dat, encoding: String.Encoding.utf8) {
            return str
        }
        return "[]"
    }
}

import Foundation

class JsonHandler {

    public static func jsonDataToString(_ jsonData: Data?) {
        guard let jsonData = jsonData else { return }
        let jsonString = String(data: jsonData, encoding: .utf8)
        print("jsonString \(jsonString ?? "")")
    }

    public static func arrStringDictToString(_ dict: [[String: String]]) -> String? {
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(dict) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
               return jsonString
            }
        }
        return nil
    }

    public static func stringAnyDictToStringDict(_ dict: [String: Any]) -> [String: String] {
        var newDict = [String: String]()
        for (key, value) in dict { newDict[key] = "\(value)" }
        return newDict
    }

    private static func stringDictToString(params: [String: String]) -> String {
        var data = [String]()
        for(key, value) in params {
            if let escapedString = value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed ) {
                data.append(key + "=\(escapedString)")
            }
        }
        return data.map { String($0) }.joined(separator: "&")
    }

    public static func stringDictToData(_ postBody: [String: String]) -> Data? {
        let postString = stringDictToString(params: postBody)
        let postData = postString.data(using: .utf8)
        return postData
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

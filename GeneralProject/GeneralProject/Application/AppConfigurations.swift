import Foundation

final class AppConfiguration {

    lazy var apiKey: String = {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "ApiKey") as? String else {
            fatalError("ApiKey must not be empty in plist")
        }
        return apiKey
    }()

    static func fetchAppConstantsPListInfo() -> NSDictionary? {
        guard let path = Bundle.main.path(forResource: "AppConstants", ofType: "plist") else { return nil }
        return NSDictionary(contentsOfFile: path)
    }

    static func disableAutolayoutErrorWarning() {
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    }
}


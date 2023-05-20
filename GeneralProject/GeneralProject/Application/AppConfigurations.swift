import Foundation
import CoreLocation

final class AppConfiguration {

    static var manager = AppConfiguration()

    var locationManager: CLLocationManager?

    static func fetchAppConstantsPListInfo() -> NSDictionary? {
        guard let path = Bundle.main.path(forResource: "AppConstants", ofType: "plist") else { return nil }
        return NSDictionary(contentsOfFile: path)
    }

    lazy var googleServicesApiKey: String = {
        guard let dict = AppConfiguration.fetchAppConstantsPListInfo(), let key = dict["Google_Services_Api_Key"] as? String else {
            fatalError("Google services api key must not be empty in AppConstants.plist")
        }
        return key
    }()

    static func disableAutolayoutErrorWarning() {
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    }
}

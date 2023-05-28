import Foundation
import CoreLocation

final class AppConfiguration {

    static var shared = AppConfiguration()

    var locationManager: CLLocationManager?

    func fetchAppConstantsPListInfo() -> NSDictionary? {
        guard let path = Bundle.main.path(forResource: "AppConstants", ofType: "plist") else { return nil }
        return NSDictionary(contentsOfFile: path)
    }

    lazy var googleServicesApiKey: String = {
        guard let dict = AppConfiguration.shared.fetchAppConstantsPListInfo(),
              let key = dict["Google_Services_Api_Key"] as? String else {
            fatalError("Google services api key must not be empty in AppConstants.plist")
        }
        return key
    }()

    func disableAutolayoutErrorWarning() {
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    }
}

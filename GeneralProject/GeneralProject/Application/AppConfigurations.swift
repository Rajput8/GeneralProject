import Foundation
import CoreLocation
import FBSDKLoginKit

final class AppConfiguration {

    static var shared = AppConfiguration()

    var locationManager: CLLocationManager?
    var loginManager = LoginManager()

    func fetchAppConstantsPListInfo() -> NSDictionary? {
        guard let path = Bundle.main.path(forResource: "AppConstants", ofType: "plist") else { return nil }
        return NSDictionary(contentsOfFile: path)
    }

    lazy var twitterConsumerKey: String = {
        guard let dict = fetchAppConstantsPListInfo(), let key = dict["Twitter_Consumer_Key"] as? String else {
            fatalError("Twitter consumer key must not be empty in AppConstants.plist")
        }
        return key
    }()

    lazy var twitterConsumerSecretKey: String = {
        guard let dict = fetchAppConstantsPListInfo(), let key = dict["Twitter_Consumer_Secret_Key"] as? String else {
            fatalError("Twitter consumer secret key must not be empty in AppConstants.plist")
        }
        return key
    }()

    lazy var twitterCallbackUrl: String = {
        guard let dict = fetchAppConstantsPListInfo(), let key = dict["Twitter_Callback_URL"] as? String else {
            fatalError("Twitter callback URL key must not be empty in AppConstants.plist")
        }
        return key
    }()

    lazy var apiKey: String = {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "ApiKey") as? String else {
            fatalError("ApiKey must not be empty in plist")
        }
        return apiKey
    }()

    lazy var googleServicesApiKey: String = {
        guard let dict = fetchAppConstantsPListInfo(),
              let key = dict["Google_Services_Api_Key"] as? String else {
            fatalError("Google services api key must not be empty in AppConstants.plist")
        }
        return key
    }()

    lazy var googleClientID: String = {
        guard let dict = fetchAppConstantsPListInfo(), let key = dict["Google_Client_ID"] as? String else {
            fatalError("Google client ID key must not be empty in AppConstants.plist")
        }
        return key
    }()

    lazy var appStoreAppID: String = {
        guard let dict = fetchAppConstantsPListInfo(), let key = dict["App_Store_ID"] as? String else {
            fatalError("App store ID key must not be empty in AppConstants.plist")
        }
        return key
    }()

    func disableAutolayoutErrorWarning() {
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    }
}

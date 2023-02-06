import UIKit
import CoreLocation

extension CLLocation {
    func reverseGeoCodeUsingCLLocation(completion: @escaping (_ city: String?, _ country: String?, _ error: Error?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(self) {
            completion($0?.first?.locality, $0?.first?.country, $1)
        }
    }
}

extension CLLocationDistance {
    func inMiles() -> CLLocationDistance { return self*0.00062137 }
    func inKilometers() -> CLLocationDistance { return self/1000 }
}

// MARK: - LocationType
enum LocationType: String, Codable {
    case approximate = "APPROXIMATE"
    case geometricCenter = "GEOMETRIC_CENTER"
    case rooftop = "ROOFTOP"
    case rangeInterpolated = "RANGE_INTERPOLATED"
}

enum LocationPermissionStatus {
    case notDetermined
    case restricted
    case denied
    case authorizedAlways
    case authorizedWhenInUse
    case error

    var status: String {
        switch self {
        case .notDetermined: return "not_determined".localized()
        case .restricted: return "restricted".localized()
        case .denied: return "notAllow".localized()
        case .authorizedAlways: return "allow".localized()
        case .authorizedWhenInUse: return "allowWhenInUse".localized()
        case .error: return "setting_problem".localized()
        }
    }
}

enum GoogleMapViewOptions: Int {
    case traffic = 1
    case trackingInfo = 2
    case refresh = 3
    case currentLocationSetting = 4
    case tracing
}

enum GoogleMapType: Int {
    case normalType = 1
    case satelliteType = 2
}

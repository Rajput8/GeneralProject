import UIKit
import GoogleMaps

class LiveMapView {

    public static var googleMapView: GMSMapView?

    public static func googleMapViewOptionsHandler(_ tagValue: Int, _ isSelectedStatus: Bool?, _ iconView: UIImageView? = nil) {
        if tagValue == GoogleMapViewOptions.traffic.rawValue {
            if isSelectedStatus == true {
                googleMapView?.isTrafficEnabled = true
            } else {
                googleMapView?.isTrafficEnabled = false
            }
        } else if tagValue == GoogleMapViewOptions.trackingInfo.rawValue {

        } else if tagValue ==  GoogleMapViewOptions.refresh.rawValue {

        } else if tagValue == GoogleMapViewOptions.currentLocationSetting.rawValue {
            googleMapView?.settings.myLocationButton = true
        } else if tagValue == GoogleMapViewOptions.trackingInfo.rawValue {

        }
    }
}

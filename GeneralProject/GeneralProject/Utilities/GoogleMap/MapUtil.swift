import UIKit
import GoogleMaps
import CoreLocation

class MapUtil {

    // MARK: Variables
    public static var locationMarker: GMSMarker?

    // MARK: Delegate's Method
    public static func googleMapSetUp(_ googleMapView: GMSMapView,
                                      _ markerIcon: UIImage?,
                                      _ scaleBarView: ScaleBarView? = nil,
                                      _ lat: Double? = nil,
                                      _ log: Double? = nil,
                                      _ zoom: Float? = nil) {
        googleMapView.isMyLocationEnabled = true
        googleMapView.settings.myLocationButton = true
        if let scaleBarView = scaleBarView { scaleBarView.mapView = googleMapView }
        if let lat, let log {
            let coordinates = CLLocation(latitude: lat, longitude: log)
            let lat = coordinates.coordinate.latitude
            let log = coordinates.coordinate.longitude
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: log, zoom: zoom ?? 17.0)
            googleMapView.animate(to: camera)
            // Creates a marker in the center of the map.
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: lat, longitude: log)
            marker.title = "Sydney"
            marker.snippet = "Australia"
            if let markerIcon = markerIcon { marker.icon = markerIcon.resizeImage(targetSize: CGSize(width: 50, height: 50)) }
            marker.map = googleMapView
            locationMarker = marker
        }
    }

    public static func reverseGeoCodeUsingGoogleMapAPI(_ lat: Double,
                                                       _ log: Double,
                                                       _ completion: @escaping (_ address: String?, _ error: String?) -> Void) {
        let coordinates = CLLocation(latitude: lat, longitude: log)
        let lat = coordinates.coordinate.latitude
        let log = coordinates.coordinate.longitude
        let link = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(lat),\(log)&key=\(AppConstants.googleServicesAPIKey)"
        guard let url = URL(string: link) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
            guard let dataResult = data else { return }
            do {
                let resp = try JSONDecoder().decode(ReverseGeoCodeResponseModel.self, from: dataResult)
                DispatchQueue.main.async {
                    if let formattedAddress = resp.results?.first?.formattedAddress as? String {
                        completion(formattedAddress, nil)
                    } else {
                        completion(nil, "Not found")
                    }
                }
            } catch {
                debugPrint(error.localizedDescription)
            }
        }).resume()
    }

    public static func fetchRoute(_ mapView: GMSMapView, _ source: CLLocationCoordinate2D, _ destination: CLLocationCoordinate2D) {
        let session = URLSession.shared
        let sourceLat = source.latitude
        let sourceLog = source.longitude
        let destLat = destination.latitude
        let destLog = destination.longitude

        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(sourceLat),\(sourceLog)&destination=\(destLat),\(destLog)&sensor=false&mode=driving&key=\(AppConstants.googleServicesAPIKey)")!

        let task = session.dataTask(with: url, completionHandler: { (data, _, error) in
            guard error == nil else {
                debugPrint(error!.localizedDescription)
                return
            }

            let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
            let jsonResponse = jsonResult
            guard let routes = jsonResponse?["routes"] as? [Any] else { return }
            guard let route = routes[0] as? [String: Any] else { return }
            guard let overviewPolyline = route["overview_polyline"] as? [String: Any] else { return }
            guard let polyLineString = overviewPolyline["points"] as? String else { return }
            // Call this method to draw path on map
            DispatchQueue.main.async {
                drawPath(polyLineString, mapView, source, destination)
            }
        })
        task.resume()
    }

    public static func drawPath(_ polyStr: String,
                                _ mapView: GMSMapView,
                                _ source: CLLocationCoordinate2D,
                                _ destination: CLLocationCoordinate2D) {
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = .systemBlue
        polyline.strokeWidth = 5.0
        polyline.map = mapView // Google MapView
        let cameraUpdate = GMSCameraUpdate.fit(GMSCoordinateBounds(coordinate: source, coordinate: destination))
        mapView.moveCamera(cameraUpdate)
        let currentZoom = mapView.camera.zoom
        mapView.animate(toZoom: currentZoom - 1.4)
    }

    public static func locationPermissionStatus(completionHandler: @escaping (_ status: LocationPermissionStatus) -> Void) {
        if CLLocationManager.locationServicesEnabled() {
            switch AppConstants.locationManager.authorizationStatus {
            case .notDetermined: completionHandler(.notDetermined)
            case .restricted: completionHandler(.restricted)
            case .denied: completionHandler(.denied)
            case .authorizedAlways: completionHandler(.authorizedAlways)
            case .authorizedWhenInUse: completionHandler(.authorizedWhenInUse)
            default: break
            }
        } else {
            debugPrint("Location services are not enabled")
            completionHandler(.error)
        }
    }

    public static func showMarkerIndicator() { }
}

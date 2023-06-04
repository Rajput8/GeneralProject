import Foundation

extension Double {

    var toString: String {
        return String(format: "%.1f", self)
    }

    var toInt: Int {
        let temp: Int64 = Int64(self)
        return Int(temp)
    }

    func format(_ value: String) -> String {
        return NSString(format: "%\(value)f" as NSString, self) as String
    }

    func roundToPlaces(_ places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

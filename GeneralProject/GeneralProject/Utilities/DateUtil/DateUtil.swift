import Foundation

class DateUtil {

    static let shared = DateUtil()

    var dateFormatter = DateFormatter()
    fileprivate var calendar = Calendar.current

    private func getDateFormatter(_ dateFormat: String) -> DateFormatter {
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
    }

    func dateToString(_ dateFormat: DateFormat, _ date: Date) -> String {
        let dateFormatter = getDateFormatter(dateFormat.formatValue)
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }

    func stringToDate(_ dateFormat: DateFormat, _ date: String) -> Date? {
        let dateFormatter = getDateFormatter(dateFormat.formatValue)
        guard let date = dateFormatter.date(from: date) else { return nil }
        return date
    }

    func dateTimeParamHandler(_ start: Date,
                              _ end: Date,
                              _ completionHandler: @escaping (_ param: String?, _ error: String?) -> Void) {
        if start > end {
            completionHandler(nil, "error_date_range_selection".localized())
        } else {
            if let current = Calendar.current.date(byAdding: .day, value: -1, to: Date()) {
                var param = String()
                let fromDateTime = dateToString(.yyyyMMddTHHmmssZ, start)
                let toDateTime = dateToString(.yyyyMMddTHHmmssZ, end)
                if end < current {
                    param = "\(fromDateTime)..\(toDateTime)"
                } else {
                    param = "\(fromDateTime)..now"
                }
                completionHandler(param, nil)
            }
        }
    }

    func convertSecondsIntoFormattedString(_ seconds: Double) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        if let formattedString = formatter.string(from: TimeInterval(seconds)) {
            return formattedString
        }
        return ""
    }

    func calculateDateSinceAgo(_ date: Date) -> String {
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let currentDateComponents = calendar.dateComponents([.year, .month, .day], from: Date())

        let endComponents = DateComponents(year: dateComponents.year,
                                           month: dateComponents.month,
                                           day: dateComponents.day)

        let startComponents = DateComponents(year: currentDateComponents.year,
                                             month: currentDateComponents.month,
                                             day: currentDateComponents.day)

        let finalDateComponents = calendar.dateComponents([.year, .month, .day], from: startComponents, to: endComponents)

        if finalDateComponents.description.contains("-") {
            if finalDateComponents.year == 0 && finalDateComponents.day ?? 0 < 0 {
                return String(format: "days_ago".localized(),
                              arguments: ["\(finalDateComponents.day ?? 0)"]).replacingOccurrences(of: "-", with: "")

            } else if finalDateComponents.day == 0 && finalDateComponents.year ?? 0 < 0 {
                return String(format: "years_ago".localized(),
                              arguments: ["\(finalDateComponents.year ?? 0)"]).replacingOccurrences(of: "-", with: "")

            } else if finalDateComponents.year == 0 && finalDateComponents.day == 0 {
                return "today".localized()

            } else {
                let year = "\(finalDateComponents.year ?? 0)"
                let day = "\(finalDateComponents.day ?? 0)"
                return String(format: "years_days_ago".localized(), arguments: [year, day]).replacingOccurrences(of: "-", with: "")
            }
        } else {
            if finalDateComponents.year == 0 && finalDateComponents.day ?? 0 > 0 {
                return String(format: "days_in_future".localized(),
                              arguments: ["\(finalDateComponents.day ?? 0)"])

            } else if finalDateComponents.day == 0 && finalDateComponents.year ?? 0 > 0 {
                return String(format: "years_in_future".localized(),
                              arguments: ["\(finalDateComponents.year ?? 0)"])

            } else if finalDateComponents.year == 0 && finalDateComponents.day == 0 {
                return "today".localized()

            } else {
                let year = "\(finalDateComponents.year ?? 0)"
                let day = "\(finalDateComponents.day ?? 0)"
                return String(format: "years_days_in_future".localized(), arguments: [year, day])
            }
        }
    }

    func convertStringUTCToLocal(_ dateTime: String,
                                 _ receivedDateTimeFormat: DateFormat = DateFormat.yyyyMMddHHmmss,
                                 _ toFormat: DateFormat = DateFormat.MMMdhmma) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        //  dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = receivedDateTimeFormat.formatValue
        guard let date = dateFormatter.date(from: dateTime) else {
            LogHandler.shared.reportLogOnConsole(nil, "Unable to convert string to date")
            return nil
        }

        let strDate = dateFormatter.string(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        guard let utcData = dateFormatter.date(from: strDate) else {
            LogHandler.shared.reportLogOnConsole(nil, "Unable to convert string to date")
            return nil
        }

        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = toFormat.formatValue
        return dateFormatter.string(from: utcData)
    }
}

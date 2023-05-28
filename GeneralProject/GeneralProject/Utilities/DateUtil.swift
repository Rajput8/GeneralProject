import Foundation

class DateUtil {

    enum DateFormat {
        case HHmmaddMMyyyy
        case yyyyMMddTHHmmssZ
        case yyyymmdd
        case HHmma

        var formatValue: String {
            switch self {
            case .HHmmaddMMyyyy: return "HH:mm a dd/MM/yyyy"
            case .yyyyMMddTHHmmssZ: return "yyyy-MM-dd'T'HH:mm:ss'Z'"
            case .yyyymmdd: return "yyyyMMdd"
            case .HHmma: return "HH:mm a"
            }
        }
    }

    enum QuickSearchOption: CaseIterable {
        case lastHour
        case today
        case yesterday
        case thisWeek

        var name: String {
            switch self {
            case .lastHour: return "last_hour".localized()
            case .today: return "today".localized()
            case .yesterday: return "yesterday".localized()
            case .thisWeek: return "this_week".localized()
            }
        }
    }

    static let shared = DateUtil()

    var dateFormatter = DateFormatter()
    fileprivate var calendar = Calendar.current

    private func getDateFormatter(_ dateFormat: String) -> DateFormatter {
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
    }

    func convertDateIntoString(_ dateFormat: DateFormat, _ date: Date) -> String {
        let dateFormatter = getDateFormatter(dateFormat.formatValue)
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }

    func convertStringIntoDate(_ dateFormat: DateFormat, _ date: String) -> Date? {
        let dateFormatter = getDateFormatter(dateFormat.formatValue)
        if let date = dateFormatter.date(from: date) {
            return date
        }
        return nil
    }

    func changeStringDateFormat(_ acutalDateFormat: DateFormat, convertedDateFormat: DateFormat, _ date: String) -> String? {
        let dateFormatter = getDateFormatter(acutalDateFormat.formatValue)
        if let actualDate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = convertedDateFormat.formatValue
            return dateFormatter.string(from: actualDate)
        }
        return nil
    }

    func quickSearchDateTimeParamHandler(_ option: QuickSearchOption) -> String? {
        if let date = quickSearchDate(option) {
            return "\(date)..now"
        }
        return nil
    }

    fileprivate func quickSearchDate(_ option: QuickSearchOption) -> String? {
        var date: Date?
        switch option {
        case .lastHour:
            date = Calendar.current.date(byAdding: .hour, value: -1, to: Date())
        case .today:
            date = Date()
        case .yesterday:
            date = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        case .thisWeek:
            date = Date().startOfWeek
        }

        guard let optionDate = date else { return nil }
        return convertDateIntoString(.yyyyMMddTHHmmssZ, optionDate)
    }

    func dateTimeParamHandler(_ start: Date,
                              _ end: Date,
                              _ completionHandler: @escaping (_ param: String?, _ error: String?) -> Void) {
        if start > end {
            completionHandler(nil, "error_date_range_selection".localized())
        } else {
            if let current = Calendar.current.date(byAdding: .day, value: -1, to: Date()) {
                var param = String()
                let fromDateTime = DateUtil.shared.convertDateIntoString(.yyyyMMddTHHmmssZ, start)
                let toDateTime = DateUtil.shared.convertDateIntoString(.yyyyMMddTHHmmssZ, end)
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
}

import Foundation

enum DateFormat {
    case HHmmaddMMyyyy
    case yyyyMMddTHHmmssZ
    case yyyymmdd
    case HHmma
    case yyyyMMddHHmmss
    case MMMdhmma

    var formatValue: String {
        switch self {
        case .HHmmaddMMyyyy: return "HH:mm a dd/MM/yyyy"
        case .yyyyMMddTHHmmssZ: return "yyyy-MM-dd'T'HH:mm:ss'Z'"
        case .yyyymmdd: return "yyyyMMdd"
        case .HHmma: return "HH:mm a"
        case .yyyyMMddHHmmss: return "yyyy-MM-dd HH:mm:ss"
        case .MMMdhmma: return "MMM d, h:mm a"
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
        return DateUtil.shared.dateToString(.yyyyMMddTHHmmssZ, optionDate)
    }
}

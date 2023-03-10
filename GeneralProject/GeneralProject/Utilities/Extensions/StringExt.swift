import UIKit

extension String {

    func trimmed() -> String { return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) }

    func localized(bundle: Bundle = .main, tableName: String = LocalizableFiles.generalPurpose.filename) -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }

    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute( NSAttributedString.Key.strikethroughStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSMakeRange(0, attributeString.length))
        attributeString.addAttribute(NSAttributedString.Key.strikethroughColor,
                                     value: UIColor.gray,
                                     range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}

enum LocalizableFiles {
    case generalPurpose
    var filename: String {
        switch self {
        case .generalPurpose: return "LocalizableMessage"
        }
    }
}

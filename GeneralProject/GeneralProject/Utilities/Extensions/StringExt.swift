import UIKit

extension String {

    func trimmed() -> String { return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) }

    func localized(bundle: Bundle = .main, tableName: String = LocalizableFiles.generalPurpose.filename) -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }

    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: NSUnderlineStyle.single.rawValue,
                                     range: NSRange(location: 0, length: attributeString.length))
        attributeString.addAttribute(NSAttributedString.Key.strikethroughColor,
                                     value: UIColor.gray,
                                     range: NSRange(location: 0, length: attributeString.length))
        return attributeString
    }
}

extension NSMutableAttributedString {

    func setColorFontForText(_ textForAttribute: [String], _ color: [UIColor]) {
        for (index, content) in textForAttribute.enumerated() {
            var textColor = UIColor.black
            if index < color.count { textColor = color[index] }
            let range: NSRange = self.mutableString.range(of: content, options: .caseInsensitive)
            let attributes = [NSAttributedString.Key.foregroundColor: textColor,
                              NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
            self.addAttributes(attributes, range: range)
        }
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

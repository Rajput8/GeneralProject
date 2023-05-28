import UIKit

extension UILabel {

    func formatting() {
        textAlignment = .left
        textColor = .label
        font = .systemFont(ofSize: 16.0, weight: .medium)
        numberOfLines = 0
        lineBreakMode = .byCharWrapping
        // sizeToFit()
    }
}

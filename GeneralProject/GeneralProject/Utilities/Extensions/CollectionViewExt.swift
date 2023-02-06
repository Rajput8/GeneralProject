import Foundation
import UIKit

extension UICollectionView {

    func registerCellFromNib(cellID: String) {
        self.register(UINib(nibName: cellID, bundle: nil), forCellWithReuseIdentifier: cellID)
    }

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .darkGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "CircularStd-Book", size: 16)
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel
    }

    func restore() { self.backgroundView = nil }
}

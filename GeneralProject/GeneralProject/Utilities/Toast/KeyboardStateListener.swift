import Foundation
import UIKit

class KeyboardStateListener {

    static let shared = KeyboardStateListener()
    var isVisible = false
    var keyboardheight: CGFloat = 0.0

    func start() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func handleShow(_ notification: NSNotification) {
        isVisible = true
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            keyboardheight = keyboardHeight
        }
    }

    @objc func handleHide() {
        isVisible = false
        keyboardheight = 0.0
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

import UIKit

extension UITextView {

    @IBInspectable var doneAccessory: Bool {
        get { return self.doneAccessory }
        set (hasDone) {
            if hasDone { addDoneButtonOnKeyboard() }
        }
    }

    func addDoneButtonOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        var doneButton = UIBarButtonItem()
        doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                     target: self,
                                     action: #selector(self.resignFirstResponder))
        keyboardToolbar.items = [flexibleSpace, doneButton]
        self.inputAccessoryView = keyboardToolbar
    }
}

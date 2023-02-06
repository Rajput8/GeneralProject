import UIKit

extension UITextField {
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

    func addInputViewDatePicker(_ target: Any, _ selector: Selector, _ maximumLimit: Date? = nil) {
        let screenWidth = UIScreen.main.bounds.width
        // Add DatePicker as inputView
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        if let maxLimit = maximumLimit { datePicker.maximumDate = maxLimit }
        self.inputView = datePicker
        // Add Tool Bar as input AccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
        self.inputAccessoryView = toolBar
    }

    @objc func cancelPressed() {
        self.resignFirstResponder()
    }
}

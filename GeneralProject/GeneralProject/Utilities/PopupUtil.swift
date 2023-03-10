import UIKit

class PopupUtil {

    public static func popupAlert(title: String?,
                                  message: String?,
                                  actionTitles: [String?],
                                  actions: [((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            if index == 0 {
                action.setValue(UIColor.red, forKey: "titleTextColor")
            }
            alert.addAction(action)
        }
        HelperUtil.getCurrentVC { currentVC in
            currentVC.present(alert, animated: true, completion: nil)
        }
    }
}

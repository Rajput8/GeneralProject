import Foundation
import UIKit

class HelperUtil {

    public static func getCurrentVC(fetch: @escaping(UIViewController) -> Void) {
        DispatchQueue.main.async {
            if let currentVC = UIWindow.key?.topViewController() { fetch(currentVC) }
        }
    }

    public static func navigationBarSetUp(_ title: String? = nil) {
        HelperUtil.getCurrentVC { res in
            // Set navigation item title
            if let title = title { res.navigationItem.title = title }
            res.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"),
                                                                   style: .plain,
                                                                   target: self,
                                                                   action: #selector(self.handleBack))
        }
    }

    @objc static func handleBack(_ sender: UIBarButtonItem) {
        HelperUtil.getCurrentVC { res in
            res.navigationController?.popViewController(animated: true)
        }
    }

    public static func fieldsSetUp(_ textFields: [UITextField]? = nil, _ textViews: [UITextView]? = nil) {
        if let textFields = textFields {
            _ = textFields.map({ field in field.addDoneButtonOnKeyboard() })
        }

        if let textViews = textViews {
            _ = textViews.map({ field in field.addDoneButtonOnKeyboard() })
        }
    }

    public static func makeRootVC(_ rootVC: UIViewController) {
        let navigationController = UINavigationController(rootViewController: rootVC)
        UIApplication.shared.keyWindow?.rootViewController = navigationController
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
    }
}

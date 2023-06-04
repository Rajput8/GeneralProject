import Foundation
import UIKit

class HelperUtil {

    static let shared = HelperUtil()

    func getVisibleVC(_ fetch: @escaping (UIViewController) -> Void) {
        DispatchQueue.main.async {
            if let visibleVC = UIWindow.key?.visibleVC() { fetch(visibleVC) }
        }
    }

    func navigationBarSetUp(_ title: String? = nil) {
        getVisibleVC { visibleVC in
            // Set navigation item title
            if let title = title { visibleVC.navigationItem.title = title }
            visibleVC.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"),
                                                                         style: .plain,
                                                                         target: self,
                                                                         action: #selector(self.handleBack))
        }
    }

    @objc func handleBack(_ sender: UIBarButtonItem) {
        getVisibleVC { visibleVC in
            visibleVC.navigationController?.popViewController(animated: true)
        }
    }

    func fieldsSetUp(_ textFields: [UITextField]? = nil, _ textViews: [UITextView]? = nil) {
        if let textFields = textFields {
            _ = textFields.map({ field in field.addDoneButtonOnKeyboard() })
        }

        if let textViews = textViews {
            _ = textViews.map({ field in field.addDoneButtonOnKeyboard() })
        }
    }

    func makeRootVC(_ rootVC: UIViewController) {
        let navigationController = UINavigationController(rootViewController: rootVC)
        UIApplication.shared.keyWindow?.rootViewController = navigationController
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
        // UIApplication.shared.windows.first?.rootViewController = navigationController
        // UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

    func pushViewController(_ destVC: UIViewController, _ isAnimated: Bool = false) {
        getVisibleVC { visibleVC in
            DispatchQueue.main.async {
                visibleVC.navigationController?.pushViewController(destVC, animated: isAnimated)
            }
        }
    }

    func loadDataFromJson() -> ListResponse? {
        let decoder = JSONDecoder()
        guard
            let url = Bundle.main.url(forResource: "List", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let data = try? decoder.decode(ListResponse.self, from: data)
        else { return nil }
        return data
    }
}

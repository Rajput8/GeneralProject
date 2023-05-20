import UIKit

class LoaderUtil {
    static func showLoading() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        HelperUtil.getCurrentVC { currentVC in
            DispatchQueue.main.async {
                currentVC.present(alert, animated: true, completion: nil)
            }
        }
    }

    static func hideLoading() {
        HelperUtil.getCurrentVC { currentVC in
            DispatchQueue.main.async {
                currentVC.dismiss(animated: false, completion: nil)
            }
        }
    }
}

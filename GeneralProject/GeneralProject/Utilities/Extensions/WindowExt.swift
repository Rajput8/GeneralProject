import UIKit

extension UIWindow {
    func visibleVC() -> UIViewController? {
        var top = self.rootViewController
        while true {
            if let presented = top?.presentedViewController {
                top = presented
            } else if let nav = top as? UINavigationController {
                top = nav.visibleViewController
            } else if let tab = top as? UITabBarController {
                top = tab.selectedViewController
            } else {
                break
            }
        }
        return top
    }

    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.keyWindow
        } else {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        }
    }
}

extension UIApplication {

    var keyWindow: UIWindow? {
        // Note: .filter { $0.activationState == .foregroundActive } and .first(where: \.isKeyWindow) -
        // these lines  commented because the window was not properly fetched.
        // Get connected scenes
        return UIApplication.shared.connectedScenes
        // Keep only active scenes, onscreen and visible to the user
        // .filter { $0.activationState == .foregroundActive }
        // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
        // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows.first
        // Finally, keep only the key window
        // .first(where: \.isKeyWindow)
    }
}

extension UINavigationController {
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let destVC = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(destVC, animated: animated)
        }
    }

    @objc override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

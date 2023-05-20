import Foundation
import UIKit

final class AppAppearance {

    static func setupAppearance() {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            // appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.backgroundColor = .systemBlue
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().tintColor = .white
        } else {
            UINavigationBar.appearance().tintColor = .white
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
    }

    static func setUpTabbarShadow(_ tabBarController: UITabBarController) {
        let tabGradientView = UIView(frame: tabBarController.tabBar.bounds)
        tabGradientView.backgroundColor = UIColor.white
        tabGradientView.translatesAutoresizingMaskIntoConstraints = false
        tabBarController.tabBar.addSubview(tabGradientView)
        tabBarController.tabBar.sendSubviewToBack(tabGradientView)
        tabGradientView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tabGradientView.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabGradientView.layer.shadowRadius = 4.0
        tabGradientView.layer.shadowColor = UIColor.gray.cgColor
        tabGradientView.layer.shadowOpacity = 0.6
        tabBarController.tabBar.clipsToBounds = false
        tabBarController.tabBar.backgroundImage = UIImage()
        tabBarController.tabBar.shadowImage = UIImage()
    }
}

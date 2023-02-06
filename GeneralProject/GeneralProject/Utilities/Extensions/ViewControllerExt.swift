import UIKit

extension UIViewController {

    func addChildView(_ viewController: UIViewController, in view: UIView) {
        viewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        viewController.view.frame = view.bounds
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }

    func removeAddedChild() {
        children.forEach({
            $0.willMove(toParent: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        })
    }
}

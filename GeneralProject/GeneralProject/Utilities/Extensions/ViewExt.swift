import UIKit

@IBDesignable
class CustomView: UIView {}

extension UIView {

    @IBInspectable var borderColor: UIColor? {
        get {
            let color = UIColor.init(cgColor: layer.borderColor!)
            return color
        }
        set { layer.borderColor = newValue?.cgColor }
    }

    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }

    @IBInspectable var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }

    @IBInspectable var shadowColor: UIColor {
        get { return UIColor.init(cgColor: layer.shadowColor!) }
        set { layer.shadowColor = newValue.cgColor }
    }

    @IBInspectable var shadowOpacity: Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }

    @IBInspectable var maskToBounds: Bool {
        get { return layer.masksToBounds }
        set { layer.masksToBounds = newValue }
    }

    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

    func setViewCircle() {
        self.layer.cornerRadius = self.bounds.size.height / 2.0
        self.clipsToBounds = true
    }

    // MARK: Method for getting uiview's components
    func viewOfType<T: UIView>(type: T.Type, process: (_ view: T) -> Void) {
        if let view = self as? T {
            process(view)
        } else {
            for subView in subviews { subView.viewOfType(type: type, process: process) }
        }
    }
}

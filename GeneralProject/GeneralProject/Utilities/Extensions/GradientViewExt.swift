import UIKit

extension UIView {

    private static var startColor = UIColor()
    private static var endColor = UIColor()
    private static var startLocationType = Int()
    private static var endLocationType = Int()

    @IBInspectable var gvStartColor: UIColor? {
        get { return UIView.startColor }
        set {
            UIView.startColor = newValue ?? .black
            applyGradientEffect()
        }
    }

    @IBInspectable var gvEndColor: UIColor? {
        get { return UIView.endColor }
        set {
            UIView.endColor = newValue ?? .black
            applyGradientEffect()
        }
    }

    @IBInspectable var gvStartLocationType: Int {
        get { return UIView.startLocationType }
        set {
            UIView.startLocationType = newValue
            applyGradientEffect()
        }
    }

    @IBInspectable var gvEndLocationType: Int {
        get { return UIView.endLocationType }
        set {
            UIView.endLocationType = newValue
            applyGradientEffect()
        }
    }

    private func applyGradientEffect() {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                let gradient = CAGradientLayer()
                self.removeGradient()
                gradient.frame = self.bounds
                gradient.colors = [UIView.startColor.cgColor, UIView.endColor.cgColor]
                gradient.startPoint = Locations.getPoints(UIView.startLocationType)
                gradient.endPoint = Locations.getPoints(UIView.endLocationType)
                gradient.locations = [0.0, 1.0]
                self.layer.insertSublayer(gradient, at: 0)
            }
        }
    }

    private func removeGradient() {
        layer.sublayers?.forEach { layer in
            if layer is CAGradientLayer {
                layer.removeFromSuperlayer()
            }
        }
    }
}

enum Locations: CaseIterable {
    case topLeft
    case centerLeft
    case bottomLeft
    case topCenter
    case center
    case bottomCenter
    case topRight
    case centerRight
    case bottomRight
    case unspecified

    var point: CGPoint {
        switch self {
        case .topLeft:
            return CGPoint(x: 0, y: 0)
        case .centerLeft:
            return CGPoint(x: 0, y: 0.5)
        case .bottomLeft:
            return CGPoint(x: 0, y: 1.0)
        case .topCenter:
            return CGPoint(x: 0.5, y: 0)
        case .center:
            return CGPoint(x: 0.5, y: 0.5)
        case .bottomCenter:
            return CGPoint(x: 0.5, y: 1.0)
        case .topRight:
            return CGPoint(x: 1.0, y: 0.0)
        case .centerRight:
            return CGPoint(x: 1.0, y: 0.5)
        case .bottomRight:
            return CGPoint(x: 1.0, y: 1.0)
        case .unspecified:
            return CGPoint(x: 0, y: 0)
        }
    }

    static func getPoints(_ value: Int) -> CGPoint {
        guard value < Locations.allCases.count else { return Locations.unspecified.point }
        return Locations.allCases[value].point
    }
}

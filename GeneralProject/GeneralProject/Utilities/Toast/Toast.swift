import Foundation
import UIKit

class Toast {

    static func show(message: String,
                     controller: UIViewController,
                     color: UIColor = UIColor.black.withAlphaComponent(0.8)) {
        DispatchQueue.main.async {
            let toastContainer = UIView(frame: CGRect())
            toastContainer.backgroundColor =  color
            toastContainer.alpha = 0.0
            toastContainer.layer.cornerRadius = 25
            toastContainer.clipsToBounds  =  true
            let toastLabel = UILabel(frame: CGRect())
            toastLabel.font = UIFont(name: "Poppins-SemiBold", size: 16.0)
            toastLabel.textColor = UIColor.white
            toastLabel.textAlignment = .center
            toastLabel.font.withSize(12.0)
            toastLabel.text = message
            toastLabel.clipsToBounds  =  true
            toastLabel.numberOfLines = 0
            toastContainer.addSubview(toastLabel)
            controller.view.addSubview(toastContainer)
            toastLabel.translatesAutoresizingMaskIntoConstraints = false
            toastContainer.translatesAutoresizingMaskIntoConstraints = false

            let const1 = NSLayoutConstraint(item: toastLabel, attribute: .leading,
                                            relatedBy: .equal, toItem: toastContainer,
                                            attribute: .leading, multiplier: 1,
                                            constant: 15)

            let const2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing,
                                            relatedBy: .equal, toItem: toastContainer,
                                            attribute: .trailing, multiplier: 1,
                                            constant: -15)

            let const3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom,
                                            relatedBy: .equal, toItem: toastContainer,
                                            attribute: .bottom, multiplier: 1,
                                            constant: -15)

            let const4 = NSLayoutConstraint(item: toastLabel, attribute: .top,
                                            relatedBy: .equal, toItem: toastContainer,
                                            attribute: .top, multiplier: 1,
                                            constant: 15)

            toastContainer.addConstraints([const1, const2, const3, const4])

            let const5 = NSLayoutConstraint(item: toastContainer, attribute: .leading,
                                            relatedBy: .equal, toItem: controller.view,
                                            attribute: .leading, multiplier: 1,
                                            constant: 65)

            let const6 = NSLayoutConstraint(item: toastContainer, attribute: .trailing,
                                            relatedBy: .equal, toItem: controller.view,
                                            attribute: .trailing, multiplier: 1,
                                            constant: -65)

            if KeyboardStateListener.shared.isVisible {
                let const7 = NSLayoutConstraint(item: toastContainer, attribute: .bottom,
                                                relatedBy: .equal, toItem: controller.view,
                                                attribute: .bottom, multiplier: 1,
                                                constant: -(35 + KeyboardStateListener.shared.keyboardheight))

                controller.view.addConstraints([const5, const6, const7])
            } else {
                let const7 = NSLayoutConstraint(item: toastContainer, attribute: .bottom,
                                                relatedBy: .equal, toItem: controller.view,
                                                attribute: .bottom, multiplier: 1,
                                                constant: -75)

                controller.view.addConstraints([const5, const6, const7])
            }

            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
                toastContainer.alpha = 1.0
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                    toastContainer.alpha = 0.0
                }, completion: {_ in toastContainer.removeFromSuperview() })
            })
        }
    }
}

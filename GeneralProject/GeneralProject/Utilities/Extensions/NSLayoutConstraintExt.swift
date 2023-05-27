import UIKit

extension NSLayoutConstraint {
    /// Note: we have two method setMultiplier and updateMultiplier, you can use anyone. Both working perfectly
    func setMultiplier(_ value: CGFloat) {
        guard let firstItem else { return }
        let newConstraint = NSLayoutConstraint(item: firstItem,
                                               attribute: firstAttribute,
                                               relatedBy: relation,
                                               toItem: secondItem,
                                               attribute: secondAttribute,
                                               multiplier: value,
                                               constant: constant)
        newConstraint.priority = self.priority
        NSLayoutConstraint.deactivate([self])
        NSLayoutConstraint.activate([newConstraint])
    }

    func updateMultiplier(_ value: CGFloat) {
        self.setValue(value, forKey: "multiplier")
    }
}

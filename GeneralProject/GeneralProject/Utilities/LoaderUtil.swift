import Foundation
import UIKit

class LoaderUtil {

    static let shared = LoaderUtil()

    fileprivate var screenWidth = UIScreen.main.bounds.width
    fileprivate var screenHeight = UIScreen.main.bounds.height
    fileprivate var defaultSize = CGSize(width: UIScreen.main.bounds.width/2, height: 50)
    fileprivate var defaultLeadingPadding = 10.0
    fileprivate var defaultLoadingMsg = "Please wait..."
    var loadingMsg: String?
    var loadingViewSize = CGSize()

    fileprivate var indicatorView: UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: defaultLeadingPadding, y: 0,
                                                              width: loadingViewSize.height,
                                                              height: loadingViewSize.height))
        indicator.hidesWhenStopped = true
        indicator.style = .medium
        indicator.startAnimating()
        return indicator
    }

    fileprivate var msgView: UIView {
        let originX = indicatorView.frame.width + defaultLeadingPadding
        let remainingWidth = loadingViewSize.width - originX
        let msg = UILabel(frame: CGRect(x: originX, y: 0, width: remainingWidth, height: loadingViewSize.height))
        msg.text = loadingMsg
        msg.formatting()
        return msg
    }

    func loadingView() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: loadingViewSize.width, height: loadingViewSize.height))
        view.layer.cornerRadius = 10.0
        view.backgroundColor = .systemBackground
        view.addSubview(indicatorView)
        view.addSubview(msgView)
        return view
    }

    func showLoading(size: CGSize? = nil, msg: String? = nil) {
        DispatchQueue.main.async {
            if self.isLoadingVisible() {
                LogHandler.shared.reportLogOnConsole(nil, "Already loading view visible")
            } else {
                guard let center = UIApplication.shared.keyWindow?.rootViewController?.view.center else { return }
                self.loadingMsg = msg ?? self.defaultLoadingMsg; self.loadingViewSize = size ?? self.defaultSize
                let loadingView = self.loadingView()
                let overlayView = UIView(frame: CGRect(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight))
                overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
                overlayView.tag = 998
                loadingView.center = center
                loadingView.tag = 999
                overlayView.addSubview(loadingView)
                UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(overlayView)
            }
        }
    }

    func hideLoading() {
        DispatchQueue.main.async {
            guard let addedSubViews = UIApplication.shared.keyWindow?.rootViewController?.view.subviews else { return }
            for subView in addedSubViews where subView.tag == 998 { subView.removeFromSuperview() }
        }
    }

    func isLoadingVisible() -> Bool {
        guard let addedSubViews = UIApplication.shared.keyWindow?.rootViewController?.view.subviews else { return false }
        for subView in addedSubViews where subView.tag == 999 { return true }
        return false
    }
}

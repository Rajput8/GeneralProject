import Foundation
import UIKit

struct WebPagesURLHandler {
    let scheme: String
    let page: String

    func openPage(_ errMessage: String? = nil) {
        var redirectURL: URL?
        if let schemeUrl = URL(string: scheme) {
            redirectURL = schemeUrl
        } else {
            redirectURL = URL(string: page)
        }

        guard let url = redirectURL else { return }
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                if !success { errorMessage(errMessage ?? "unexpected_error".localized()) }
            })
        } else if UIApplication.shared.openURL(url) { } else { errorMessage(errMessage ?? "unexpected_error".localized()) }
    }

    func errorMessage(_ errMessage: String) {
        HelperUtil.shared.getVisibleVC { visibleVC in
            Toast.show(message: errMessage, controller: visibleVC)
        }
    }
}

enum WebPagesURL {
    case helpPage, homePage, privacyPolicyPage, otherWebPage

    func openWebPage(_ otherWebPage: String?) {
        switch self {
        case .helpPage: WebPagesURLHandler(scheme: "", page: pageURL).openPage(errorMessage)
        case .homePage: WebPagesURLHandler(scheme: "", page: pageURL).openPage()
        case .privacyPolicyPage: WebPagesURLHandler(scheme: "", page: pageURL).openPage(errorMessage)
        case .otherWebPage: WebPagesURLHandler(scheme: "", page: otherWebPage ?? "").openPage(errorMessage)
        }
    }

    var pageURL: String {
        switch self {
        case .helpPage: return "https://www.cloudhawk.com/company-overview/contact-us/"
        case .homePage: return "https://www.cloudhawk.com/"
        case .privacyPolicyPage: return "https://www.cloudhawk.com/privacy-policy/"
        case .otherWebPage: return ""
        }
    }

    var errorMessage: String {
        switch self {
        case .helpPage: return "Please install app."
        case .homePage: return "Please install app."
        case .privacyPolicyPage: return "Please install app."
        case .otherWebPage: return "Please install app."
        }
    }
}

// USUAGE:  WebPagesURL.helpPage.openWebPage(nil)

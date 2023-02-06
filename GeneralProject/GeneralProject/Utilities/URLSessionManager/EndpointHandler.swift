import UIKit

enum APIRequestEnvironment {
    case local
    case qaTesting
    case beta
    case replica
    case prod
}

class EndpointHandler {
    // this is where we set the environment for the entire build
    static let env = APIRequestEnvironment.qaTesting
    static let mediaBaseUrl = "https://api.mycloudhawk.com/"

    static func domain() -> String {
        switch env {
        case .local:
            let phoneName = ProcessInfo.processInfo.hostName
            if phoneName.lowercased().contains("CloudHawk") {
                return "192.168.1.247"
            } else if phoneName.lowercased().contains("cloudHawk-macbook-pro-2.local") {
                return "local.qme.com"
            } else { return "127.0.0.1" }
        case .qaTesting: return "api.mycloudhawk.com"
        case .beta: return "api.mycloudhawk.com"
        case .replica: return "api.mycloudhawk.com"
        case .prod: return "api.mycloudhawk.com"
        }
    }

    static func apiUrlBase() -> String {
        switch env {
        case .local: return "https://\(domain()):9000"
        default: return "https://\(domain())"
        }
    }

    public static func apiUrl(_ endpoint: APIEndpoints) -> String {
        let endpointString = endpoint.urlComponent()
        if endpointString == "" {
            SwiftSpinner.hide()
            NSLog("missing gym id for \(endpoint.logDescription()) endpoint")
            return ""
        }
        return "\(apiUrlBase())/\(endpointString)"
    }
}

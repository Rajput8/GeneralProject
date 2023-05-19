import Foundation

enum Environment: CaseIterable {
    case local
    case qaTesting
    case betaTesting
    case development
    case production
    case unspecified

    var mode: String {
        switch self {
        case .local: return "Local"
        case .qaTesting: return "QATesting"
        case .betaTesting: return "BetaTesting"
        case .development: return "Development"
        case .production: return "Production"
        case .unspecified: return "Unspecified"
        }
    }

    static func alreadySettedEnvironment() -> String? {
        guard let dict = AppConfiguration.fetchAppConstantsPListInfo() else {
            LogHandler.reportLogOnConsole(nil, "empty_app_environment_err_msg".localized())
            return nil
        }
        // Remote request baseURL according to environment mode
        if let details = dict["App_Environment"] as? NSDictionary {
            for (key, value) in details {
                if let statusFlag = value as? Bool, statusFlag == true {
                    return key as? String
                }
            }
        }
        return nil
    }
    
    static func currentEnvironment() -> Environment {
        guard let settedMode = alreadySettedEnvironment() else { return .unspecified }
        for environment in Environment.allCases where environment.mode == settedMode { return environment }
        return .unspecified
    }

    static func remoteRequestBaseURL() -> String? {
        guard let dict = AppConfiguration.fetchAppConstantsPListInfo() else {
            LogHandler.reportLogOnConsole(nil, "empty_app_environment_err_msg".localized()); return nil
        }

        let key = "\(currentEnvironment().mode)_Base_URL"
        if let keyValue = dict[key] as? String, !keyValue.isEmpty {
            return keyValue
        } else {
            let errMsg = String(format: "empty_base_url_err_msg".localized(), [key])
            LogHandler.reportLogOnConsole(nil, errMsg)
            return nil
        }
    }
}

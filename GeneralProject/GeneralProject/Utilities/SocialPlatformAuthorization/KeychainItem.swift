import Foundation

class KeychainItem {

    // MARK: Types
    enum KeychainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unexpectedItemData
        case unhandledError
        case noError
        case error
    }

    enum SecAttrServer: String, CaseIterable {
        case google = "https://accounts.google.com/ServiceLogin"
        case facebook = "https://www.facebook.com"
        case twitter = "https://mobile.twitter.com/session/new"
        case yahoo = "https://login.yahoo.com/"
        case hotmail = "https://outlook.live.com/owa/"
        case amazon = "https://www.amazon.com/ap/signin?_encoding=UTF8&openid.assoc_handle=usflex&openid.claimed_id=http://specs.openid.net/auth/2.0/identifier_select&openid.identity=http://specs.openid.net/auth/2.0/identifier_select&openid.mode=checkid_setup&openid.ns=http://specs.openid.net/auth/2.0&openid.ns.pape=http://specs.openid.net/extensions/pape/1.0&openid.pape.max_auth_age=0&openid.return_to=https://www.amazon.com/gp/css/homepage.html?ie=UTF8&ref_=gno_yam_ya"
        case linkedIn = "https://www.linkedin.com/uas/login"
        case liveCom = "https://www.live.com/"
        case dropbox = "https://www.dropbox.com/"
        case ebay = "https://signin.ebay.com/ws/eBayISAPI.dll"
        case other = ""
    }

    enum KeychainOperation {
        case read
        case add
        case update
        case delete
    }

    // MARK: Properties
    private(set) var accessGroup: String
    private(set) var secClass: String
    private(set) var account: String
    let server: String?

    static var bundleIdentifier: String {
        return Bundle.main.bundleIdentifier ?? "com.CTZ.app"
    }

    // MARK: Intialization
    init(accessGroup: String, secClass: String, account: String, server: String? = nil) {
        self.accessGroup = accessGroup
        self.secClass = secClass
        self.account = account
        self.server = server
    }

    // MARK: Keychain access
    func readItem() -> String? {
        // Build a query to find the item that matches the service, account and access group.
        let query = KeychainItem.keychainQuery(accessGroup: accessGroup,
                                               secClass: secClass,
                                               account: account,
                                               server: server,
                                               keyChainOperation: .read)
        // Try to fetch the existing keychain item that matches the query.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        // Check the return status and throw an error if appropriate.
        if status != errSecItemNotFound {
            // Parse the password string from the query result.
            guard let existingItem = queryResult as? [String: AnyObject],
                  let passwordData = existingItem[kSecValueData as String] as? Data,
                  let password = String(data: passwordData, encoding: String.Encoding.utf8) else { return "something went wrong" }
            return password
        } else {
            return nil // Item not found
        }
    }

    func saveItem(_ password: String) {
        // Encode the password into an Data object.
        if let encodedPassword = password.data(using: String.Encoding.utf8) {
            // Check for an existing item in the keychain.
            if let item = readItem(), !item.isEmpty {
                // Update the existing item with the new password.
                var query = KeychainItem.keychainQuery(accessGroup: accessGroup,
                                                       secClass: secClass,
                                                       account: account,
                                                       server: server,
                                                       keyChainOperation: .update)
                var attributesToUpdate = [String: AnyObject]()
                attributesToUpdate[kSecValueData as String] = encodedPassword as AnyObject?
                query[kSecValueData as String] = encodedPassword as AnyObject?
                let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
                debugPrint(KeychainItem.performedQueryStatus(status))
            } else {
                var query = KeychainItem.keychainQuery(accessGroup: accessGroup,
                                                       secClass: secClass,
                                                       account: account,
                                                       server: server,
                                                       keyChainOperation: .add)
                // No password was found in the keychain. Create a dictionary to save as a new keychain item.
                query[kSecValueData as String] = encodedPassword as AnyObject?
                // Add a the new item to the keychain.
                let status = SecItemAdd(query as CFDictionary, nil)
                debugPrint(KeychainItem.performedQueryStatus(status))
            }
        }
    }

    func deleteItem() {
        // Delete the existing item from the keychain.
        let query = KeychainItem.keychainQuery(accessGroup: accessGroup,
                                               secClass: secClass,
                                               account: account,
                                               server: server,
                                               keyChainOperation: .delete)
        let status = SecItemDelete(query as CFDictionary)
        debugPrint(KeychainItem.performedQueryStatus(status))
    }

    // MARK: Convenience
    private static func keychainQuery(accessGroup: String,
                                      secClass: String,
                                      account: String,
                                      server: String?,
                                      keyChainOperation: KeychainOperation) -> [String: AnyObject] {
        var query = [String: AnyObject]()
        query[kSecClass as String] = secClass as AnyObject? // kSecClassGenericPassword
        query[kSecAttrAccount as String] = account as AnyObject?
        // query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        if let server = server { query[kSecAttrServer as String] = server as AnyObject? }
        if keyChainOperation == .read {
            query[kSecMatchLimit as String] = kSecMatchLimitOne
            query[kSecReturnAttributes as String] = kCFBooleanTrue
            query[kSecReturnData as String] = kCFBooleanTrue
        } else if keyChainOperation == .add {
            // TODOs: add some another keys
        } else if keyChainOperation == .update {
            // TODOs: add some another keys
        } else if keyChainOperation == .delete {
            // TODOs: add some another keys
        }
        return query
    }

    private static func performedQueryStatus(_ status: OSStatus) -> KeychainError {
        // Check the return status and throw an error if appropriate.
        if status == errSecSuccess {
            LogHandler.reportLogOnConsole(nil, "success")
            return KeychainError.noError
        } else {
            LogHandler.reportLogOnConsole(nil, "fail, something went wrong")
            return KeychainError.error
        }
    }

    static func getAllKeyChainItemsOfClass(_ secClass: String) -> [String: String] {
        let query: [String: Any] = [
            kSecClass as String: secClass,
            kSecReturnData as String: kCFBooleanTrue ?? true,
            kSecReturnAttributes as String: kCFBooleanTrue ?? true,
            kSecReturnRef as String: kCFBooleanTrue ?? true,
            kSecMatchLimit as String: kSecMatchLimitAll
            // kSecAttrAccessGroup as String : KeychainItem.bundleIdentifier
        ]

        var result: AnyObject?
        let lastResultCode = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }

        var values = [String: String]()

        if lastResultCode == noErr {
            //  let array = result as? Array<Dictionary<String, Any>>
            if let arr = result as? NSArray {
                for itemDict in arr {
                    if let item = itemDict as? NSDictionary,
                       let key = item[kSecAttrAccount as String] as? String,
                       let value = item[kSecValueData as String] as? Data {
                        values[key] = String(data: value, encoding: .utf8)
                    }
                }
            }
        }
        return values
    }

    static func wipeOutStoredCredential() {
        let secItemClasses = [kSecClassGenericPassword,
                              kSecClassInternetPassword,
                              kSecClassCertificate,
                              kSecClassKey,
                              kSecClassIdentity]
        for secItemClass in secItemClasses {
            let dictionary = [kSecClass as String: secItemClass]
            SecItemDelete(dictionary as CFDictionary)
        }
    }

    static func appUserDefaults() -> UserDefaults? {
        if let sharedDefaults = UserDefaults.init(suiteName: "group.CTZ.app") {
            return sharedDefaults
        }
        return nil
    }

    static func getDataFromPacket(packet: [PasswordDetails]) -> Data? {
        do {
            let data = try PropertyListEncoder.init().encode(packet)
            return data
        } catch let error as NSError {
            LogHandler.reportLogOnConsole(nil, error.localizedDescription)
        }
        return nil
    }

    static func getPacketFromData(data: Data) -> [PasswordDetails]? {
        do {
            let packet = try PropertyListDecoder.init().decode([PasswordDetails].self, from: data)
            return packet
        } catch let error as NSError {
            LogHandler.reportLogOnConsole(nil, error.localizedDescription)
        }

        return nil
    }
}

extension KeychainItem {
    // Get and Set Current User Email. Set nil to delete.
    static var savedEmail: String? {
        get { return KeychainItem.init(accessGroup: "", secClass: "", account: "").readItem() }
        set {
            guard let value = newValue else { return KeychainItem.init(accessGroup: "", secClass: "", account: "").deleteItem() }
            return KeychainItem.init(accessGroup: "", secClass: "", account: "").saveItem(value)
        }
    }
}

// MARK: - Passwords
struct Passwords: Codable {
    let status, message: String?
    let data: [PasswordDetails]?
}

// MARK: - Password
struct Password: Codable {
    let status, message: String?
    let data: PasswordDetails?
}

// MARK: - PasswordDetails
struct PasswordDetails: Codable {
    let userID: Int?
    let userName, updatedAt, createdAt, serverName: String?
    let id: Int?
    var password: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case userName = "user_name"
        case password
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
        case serverName = "server_name"
    }
}

struct DeleteResponseModel: Codable {
    let status: Int?
    let message: String?
}

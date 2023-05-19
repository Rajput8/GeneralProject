import Foundation

struct StoredKeys<Value> {
    let name: String
    init(_ name: Keyname) {
        self.name = name.rawValue
    }

    static var array: StoredKeys<[UserLogin]> { return StoredKeys<[UserLogin]>(Keyname.email) }
    static var userId: StoredKeys<String> { return StoredKeys<String>(Keyname.userId) }
    static var loggedUserData: StoredKeys<UserLogin> { return StoredKeys<UserLogin>(Keyname.loggedUserData) }
}

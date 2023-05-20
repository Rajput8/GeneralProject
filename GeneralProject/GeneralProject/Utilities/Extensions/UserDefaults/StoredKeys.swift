import Foundation

struct StoredKeys<Value> {
    let name: String
    init(_ name: Keyname) {
        self.name = name.rawValue
    }

    static var userId: StoredKeys<String> { return StoredKeys<String>(Keyname.userId) }
}

import UIKit

extension UserDefaults {
    struct Key<Value> {
        let name: String
        init(_ name: Keyname) {
            self.name = name.rawValue
        }
    }

    enum Keyname: String {
        case userId
        case name
        case email
    }

    subscript<V: Codable>(key: Key<V>) -> V? {
        get {
            guard let data = self.data(forKey: key.name) else { return nil }
            return try? JSONDecoder().decode(V.self, from: data)
        }
        set {
            guard let value = newValue, let data = try? JSONEncoder().encode(value) else {
                self.set(nil, forKey: key.name)
                return
            }
            self.set(data, forKey: key.name)
        }
    }

    subscript(key: Key<URL>) -> URL? {
        get { return self.url(forKey: key.name) }
        set { self.set(newValue, forKey: key.name) }
    }

    subscript(key: Key<String>) -> String? {
        get { return self.string(forKey: key.name) }
        set { self.set(newValue, forKey: key.name) }
    }

    subscript(key: Key<Data>) -> Data? {
        get { return self.data(forKey: key.name) }
        set { self.set(newValue, forKey: key.name) }
    }

    subscript(key: Key<Bool>) -> Bool {
        get { return self.bool(forKey: key.name) }
        set { self.set(newValue, forKey: key.name) }
    }

    subscript(key: Key<Int>) -> Int {
        get { return self.integer(forKey: key.name) }
        set { self.set(newValue, forKey: key.name) }
    }

    subscript(key: Key<Float>) -> Float {
        get { return self.float(forKey: key.name) }
        set { self.set(newValue, forKey: key.name) }
    }

    subscript(key: Key<Double>) -> Double {
        get { return self.double(forKey: key.name) }
        set { self.set(newValue, forKey: key.name) }
    }

    func resetUserDefaults() {
        let dictionary = self.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            self.removeObject(forKey: key)
        }
    }

    func deleteData(key: Keyname) {
        self.removeObject(forKey: key.rawValue)
    }
}

extension UserDefaults.Key {
    typealias Key = UserDefaults.Key
    // static let test = Key<Bool>("keyname")
    static var test: Key<Bool> { return Key<Bool>(UserDefaults.Keyname.userId) }
    static var array: Key<[Person]> { return Key<[Person]>(UserDefaults.Keyname.email) }
}

// -----------------------------------------------------------------------------
// TEST/USUAGE

struct Person: Codable {
    var name: String
    var age: Int
}
/*
 UserDefaults.standard[.test] = true
 let test = UserDefaults.standard[.test]
 print(test) // true
 UserDefaults.standard[.array] = [
 Person(name: "Taro", age: 10),
 Person(name: "Jiro", age: 8)
 ]
 let array = UserDefaults.standard[.array]
 print(array!) // [Person(name: "Taro", age: 10), Person(name: "Jiro", age: 8)]
 UserDefaults.standard.deleteData(key: .userId)
 UserDefaults.standard.resetUserDefaults()
 */

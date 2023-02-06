import Foundation

extension Collection {
    subscript(optional index: Index) -> Iterator.Element? {
        return self.indices.contains(index) ? self[index] : nil
    }

    // Usuage
    /*
     let arr = ["foo", "bar"]
     let str1 = arr[optional: 1] // --> str1 is now Optional("bar")
     if let str2 = arr[optional: 2] {
     print(str2) // --> this still wouldn't run
     } else {
     print("No string found at that index") // --> this would be printed
     }
     */
}

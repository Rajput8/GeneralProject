import UIKit

class ViewController: UIViewController {

    // MARK: Outlets

    // MARK: Variables

    // MARK: Controller's Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
    }

    // MARK: IB's Action

    // MARK: Helper's Method
}

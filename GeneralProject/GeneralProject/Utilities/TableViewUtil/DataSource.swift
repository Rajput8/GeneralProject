import Foundation
import UIKit

class DataSource<CELL: UITableViewCell, T>: NSObject, UITableViewDataSource {

    private var cellIdentifier: String!
    private var items: [T]!
    var configureCell: (CELL, T) -> Void = {_, _ in }

    init(_ cellIdentifier: String, _ items: [T], _ configureCell: @escaping (CELL, T) -> Void) {
        self.cellIdentifier = cellIdentifier
        self.items = items
        self.configureCell = configureCell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CELL else {
            return CELL()
        }
        let item = self.items[indexPath.row]
        self.configureCell(cell, item)
        return cell
    }
}

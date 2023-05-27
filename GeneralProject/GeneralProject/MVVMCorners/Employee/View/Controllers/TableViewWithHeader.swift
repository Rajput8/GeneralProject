import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class TableViewWithHeader: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var employeeTableView: UITableView! {
        didSet { employeeTableView.registerCellFromNib(cellID: EmployeeCell.identifier) }
    }

    // MARK: Variables
    fileprivate lazy var viewModel = { RxEmployeeViewModel() }()
    fileprivate let disposeBag = DisposeBag()

    // MARK: Controller's Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewDidLoadSetup()
    }

    // MARK: IB's Action

    // MARK: Helper's Method
    fileprivate func viewDidLoadSetup() {
        dataBindingHandler()
    }

    fileprivate func viewWillAppearSetup() { }

    fileprivate func dataBindingHandler() {
        // Get employees data
        viewModel.getListFromJson()
        viewModel.categoriesListData.bind(to: employeeTableView.rx.items(dataSource: dataSource())).disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate

// MARK: - UITableViewDataSource

// MARK: - RxDataSources
extension TableViewWithHeader {
    func dataSource() -> RxTableViewSectionedReloadDataSource<Category> {
        return RxTableViewSectionedReloadDataSource(
            configureCell: { _, tableView, indexPath, data in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeCell.identifier,
                                                               for: indexPath) as? EmployeeCell else {
                    fatalError("xib does not exists")
                }
                cell.productData = data
                return cell
            },
            titleForHeaderInSection: { dataSource, section -> String? in
                return dataSource[section].name ?? "Category name not available"
            },
            canEditRowAtIndexPath: { _, _ in
                return true
            },
            canMoveRowAtIndexPath: { _, _ in
                return true
            }
        )
    }
}

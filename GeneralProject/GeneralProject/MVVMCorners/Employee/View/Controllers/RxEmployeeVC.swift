import UIKit
import RxSwift
import RxCocoa

class RxEmployeeVC: UIViewController {

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
        viewModel.getEmpDataAPI()
        // rxEmployeeViewModel.uploadMediaContent()
        // Note: No longer need to
        // Connect Delegate
        // Connect Datasource
        // Implement Number of Rows
        // Implement Cell For Row
        // All these are taken care of in the reactive paradigm
        viewModel.employeesData.bind(to: employeeTableView.rx.items(cellIdentifier: EmployeeCell.identifier,
                                                                    cellType: EmployeeCell.self)) { _, data, cell in
            cell.data = data
        }.disposed(by: disposeBag)

        //        rxEmployeeViewModel.errorMessage.drive(onNext: { (errMsg) in
        //            if let errMsg {
        //                Toast.show(message: errMsg, controller: self)
        //            }
        //        }).disposed(by: disposeBag)

        viewModel.requestErrMessage.bind { errMsg in
            if let errMsg {
                Toast.show(message: errMsg, controller: self)
            }
        }.disposed(by: disposeBag)
    }
}

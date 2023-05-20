import UIKit

class EmployeesVC: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var employeeTableView: UITableView! {
        didSet {
            employeeTableView.register(EmployeeCell.nib, forCellReuseIdentifier: EmployeeCell.identifier)
        }
    }

    // MARK: Variables
    fileprivate lazy var viewModel = { EmployeesViewModel() }()
    fileprivate var dataSource: DataSource<EmployeeCell, EmployeeData>?

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
        // Reload TableView closure
        viewModel.employeesData.bind { _ in
            // Implementation without using generic tableView datasource
            DispatchQueue.main.async { self.employeeTableView.reloadData() }
            // Implementation via using generic tableView datasource
            // if using this implementation don't use datasource method and don't connect datasource or delegate
            // otherwise you'll be face crash
            // self.updateDataSource(empData)
        }
    }

    fileprivate func updateDataSource(_ empData: [EmployeeData]) {
        self.dataSource = DataSource(EmployeeCell.identifier, empData, { (cell, data) in
            cell.data = data
        })

        DispatchQueue.main.async {
            self.employeeTableView.dataSource = self.dataSource
            self.employeeTableView.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate
extension EmployeesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}

// MARK: - UITableViewDataSource
extension EmployeesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeCell.identifier,
                                                       for: indexPath) as? EmployeeCell else { fatalError("xib does not exists") }
        let employeeData = viewModel.cellForRowAt(at: indexPath)
        cell.data = employeeData
        return cell
    }
}

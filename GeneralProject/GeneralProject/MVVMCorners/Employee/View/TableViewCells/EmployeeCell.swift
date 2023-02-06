import UIKit

class EmployeeCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var empImg: UIImageView!
    @IBOutlet var empIdLbl: UILabel!
    @IBOutlet var empNameLbl: UILabel!

    // MARK: Variables
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }

    var employeeData: EmployeeData? {
        didSet {
            empIdLbl.text = "\(employeeData?.id ?? 1)"
            empNameLbl.text = employeeData?.employeeName
        }
    }

    // MARK: Controller's Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        empIdLbl.text = nil
        empNameLbl.text = nil
    }

    // MARK: IB's Action

    // MARK: Helper's Method
    func initView() {
        // Cell view customization
        backgroundColor = .clear
        // Line separator full width
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
    }
}

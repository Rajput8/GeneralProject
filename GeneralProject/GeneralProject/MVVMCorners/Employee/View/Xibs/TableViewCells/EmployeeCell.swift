import UIKit

class EmployeeCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var empImg: UIImageView!
    @IBOutlet var empIdLbl: UILabel!
    @IBOutlet var empNameLbl: UILabel!

    // MARK: Variables
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }

    var data: EmployeeData? {
        didSet {
            empIdLbl.text = "\(data?.id ?? 1)"
            empNameLbl.text = data?.employeeName
        }
    }

    var productData: Product? {
        didSet {
            empIdLbl.text = productData?.name ?? "Product name not available"
            let location = productData?.location ?? "Product location not available"
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: location)
            attributedString.setColorFontForText(["Block", "Row", "Shelf"], [.black, .orange, .yellow])
            empNameLbl.attributedText = attributedString
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

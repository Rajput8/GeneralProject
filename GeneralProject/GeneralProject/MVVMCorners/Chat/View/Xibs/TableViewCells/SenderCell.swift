import UIKit

class SenderCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet var msgLbl: UILabel!

    // MARK: Variables
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }

    var data: ChatData? {
        didSet {

        }
    }

    // MARK: Controller's Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        msgLbl.text = nil
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

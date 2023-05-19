import UIKit
import RxSwift
import RxCocoa

class ChatVC: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerCellFromNib(cellID: SenderCell.identifier)
            tableView.registerCellFromNib(cellID: ReceiverCell.identifier)
        }
    }

    // MARK: Variables
    fileprivate lazy var viewModel = { ChatViewModel() }()
    fileprivate let disposeBag = DisposeBag()

    // MARK: Controller's Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewDidLoadSetup()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.disconnectToSocket()
    }

    // MARK: IB's Action
    @IBAction func didTapSendMessage(_ sender: UIButton) {
        viewModel.sendMessage()
    }

    // MARK: Helper's Method
    fileprivate func viewDidLoadSetup() {
        dataBindingHandler()
    }

    fileprivate func viewWillAppearSetup() { }

    fileprivate func dataBindingHandler() {
        // Get chat data
        viewModel.getChatDataAPI()
        viewModel.configureSocketIO()

        // Bind data with tableview's cell
        //        chatViewModel.chatData.bind(to: tableView.rx.items(cellIdentifier: SenderCell.identifier,
        //                                                           cellType: SenderCell.self)) { _, messageData, cell in
        //            cell.messageData = messageData
        //        }.disposed(by: disposeBag)
        //
        //        chatViewModel.chatData.bind(to: tableView.rx.items(cellIdentifier: ReceiverCell.identifier,
        //                                                           cellType: ReceiverCell.self)) {_, messageData, cell in
        //            cell.messageData = messageData
        //        }.disposed(by: disposeBag)
    }
}

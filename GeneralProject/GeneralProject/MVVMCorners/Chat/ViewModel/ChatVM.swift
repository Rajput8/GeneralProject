import Foundation
import RxRelay
import RxSwift
import RxCocoa
import SocketIO

class ChatViewModel {

    enum MessageType: Int {
        case text = 1
        case video = 2
        case image = 3
        case file = 4
    }

    var responseData = BehaviorRelay<[ChatData]>(value: [])
    var isRequestHasErr = BehaviorRelay<Bool?>(value: nil)
    var requestErrMessage = BehaviorRelay<String?>(value: nil)
    var disposeBag = DisposeBag()

    var errorMessage: Driver<String?> {
        return requestErrMessage.asDriver()
    }

    func configureSocketIO() {
        SocketUtil.shared.establishConnection(params: ["reciever_id": 4, "userId": 5]) { response in
            self.handleReceiveMessageViaSocket(response)
        }
    }

    func disconnectToSocket() {
        SocketUtil.shared.disconnect(params: [:])
    }

    func sendMessage() {
        var newMessage: Message?
        let message = "new message using socket.io"
        newMessage = Message(
            userId: 5,
            recieverId: 4,
            threadId: 9,
            messageType: MessageType.text.rawValue,
            messageText: message,
            repliedToMessageId: 0
        )

        if let newMessage {
            LogHandler.shared.reportLogOnConsole(nil, "messageParmas is: \(newMessage)")
            SocketUtil.shared.sendMessage(message: newMessage) {_ in }
        }
    }

    fileprivate func handleReceiveMessageViaSocket(_ response: [String: Any]) {
        let data = response["data"] as? [String: Any] ?? [:]
        if let messageData = SocketUtil.shared.jsonData(from: data) {
            do {
                let message = try JSONDecoder().decode(ChatData.self, from: messageData)
                LogHandler.shared.reportLogOnConsole(nil, "userModel is: \(message)")
            } catch let error {
                LogHandler.shared.reportLogOnConsole(nil, "Something happen wrong here...\(error)")
            }
        }
    }

    func getChatDataAPI() {
        let requestParams = APIRequestParams(.login, .post)
        SessionDataTask.dataTask(type: ChatResponse.self, requestParams) { response in
            switch response {
            case .success(let resp):
                guard let data = resp.data else { return }
                self.isRequestHasErr.accept(false)
                self.responseData.accept(data)
                self.configureSocketIO()
            case .failure(let error):
                self.isRequestHasErr.accept(true)
                self.requestErrMessage.accept(error.localizedDescription)
            }
        }
    }
}

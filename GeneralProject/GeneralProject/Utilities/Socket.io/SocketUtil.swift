import UIKit
import Foundation
import SocketIO

class SocketUtil {

    static var shared = SocketUtil()
    fileprivate var manager: SocketManager?
    fileprivate var socket: SocketIOClient?

    func establishConnection(params: [String: Int], _ completion: @escaping (_ result: [String: Any]) -> Void) {
        guard let url = URL(string: SocketEndpoints.host.urlComponent()) else { return }
        manager = SocketManager(socketURL: url, config: [.log(true), .compress])
        // socket = manager.socket(forNamespace: "/**********")
        guard let socket = manager?.defaultSocket else { return }
        socket.manager?.reconnects = true
        // Connection established.
        socket.once(clientEvent: .connect) { (data, _) in
            switch socket.status {
            case .connected:
                LogHandler.reportLogOnConsole(nil, "socket connected..")
                if let jsonData = try? JSONEncoder().encode(params) {
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        LogHandler.reportLogOnConsole(nil, "jsonString is: \(jsonString)")
                        self.connectUser(param: jsonString) { }
                        socket.removeAllHandlers()
                        // self.joinedUsersList({ response in completion(response) })
                        self.receiveMessage { response in
                            completion(response)
                        }
                    }
                }
            default: break
            }
        }

        // Connection disconected.
        socket.on(clientEvent: .disconnect) { (_, _) in
            LogHandler.reportLogOnConsole(nil, "socket disconnect \n")
        }

        // Error in connection.
        socket.once(clientEvent: .error) { (data, _) in
            LogHandler.reportLogOnConsole(nil, "connection error \n")
            LogHandler.reportLogOnConsole(nil, "data is: \(data)")
        }
        socket.connect()
    }

    func connectUser(param: String, _ completion: () -> Void) {
        guard let socket = manager?.defaultSocket else { return }
        socket.emit(SocketEndpoints.connectUser.urlComponent(), param)
        completion()
    }

    fileprivate func joinedUsersList(_ completion: @escaping (_ response: [String: Any]) -> Void) {
        guard let socket = manager?.defaultSocket else { return }
        socket.on(SocketEndpoints.joinedUsersList.urlComponent()) { (resp, _) in
            if let responseObject = resp.first as? [String: Any] {
                completion(responseObject)
            }
        }
    }

    func sendMessage(message: Message, _ completion: @escaping (_ success: Bool) -> Void) {
        guard let socket = manager?.defaultSocket else { return }
        if let jsonData = try? JSONEncoder().encode(message) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                LogHandler.reportLogOnConsole(nil, "jsonString is: \(jsonString)")
                socket.emit( SocketEndpoints.sendMessage.urlComponent(), jsonString) {
                    completion(true)
                }
            }
        }
    }

    func receiveMessage(_ completion: @escaping (_ response: [String: Any]) -> Void) {
        guard let socket = manager?.defaultSocket else { return }
        socket.on(SocketEndpoints.receiveMessage.urlComponent()) { (resp, _) in
            if let responseObject = resp.first as? [String: Any] {
                completion(responseObject)
            }
        }
    }

    func disconnect(params: [String: Any]) {
        guard let socket = manager?.defaultSocket else { return }
        let dict = ParamsDataUtil.stringAnyDictToStringDict(params)
        if let jsonData = try? JSONEncoder().encode(dict) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                LogHandler.reportLogOnConsole(nil, "jsonString is: \(jsonString)")
                socket.emit(SocketEndpoints.exitUser.urlComponent(), jsonString) {
                    let status = socket.status
                    LogHandler.reportLogOnConsole(nil, "socket staus is: \(status)")
                    socket.removeAllHandlers()
                    socket.manager?.reconnects = false
                    socket.disconnect()
                    socket.manager?.didDisconnect(reason: "did disconnected")
                }
            }
        }
    }

    func exitUser(nickname: String, _ completion: () -> Void) {
        guard let socket = manager?.defaultSocket else { return }
        socket.emit(SocketEndpoints.exitUser.urlComponent(), nickname)
        completion()
    }

    func jsonData(from object: Any) -> Data? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else { return nil }
        return data
    }
}

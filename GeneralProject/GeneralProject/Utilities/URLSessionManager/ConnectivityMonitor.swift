import Network

enum Reachable {
    case yes, not
}

enum Connection {
    case cellular, loopback, wifi, wiredEthernet, other
}

class Monitor {

    private let monitor: NWPathMonitor =  NWPathMonitor()

    init() {
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
    }
}

extension Monitor {
    func startMonitoring( callBack: @escaping (_ connection: Connection, _ rechable: Reachable) -> Void ) {
        monitor.pathUpdateHandler = { path in
            let reachable = (path.status == .unsatisfied || path.status == .requiresConnection)  ? Reachable.not  : Reachable.yes
            if path.availableInterfaces.count == 0 {
                return callBack(.other, .not)
            } else if path.usesInterfaceType(.wifi) {
                return callBack(.wifi, reachable)
            } else if path.usesInterfaceType(.cellular) {
                return callBack(.cellular, reachable)
            } else if path.usesInterfaceType(.loopback) {
                return callBack(.loopback, reachable)
            } else if path.usesInterfaceType(.wiredEthernet) {
                return callBack(.wiredEthernet, reachable)
            } else if path.usesInterfaceType(.other) {
                return callBack(.other, reachable)
            }
        }
    }

    public static func getCurrentConnectivityStatus(_ connection: Connection, reachable: Reachable) -> Reachable {
        return reachable
    }
}

extension Monitor {
    func cancel() {
        monitor.cancel()
    }
}

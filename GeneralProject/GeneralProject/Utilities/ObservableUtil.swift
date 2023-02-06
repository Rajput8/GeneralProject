import Foundation

// ObservableUtil class for data binding between view and view model using Boxing technique.
class ObservableUtil<T> {
    typealias Listener = (T) -> Void
    private var listener: Listener?

    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func bind(listener: Listener?) {
        listener?(value)
        self.listener = listener
    }
}

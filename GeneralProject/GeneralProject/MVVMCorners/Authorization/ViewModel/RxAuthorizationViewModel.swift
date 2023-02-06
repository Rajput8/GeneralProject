import Foundation
import RxCocoa
import RxSwift

class RxAuthorizationViewModel {

    // Create subjects/observable
    // BehaviorRelay - RxCocoa
    // DisposeBag - RxSwift
    // if data type not set optional, you'll be face error - No exact matches in call to instance method 'bind'
    let emailSubject = BehaviorRelay<String?>(value: "")
    let passwordSubject = BehaviorRelay<String?>(value: "")
    let disposeBag = DisposeBag()

    // Add this new variable
    var isValidEmail: Observable<Bool> {
        return emailSubject.map { $0!.isEmpty }
    }
}

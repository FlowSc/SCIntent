
import UIKit
import Foundation
import RxSwift
import RxCocoa


public protocol ModelState {}

public protocol Intent {
    
    associatedtype State: ModelState
    
    var disposeBag: DisposeBag { get }
    var stateObserver: PublishRelay<State> { get }
    func bind(to vc: IntentViewController<Self>)
    
}

public extension Intent {
    
    func bind(to vc: IntentViewController<Self>) {
        stateObserver.observeOn(MainScheduler.instance)
            .subscribe(onNext: { (state) in
            vc.renderBy(state)
            }).disposed(by: disposeBag)
    }
}

open class IntentViewController<I: Intent>: UIViewController {
    
    public var disposeBag = DisposeBag()
    
    public var intent: I? {
        didSet {
            guard let intent = intent else { return }
            bind(intent)
            intent.bind(to: self)
            setLayout()
        }
    }
    
    open func renderBy(_ state: I.State) {}
    open func bind(_ intent: I) {}
    open func setLayout() {}
    
}


protocol IntentView {
    
    associatedtype I: Intent
    
    var disposeBag: DisposeBag { get }
    
    var intent: I { get set }
    
    func renderBy(_ state: I.State)
    func bind(_ intent: I)
    func setLayout()
    
    
}


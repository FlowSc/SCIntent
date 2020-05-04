//
//  Intent.swift
//  Pods
//
//  Created by Kang Seongchan on 2020/05/04.
//

import UIKit
import RxSwift
import RxCocoa

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


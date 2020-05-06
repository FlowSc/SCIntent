//
//  IntentViewController.swift
//  Pods
//
//  Created by Kang Seongchan on 2020/05/04.
//

import UIKit
import RxSwift

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


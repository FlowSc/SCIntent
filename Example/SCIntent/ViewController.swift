//
//  ViewController.swift
//  SCIntent
//
//  Created by FlowSc on 05/04/2020.
//  Copyright (c) 2020 FlowSc. All rights reserved.
//

import UIKit
import SCIntent
import RxSwift
import RxCocoa

enum CounterState: ModelState { // Declare Model State
    case valueChanged(Int)
    case mininum
    case maximum
}

struct CounterIntent: Intent { // Declare Intent, All Business Logic has to be implmented in Intent.
    
    typealias State = CounterState
    
    var disposeBag: DisposeBag = DisposeBag()
    var stateObserver: PublishRelay<CounterState> = PublishRelay<CounterState>()
    
    func valueDown(_ current: Int) {
        if current == 0 {
            stateObserver.accept(.mininum)
        } else {
            stateObserver.accept(.valueChanged(current - 1))
        }
    }
    
    func valueUp(_ current: Int) {
        if current == 10 {
            stateObserver.accept(.maximum)
        } else {
            stateObserver.accept(.valueChanged(current + 1))
        }
    }
}

class ViewController: IntentViewController<CounterIntent> { // View Controller is only binding bridge between view and intent.
    
    @IBOutlet weak var downBtn: UIButton!
    @IBOutlet weak var upBtn: UIButton!
    @IBOutlet weak var counterLb: UILabel!
    
    var currentValue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.intent = CounterIntent() //
    }
    
    override func bind(_ intent: CounterIntent) { // Bind View Controller Action and Intent's Business Logic
        downBtn.rx.tap.bind {
            intent.valueDown(self.currentValue)
        }.disposed(by: disposeBag)
        upBtn.rx.tap.bind {
            intent.valueUp(self.currentValue)
        }.disposed(by: disposeBag)
    }
    
    override func renderBy(_ state: CounterState) { // Do Presentation Logic in View Controller
        
        switch state {
        case .valueChanged(let val):
            setValue(val)
        case .mininum:
            showAlert(msg: "Counter cannot show under 0")
        case .maximum:
            showAlert(msg: "Conuter cannot show over 10")
        }
    }
    
    func setValue(_ val: Int) {
        self.currentValue = val
        self.counterLb.text = "\(val)"
    }
    
    func showAlert(msg: String) {
        
        let alertVc = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertVc.addAction(action)
        
        self.present(alertVc, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


# SCIntent

[![CI Status](https://img.shields.io/travis/FlowSc/SCIntent.svg?style=flat)](https://travis-ci.org/FlowSc/SCIntent)
[![Version](https://img.shields.io/cocoapods/v/SCIntent.svg?style=flat)](https://cocoapods.org/pods/SCIntent)
[![License](https://img.shields.io/cocoapods/l/SCIntent.svg?style=flat)](https://cocoapods.org/pods/SCIntent)
[![Platform](https://img.shields.io/cocoapods/p/SCIntent.svg?style=flat)](https://cocoapods.org/pods/SCIntent)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

SCIntent is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SCIntent'
```


## Usage


### ModelState
```swift

import SCIntent

enum CounterState: ModelState {
    case valueChanged(Int)
    case mininum
    case maximum
}


```

### Intent
```swift

import SCIntent
import RxSwift
import RxCocoa

struct CounterIntent: Intent { 

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
```

### View Controller
```swift

import SCIntent
import RxSwift
import RxCocoa

class ViewController: IntentViewController<CounterIntent> { 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.intent = CounterIntent()
    }
    
    override func bind(_ intent: CounterIntent) { // Bind View Controller Action and Intent's Business Logic
        downBtn.rx.tap.bind {
            intent.valueDown(self.currentValue)
        }.disposed(by: disposeBag)
        upBtn.rx.tap.bind {
            intent.valueUp(self.currentValue)
        }.disposed(by: disposeBag)
    }
    
    override func renderBy(_ state: CounterState) { // Do Presentation Logic by Model State
        
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


```


## Author

FlowSc, zelatool@gmail.com


## License

SCIntent is available under the MIT license. See the LICENSE file for more info.

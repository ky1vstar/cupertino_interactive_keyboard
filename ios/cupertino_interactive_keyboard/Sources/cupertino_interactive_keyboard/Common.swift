import Foundation

@discardableResult
func exchangeSelectors(_ type: AnyClass, _ firstSelector: Selector, _ secondsSelector: Selector) -> Bool {
    guard
        let firstMethod = class_getInstanceMethod(type, firstSelector),
        let secondMethod = class_getInstanceMethod(type, secondsSelector)
    else {
        return false
    }
    
    method_exchangeImplementations(firstMethod, secondMethod)
    return true
}

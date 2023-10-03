import UIKit
import Flutter

@discardableResult
func swizzleFlutterViewController() -> Bool {
  swizzleFlutterViewControllerOnce
}

private let swizzleFlutterViewControllerOnce: Bool = ({
  let type = FlutterViewController.self
  return [
    exchangeSelectors(type, NSSelectorFromString("keyboardWillChangeFrame:"), #selector(FlutterViewController.cik_keyboardWillChangeFrame)),
    exchangeSelectors(type, NSSelectorFromString("keyboardWillBeHidden:"), #selector(FlutterViewController.cik_keyboardWillBeHidden)),
    exchangeSelectors(type, NSSelectorFromString("keyboardWillShowNotification:"), #selector(FlutterViewController.cik_keyboardWillShowNotification)),
  ].contains(true)
})()

extension FlutterViewController {
  @objc
  dynamic fileprivate func cik_keyboardWillChangeFrame(_ notification: Notification?) {
    cik_keyboardWillChangeFrame(notification.map(KeyboardManager.shared.adjustKeyboardNotification(_:)))
  }
  
  @objc
  dynamic fileprivate func cik_keyboardWillBeHidden(_ notification: Notification?) {
    cik_keyboardWillBeHidden(notification.map(KeyboardManager.shared.adjustKeyboardNotification(_:)))
  }
  
  @objc
  dynamic fileprivate func cik_keyboardWillShowNotification(_ notification: Notification?) {
    cik_keyboardWillShowNotification(notification.map(KeyboardManager.shared.adjustKeyboardNotification(_:)))
  }
}

import UIKit
import Flutter

private var cachedInputAccessoryViewKey: UInt8 = 0

@discardableResult
func swizzleFlutterTextInputView() -> Bool {
  swizzleFlutterTextInputViewOnce
}

private let swizzleFlutterTextInputViewOnce: Bool = ({
  let originalSelector = #selector(getter: UIResponder.inputAccessoryView)
  let replacementSelector = #selector(getter: UIResponder.cik_inputAccessoryView)
  guard
    let type = NSClassFromString("FlutterTextInputView")
  else {
    return false
  }
  
  return exchangeSelectors(type, originalSelector, replacementSelector)
})()

extension UIResponder {
  @nonobjc
  private var cachedInputAccessoryView: UIView? {
    get {
      objc_getAssociatedObject(self, &cachedInputAccessoryViewKey) as? UIView
    }
    set {
      objc_setAssociatedObject(self, &cachedInputAccessoryViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
  
  @objc
  dynamic fileprivate var cik_inputAccessoryView: UIView? {
    if let inputView = cachedInputAccessoryView {
      return inputView
    } else if
      let vc = flutterViewController,
      let plugin = CupertinoInteractiveKeyboardPlugin.instance(for: vc)
    {
      let inputView = plugin.inputView
      inputView.layer.borderColor = UIColor.green.cgColor
      inputView.layer.borderWidth = 2
      cachedInputAccessoryView = inputView
      return inputView
    } else {
      return nil
    }
  }
  
  @nonobjc
  private var flutterViewController: FlutterViewController? {
    var parentResponder: UIResponder? = self.next
    while parentResponder != nil {
      if let viewController = parentResponder as? FlutterViewController {
        return viewController
      }
      parentResponder = parentResponder?.next
    }
    return nil
  }
}

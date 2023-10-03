import UIKit

class KeyboardManager {
  static let shared = KeyboardManager()
  private static let handledUserInfoKey = "KeyboardManagerHandledUserInfoKey"
  
  var activeScrollViews = Set<CIKScrollView>()
  var activeInputAccessoryViews = Set<CIKInputAccessoryView>()
  
  private init() {
//    [
//      UIResponder.keyboardWillChangeFrameNotification,
//      UIResponder.keyboardWillShowNotification,
//      UIResponder.keyboardWillHideNotification,
//      UIResponder.keyboardDidChangeFrameNotification,
//      UIResponder.keyboardDidShowNotification,
//      UIResponder.keyboardDidHideNotification,
//    ].forEach { name in
//      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: name, object: nil)
//    }
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardInteractiveDismissalDidBegin), name: UIResponder.keyboardInteractiveDismissalNotification, object: nil)
  }
  
  @objc
  private func keyboardWillChangeFrame(_ notification: Notification) {
  }
  
  func adjustKeyboardNotification(_ notification: Notification) -> Notification {
    print("adjustKeyboardNotification", notification.name, notification.userInfo)
    
    lazy var maxInputAccessoryHeight = activeInputAccessoryViews.map(\.intrinsicContentSize.height).max() ?? 0
    
    guard
      var userInfo = notification.userInfo,
      !((userInfo[KeyboardManager.handledUserInfoKey] as? Bool) ?? false),
      maxInputAccessoryHeight > 0
    else {
      return notification
    }
    
    func adjustRect(_ value: NSValue) -> NSValue {
      var rect = value.cgRectValue
      rect.origin.y += maxInputAccessoryHeight
      rect.size.height -= maxInputAccessoryHeight
      return NSValue(cgRect: rect)
    }
    
    userInfo[KeyboardManager.handledUserInfoKey] = true
    userInfo[UIResponder.keyboardFrameBeginUserInfoKey] = userInfo[UIResponder.keyboardFrameBeginUserInfoKey]
      .flatMap({ $0 as? NSValue }).map(adjustRect)
    userInfo[UIResponder.keyboardFrameEndUserInfoKey] = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
      .flatMap({ $0 as? NSValue }).map(adjustRect)
    
    return Notification(name: notification.name, object: notification.object, userInfo: userInfo)
  }
  
  @objc
  private func keyboardInteractiveDismissalDidBegin() {
    guard
      let gesture = activeScrollViews.map(\.panGestureRecognizer).first(where: { $0.state == .changed }),
      let gestureView = gesture.view,
      let screen = gestureView.window?.screen
    else {
      return
    }
    
    let locationInScrollView = gesture.location(in: gestureView)
    let locationInScreen = gestureView.convert(locationInScrollView, to: screen.coordinateSpace)
    
    let frame = CGRect(x: 0, y: locationInScreen.y, width: screen.bounds.width, height: screen.bounds.height - locationInScreen.y)
    
    NotificationCenter.default.post(name: UIResponder.keyboardWillChangeFrameNotification, object: screen, userInfo: [
      UIResponder.keyboardFrameBeginUserInfoKey: NSValue(cgRect: frame),
      UIResponder.keyboardFrameEndUserInfoKey: NSValue(cgRect: frame),
      //      UIKeyboardBoundsUserInfoKey: NSValue(cgRect: frame),
    ])
  }
}

private extension UIResponder {
  static let keyboardInteractiveDismissalNotification: Notification.Name = {
    if #available(iOS 12.0, *) {
      return .init(
        // UIKeyboardPrivateInteractiveDismissalDidBeginNotification
        "VUlLZXlib2FyZFByaXZhdGVJbnRlcmFjdGl2ZURpc21pc3NhbERpZEJlZ2luTm90aWZpY2F0aW9u"
          .base64Decoded
      )
    } else {
      return .init(
        // UITextEffectsWindowDidRotateNotification
        "VUlUZXh0RWZmZWN0c1dpbmRvd0RpZFJvdGF0ZU5vdGlmaWNhdGlvbg=="
          .base64Decoded
      )
    }
  }()
}

private extension String {
  var base64Decoded: String {
    Data(base64Encoded: self)
      .flatMap {
        String(data: $0, encoding: .utf8)
      }
    ?? self
  }
}

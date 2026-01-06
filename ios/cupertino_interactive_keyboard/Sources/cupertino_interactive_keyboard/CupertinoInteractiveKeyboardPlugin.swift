import Flutter
import UIKit

public class CupertinoInteractiveKeyboardPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    _ = KeyboardManager.shared
    swizzleFlutterViewController()
//     swizzleFlutterTextInputView()
    
    let channel = FlutterMethodChannel(name: "cupertino_interactive_keyboard", binaryMessenger: registrar.messenger())
    let instance = CupertinoInteractiveKeyboardPlugin()
    registrar.publish(instance)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
  
  static func instance(for registry: FlutterPluginRegistry) -> CupertinoInteractiveKeyboardPlugin? {
    registry.valuePublished(byPlugin: "CupertinoInteractiveKeyboardPlugin") as? CupertinoInteractiveKeyboardPlugin
  }
  
  private let scrollView = CIKScrollView()
  let inputView = CIKInputAccessoryView()
  private let keyboardTrackingView = CIKKeyboardTrackingView()
    
  override init() {
    super.init()
    
    scrollView.cikDelegate = self
    inputView.delegate = self
    keyboardTrackingView.delegate = self
  }
  
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "initialize":
      guard
        let args = call.arguments as? [String: Any],
        let firstTime = args["firstTime"] as? Bool
      else {
        return result(FlutterMethodNotImplemented)
      }
      
      DispatchQueue.main.async {
        if firstTime {
          self.scrollView.scrollabeRects = [:]
          self.inputView.inputAccessoryHeights = [:]
        }
        
        guard let flutterViewController = self.findFlutterViewController() else {
          return result(false)
        }
        
        [
          UIResponder.keyboardWillChangeFrameNotification,
          UIResponder.keyboardWillShowNotification,
          UIResponder.keyboardWillHideNotification,
          UIResponder.keyboardDidChangeFrameNotification,
          UIResponder.keyboardDidShowNotification,
          UIResponder.keyboardDidHideNotification,
        ].forEach { name in
          NotificationCenter.default.removeObserver(flutterViewController, name: name, object: nil)
        }
        
        if self.keyboardTrackingView.superview != flutterViewController.view {
          self.keyboardTrackingView.removeFromSuperview()
          self.keyboardTrackingView.frame = flutterViewController.view.bounds
          flutterViewController.view.addSubview(self.keyboardTrackingView)
        }
        
        if self.scrollView.superview != flutterViewController.view {
          self.scrollView.removeFromSuperview()
          self.scrollView.frame = flutterViewController.view.bounds
          flutterViewController.view.addSubview(self.scrollView)
        }

        result(true)
      }

    case "setScrollableRect":
      guard
        let args = call.arguments as? [String: Any],
        let id = args["id"] as? Int,
        let rectMap = args["rect"] as? [String: Double],
        let x = rectMap["x"],
        let y = rectMap["y"],
        let width = rectMap["width"],
        let height = rectMap["height"]
      else {
        return result(FlutterMethodNotImplemented)
      }

      DispatchQueue.main.async {
        self.scrollView.scrollabeRects[id] = CGRect(x: x, y: y, width: width, height: height)
        result(nil)
      }

    case "removeScrollableRect":
      guard
        let args = call.arguments as? [String: Any],
        let id = args["id"] as? Int
      else {
        return result(FlutterMethodNotImplemented)
      }

      DispatchQueue.main.async {
        self.scrollView.scrollabeRects[id] = nil
        result(nil)
      }

    case "setInputAccessoryHeight":
      guard
        let args = call.arguments as? [String: Any],
        let id = args["id"] as? Int,
        let height = args["height"] as? Double
      else {
        return result(FlutterMethodNotImplemented)
      }

      DispatchQueue.main.async {
        self.inputView.inputAccessoryHeights[id] = height
        result(nil)
      }

    case "removeInputAccessoryHeight":
      guard
        let args = call.arguments as? [String: Any],
        let id = args["id"] as? Int
      else {
        return result(FlutterMethodNotImplemented)
      }

      DispatchQueue.main.async {
        self.inputView.inputAccessoryHeights[id] = nil
        result(nil)
      }

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
    scrollView.scrollabeRects = [:]
    inputView.inputAccessoryHeights = [:]
  }

  private func findFlutterViewController() -> FlutterViewController? {
    func checkViewController(_ viewController: UIViewController) -> FlutterViewController? {
      if
        let flutterViewController = viewController as? FlutterViewController,
        CupertinoInteractiveKeyboardPlugin.instance(for: flutterViewController) === self
      {
        return flutterViewController
      } else {
        return nil
      }
    }

    func findInViewController(_ viewController: UIViewController) -> FlutterViewController? {
      if let flutterViewController = checkViewController(viewController) {
        return flutterViewController
      }

      for child in viewController.children {
        if let flutterViewController = findInViewController(child) {
          return flutterViewController
        }
      }

      return nil
    }

    func findInWindows(_ windows: [UIWindow]) -> FlutterViewController? {
      for window in windows {
        if let flutterViewController = window.rootViewController.flatMap(findInViewController(_:)) {
          return flutterViewController
        }
      }
      return nil
    }

    if #available(iOS 13.0, *) {
      for case let windowScene as UIWindowScene in UIApplication.shared.connectedScenes {
        if let viewController = findInWindows(windowScene.windows) {
          return viewController
        }
      }
      return nil
    } else {
      return findInWindows(UIApplication.shared.windows)
    }
  }
}

extension CupertinoInteractiveKeyboardPlugin: CIKScrollViewDelegate {
  func cikScrollView(_ scrollView: CIKScrollView, didMoveToWindow window: UIWindow?) {
    if window != nil {
      KeyboardManager.shared.activeScrollViews.insert(scrollView)
    } else {
      KeyboardManager.shared.activeScrollViews.remove(scrollView)
    }
  }
}

extension CupertinoInteractiveKeyboardPlugin: CIKInputAccessoryViewDelegate {
  func cikInputAccessoryView(_ inputAccessoryView: CIKInputAccessoryView, didMoveToWindow window: UIWindow?) {
    if window != nil {
      KeyboardManager.shared.activeInputAccessoryViews.insert(inputAccessoryView)
    } else {
      KeyboardManager.shared.activeInputAccessoryViews.remove(inputAccessoryView)
    }
  }
}

extension CupertinoInteractiveKeyboardPlugin: CIKKeyboardTrackingViewDelegate {
  func cikKeyboardTrackingView(_ keyboardTrackingView: CIKKeyboardTrackingView, didUpdateKeyboardHeight height: CGFloat) {
    findFlutterViewController()?.setPhysicalViewInsetBottom(height)
  }
}

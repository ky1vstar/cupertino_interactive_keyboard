import UIKit

protocol CIKScrollViewDelegate: AnyObject {
  func cikScrollView(_ scrollView: CIKScrollView, didMoveToWindow window: UIWindow?)
}

class CIKScrollView: UIScrollView, UIGestureRecognizerDelegate {
  weak var cikDelegate: CIKScrollViewDelegate?
  var scrollabeRects = [Int: CGRect]()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }
  
  private func commonInit() {
    autoresizingMask = [.flexibleWidth, .flexibleHeight]
    keyboardDismissMode = .interactiveWithAccessory
    contentSize = CGSize(width: 10, height: 10000)
    panGestureRecognizer.cancelsTouchesInView = false
    isHidden = true
  }
  
  override func didMoveToWindow() {
    super.didMoveToWindow()
    cikDelegate?.cikScrollView(self, didMoveToWindow: window)
  }
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    if let superview {
      superview.addGestureRecognizer(panGestureRecognizer)
    }
  }
  
  override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    lazy var location = gestureRecognizer.location(in: gestureRecognizer.view)
    return gestureRecognizer == panGestureRecognizer
    && super.gestureRecognizerShouldBegin(gestureRecognizer)
    && scrollabeRects.contains(where: { $0.value.contains(location) })
  }
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return false
  }
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return false
  }
}

import UIKit

class CIKInputAccessoryView: UIView {
  var inputAccessoryHeights = [Int: Double]() {
    didSet {
      heightConstraint.constant = inputAccessoryHeights.values.max() ?? 0
    }
  }
  
  private lazy var heightConstraint = heightAnchor.constraint(equalToConstant: 0)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: UIView.noIntrinsicMetric, height: heightConstraint.constant)
  }
  
  private func commonInit() {
    translatesAutoresizingMaskIntoConstraints = false
    heightConstraint.isActive = true
  }
  
  override func didMoveToWindow() {
    super.didMoveToWindow()
    if window != nil {
      KeyboardManager.shared.activeInputAccessoryViews.insert(self)
    } else {
      KeyboardManager.shared.activeInputAccessoryViews.remove(self)
    }
  }
  
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    return nil
  }
}

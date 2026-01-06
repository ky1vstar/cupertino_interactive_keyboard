import UIKit

protocol CIKKeyboardTrackingViewDelegate: AnyObject {
  func cikKeyboardTrackingView(_ keyboardTrackingView: CIKKeyboardTrackingView, didUpdateKeyboardHeight height: CGFloat)
}

class CIKKeyboardTrackingView: UIView {
  weak var delegate: CIKKeyboardTrackingViewDelegate?
  
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
    isHidden = true
    
    
    if #available(iOS 15.0, *) {
      if #available(iOS 17.0, *) {
        // keyboardLayoutGuide.keyboardDismissPadding = 50
        keyboardLayoutGuide.usesBottomSafeArea = false
      }
      
      let keyboardView = KeyboardView { [weak self] height in
        guard let self else { return }
        self.delegate?.cikKeyboardTrackingView(self, didUpdateKeyboardHeight: height)
      }
      addSubview(keyboardView)

      NSLayoutConstraint.activate([
        keyboardView.leftAnchor.constraint(equalTo: keyboardLayoutGuide.leftAnchor),
        keyboardView.rightAnchor.constraint(equalTo: keyboardLayoutGuide.rightAnchor),
        keyboardView.topAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor),
        keyboardView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.bottomAnchor),
      ])
    }
  }
}

extension CIKKeyboardTrackingView {
  private class KeyboardView: UIView {
    private let heightUpdateHandler: (CGFloat) -> ()
    private var previousHeight: CGFloat = 0
    private var displayLink: CADisplayLink?
    
    init(heightUpdateHandler: @escaping (CGFloat) -> ()) {
      self.heightUpdateHandler = heightUpdateHandler
      super.init(frame: .zero)
      translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToWindow() {
      super.didMoveToWindow()

      if window != nil {
        displayLink = CADisplayLink(target: self, selector: #selector(onDisplayLink))
        displayLink?.add(to: .main, forMode: .common)
      } else {
        displayLink?.invalidate()
        displayLink = nil
      }
    }

    @objc private func onDisplayLink() {
      let height = (layer.presentation() ?? layer).frame.height
      if height != previousHeight {
        previousHeight = height
        heightUpdateHandler(height)
      }
    }
  }
}

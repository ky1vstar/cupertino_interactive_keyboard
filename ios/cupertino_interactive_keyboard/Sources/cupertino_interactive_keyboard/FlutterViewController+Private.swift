import UIKit
import Flutter

private let setTargetViewInsetBottomSelector = NSSelectorFromString("setTargetViewInsetBottom:")
private let ensureViewportMetricsIsCorrectSelector = NSSelectorFromString("ensureViewportMetricsIsCorrect")

extension FlutterViewController {
  private var flutterScreenIfLoaded: UIScreen? {
    viewIfLoaded?.window?.windowScene?.screen
  }
  
  func setPhysicalViewInsetBottom(_ bottom: CGFloat) {
    guard let screen = flutterScreenIfLoaded else { return }
    
    perform(setTargetViewInsetBottomSelector, with: bottom * screen.scale)
    perform(ensureViewportMetricsIsCorrectSelector)
  }
}

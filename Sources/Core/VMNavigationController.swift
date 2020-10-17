//
//  VMNavigationController.swift
//  Koinu
//
//  Created by max on 2020/9/11.
//  Copyright © 2020 max. All rights reserved.
//

#if canImport(UIKit)

import UIKit

@objc public protocol VMNavigationCustomizableBackItem {
  
  @objc optional func customBackBarButtonItem(_ target: Any?, action: Selector) -> UIBarButtonItem
}

private func safeUnwrapViewController(viewController: UIViewController?) -> UIViewController? {
  if viewController is VMContainerViewController {
    return (viewController as! VMContainerViewController).contentViewController
  }
  return viewController
}

private func safeWrapViewController(viewController: UIViewController, navigationBarClass: AnyClass?) -> UIViewController {
  return safeWrapViewController(viewController: viewController, navigationBarClass: navigationBarClass, hasPlaceholderViewController: false)
}

private func safeWrapViewController(viewController: UIViewController, navigationBarClass: AnyClass?, hasPlaceholderViewController: Bool) -> UIViewController {
  if !(viewController is VMContainerViewController) {
    return VMContainerViewController.containerViewController(viewController, navigationBarClass: navigationBarClass, hasPlaceholderViewController: hasPlaceholderViewController)
  }
  return viewController
}

private func safeWrapViewController(viewController: UIViewController, navigationBarClass: AnyClass?, hasPlaceholderViewController: Bool, backBarButtonItem: UIBarButtonItem?, title: String?) -> UIViewController {
  if !(viewController is VMContainerViewController) {
    return VMContainerViewController.containerViewController(viewController, navigationBarClass: navigationBarClass, hasPlaceholderViewController: hasPlaceholderViewController, backBarButtonItem: backBarButtonItem, title: title)
  }
  return viewController
}

open class VMNavigationController: UINavigationController {
  
  public typealias AnimationHandle = (Bool) -> ()
  
  /// 是否使用系统原生样式的返回按钮，默认值为 `false`
  public var useSystemBackBarButtonItem: Bool = false
  
  /// 每个独立的 `navigation bar` 是否使用 `root navigation bar` 的样式，默认值为 `false`
  public var transferNavigationBarAttributes: Bool = false
  
  public var vmVisibleViewController: UIViewController? {
    let superVisibleViewController = super.visibleViewController
    return safeUnwrapViewController(viewController: superVisibleViewController)
  }
  
  public var vmTopViewController: UIViewController? {
    let superTopViewController = super.topViewController
    return safeUnwrapViewController(viewController: superTopViewController)
  }
  
  public var vmViewControllers: [UIViewController] {
    return super.viewControllers.map({ (viewController) -> UIViewController in
      return safeUnwrapViewController(viewController: viewController)!
    })
  }
  
  public weak var vmDelegate: UINavigationControllerDelegate?
  
  public var animationCallback: AnimationHandle?
  
  public init(noWrappingRootViewController: UIViewController) {
    let containerViewController = VMContainerViewController(contentViewController: noWrappingRootViewController)
    super.init(rootViewController: containerViewController)
  }
  
  public override init(rootViewController: UIViewController) {
    let wrapViewController = safeWrapViewController(viewController: rootViewController, navigationBarClass: rootViewController.navigationBarClass())
    super.init(rootViewController: wrapViewController)
  }
  
  public override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
    super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
  }
  
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func awakeFromNib() {
    super.awakeFromNib()
    self.viewControllers = super.viewControllers
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    super.delegate = self
    super.setNavigationBarHidden(true, animated: false)
    self.view.backgroundColor = UIColor.white
  }
  
  open override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  public override var delegate: UINavigationControllerDelegate? {
    set {
      self.vmDelegate = newValue
    }
    get {
      return super.delegate
    }
  }
  
  public override var shouldAutorotate: Bool {
    return self.topViewController?.shouldAutorotate ?? true
  }
  
  public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return self.topViewController?.supportedInterfaceOrientations ?? .all
  }
  
  public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
    return self.topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
  }
  
  public override func responds(to aSelector: Selector!) -> Bool {
    if super.responds(to: aSelector) {
      return true
    }
    return self.vmDelegate?.responds(to: aSelector) == true
  }
  
  public override func forwardingTarget(for aSelector: Selector!) -> Any? {
    return self.vmDelegate
  }
  
  public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
    let navigationBarClass: AnyClass? = viewController.navigationBarClass()
    
    let wrapViewController: UIViewController
    if self.viewControllers.count > 0 {
      let unwrapLastViewController = safeUnwrapViewController(viewController: self.viewControllers.last)
      
      let hasPlaceholderViewController = self.useSystemBackBarButtonItem
      let backBarButtonItem = unwrapLastViewController?.navigationItem.backBarButtonItem
      let title = unwrapLastViewController?.navigationItem.title ?? unwrapLastViewController?.title
      
      wrapViewController = safeWrapViewController(viewController: viewController, navigationBarClass: navigationBarClass, hasPlaceholderViewController: hasPlaceholderViewController, backBarButtonItem: backBarButtonItem, title: title)
    }
    else {
      wrapViewController = safeWrapViewController(viewController: viewController, navigationBarClass: navigationBarClass)
    }
    
    super.pushViewController(wrapViewController, animated: animated)
  }
  
  @discardableResult
  public override func popViewController(animated: Bool) -> UIViewController? {
    let poppedViewController = super.popViewController(animated: animated)
    return safeUnwrapViewController(viewController: poppedViewController)
  }
  
  @discardableResult
  public override func popToRootViewController(animated: Bool) -> [UIViewController]? {
    return super.popToRootViewController(animated: animated)?.map({ (viewController) -> UIViewController in
      return safeUnwrapViewController(viewController: viewController)!
    })
  }
  
  @discardableResult
  public override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
    let unwrapTopViewController = super.viewControllers.first { safeUnwrapViewController(viewController: $0) == viewController }
    
    if unwrapTopViewController != nil {
      return super.popToViewController(unwrapTopViewController!, animated: animated)?.map { (viewController) -> UIViewController in
        return safeUnwrapViewController(viewController: viewController)!
      }
    }
    
    return nil
  }
  
  public override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
    let stackViewControllers = viewControllers.enumerated().map({ (index, viewController) -> UIViewController in
      let navigationBarClass: AnyClass? = viewController.navigationBarClass()
      
      if self.useSystemBackBarButtonItem && index > 0 {
        let prevViewController = viewControllers[index - 1]
        
        let hasPlaceholderViewController = self.useSystemBackBarButtonItem
        let backBarButtonItem = prevViewController?.navigationItem.backBarButtonItem
        let title = prevViewController?.title ?? prevViewController?.navigationItem.title
        
        return safeWrapViewController(viewController: viewController, navigationBarClass: navigationBarClass, hasPlaceholderViewController: hasPlaceholderViewController, backBarButtonItem: backBarButtonItem, title: title)
      }
      else {
        return safeWrapViewController(viewController: viewController, navigationBarClass: navigationBarClass)
      }
    })
    
    super.setViewControllers(stackViewControllers, animated: animated)
  }
  
  public func remove(viewController: UIViewController) {
    self.remove(viewController: viewController, animated: false)
  }
  
  public func remove(viewController: UIViewController, animated: Bool) {
    let removedViewController = self.viewControllers.first { safeUnwrapViewController(viewController: $0) == viewController }
    
    if removedViewController != nil {
      self.viewControllers.removeAll { $0 == removedViewController }
      super.setViewControllers(self.viewControllers, animated: animated)
    }
  }
  
  public func pushViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping AnimationHandle) {
    if self.animationCallback != nil {
      self.animationCallback!(false)
    }
    
    self.animationCallback = completion
    
    self.pushViewController(viewController, animated: animated)
  }
  
  @discardableResult
  public func popViewController(animated: Bool, completion: @escaping AnimationHandle) -> UIViewController? {
    if self.animationCallback != nil {
      self.animationCallback!(false)
    }
    
    self.animationCallback = completion
    
    let poppedController = self.popViewController(animated: animated)
    if poppedController == nil && self.animationCallback != nil {
      self.animationCallback!(true)
      self.animationCallback = nil
    }
    
    return poppedController
  }
  
  @discardableResult
  public func popToViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping AnimationHandle) -> [UIViewController]? {
    if self.animationCallback != nil {
      self.animationCallback!(false)
    }
    
    self.animationCallback = completion
    
    let poppedControllers = self.popToViewController(viewController, animated: animated)
    if poppedControllers?.isEmpty == true && self.animationCallback != nil {
      self.animationCallback!(true)
      self.animationCallback = nil
    }
    
    return poppedControllers
  }
  
  @discardableResult
  public func popToRootViewController(animated: Bool, completion: @escaping AnimationHandle) -> [UIViewController]? {
    if self.animationCallback != nil {
      self.animationCallback!(false)
    }
    
    self.animationCallback = completion
    
    let poppedControllers = self.popToRootViewController(animated: animated)
    if poppedControllers?.isEmpty == true && self.animationCallback != nil {
      self.animationCallback!(true)
      self.animationCallback = nil
    }
    
    return poppedControllers
  }
  
  public func setLeftBarButtonItem(to viewController: UIViewController?) {
    let isRootViewController = viewController == safeUnwrapViewController(viewController: self.viewControllers.first)
    let hasSetLeftBarButtonItem = viewController?.navigationItem.leftBarButtonItem != nil
    
    if !self.useSystemBackBarButtonItem, !isRootViewController, !hasSetLeftBarButtonItem {
      if viewController?.responds(to: #selector(VMNavigationCustomizableBackItem.customBackBarButtonItem(_:action:))) == true {
        viewController?.navigationItem.leftBarButtonItem = (viewController as? VMNavigationCustomizableBackItem)?.customBackBarButtonItem?(self, action: #selector(onBack(_:)))
      }
      else {
        viewController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Back", comment: ""), style: .plain, target: self, action: #selector(onBack(_:)))
      }
    }
  }
  
  @objc private func onBack(_ sender: Any) {
    self.popViewController(animated: true)
  }
}

extension VMNavigationController: UINavigationControllerDelegate {
  
  public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    let unwrapViewController = safeUnwrapViewController(viewController: viewController)!
    
    let isRootViewController = viewController == navigationController.viewControllers.first
    
    if !isRootViewController, unwrapViewController.isViewLoaded {
      let hasSetLeftBarButtonItem = unwrapViewController.navigationItem.leftBarButtonItem != nil
      
      if hasSetLeftBarButtonItem && unwrapViewController.vm.disableInteractivePop == nil {
        unwrapViewController.vm.disableInteractivePop = true
      }
      else if unwrapViewController.vm.disableInteractivePop == nil {
        unwrapViewController.vm.disableInteractivePop = false
      }
      
      self.setLeftBarButtonItem(to: unwrapViewController)
    }
    
    if self.vmDelegate?.responds(to: #selector(navigationController(_:willShow:animated:))) == true {
      self.vmDelegate!.navigationController!(navigationController, willShow: unwrapViewController, animated: animated)
    }
  }
  
  public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    let unwrapViewController = safeUnwrapViewController(viewController: viewController)!
    
    let isRootViewController = viewController == navigationController.viewControllers.first
        
    if unwrapViewController.vm.disableInteractivePop == true {
      self.interactivePopGestureRecognizer?.delegate = nil
      self.interactivePopGestureRecognizer?.isEnabled = false
    }
    else {
      self.interactivePopGestureRecognizer?.delegate = self
      self.interactivePopGestureRecognizer?.isEnabled = !isRootViewController
    }
    
    VMNavigationController.attemptRotationToDeviceOrientation()
    
    if self.vmDelegate?.responds(to: #selector(navigationController(_:didShow:animated:))) == true {
      self.vmDelegate!.navigationController!(navigationController, didShow: unwrapViewController, animated: animated)
    }
    
    if self.animationCallback != nil {
      if animated {
        DispatchQueue.main.async {
          self.animationCallback!(true)
          self.animationCallback = nil
        }
      }
      else {
        self.animationCallback!(true)
        self.animationCallback = nil
      }
    }
  }
  
  public func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
    if self.vmDelegate?.responds(to: #selector(navigationControllerSupportedInterfaceOrientations(_:))) == true {
      return self.vmDelegate!.navigationControllerSupportedInterfaceOrientations!(navigationController)
    }
    return .all
  }
  
  public func navigationControllerPreferredInterfaceOrientationForPresentation(_ navigationController: UINavigationController) -> UIInterfaceOrientation {
    if self.vmDelegate?.responds(to: #selector(navigationControllerPreferredInterfaceOrientationForPresentation(_:))) == true {
      return self.vmDelegate!.navigationControllerPreferredInterfaceOrientationForPresentation!(navigationController)
    }
    return .portrait
  }
  
  public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    if self.vmDelegate?.responds(to: #selector(navigationController(_:interactionControllerFor:))) == true {
      return self.vmDelegate!.navigationController!(navigationController, interactionControllerFor: animationController)
    }
    return nil
  }
  
  public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    let unwrapFromVC = safeUnwrapViewController(viewController: fromVC)!
    let unwrapToVC = safeUnwrapViewController(viewController: toVC)!
    
    if self.vmDelegate?.responds(to: #selector(navigationController(_:animationControllerFor:from:to:))) == true {
      return self.vmDelegate!.navigationController!(navigationController, animationControllerFor: operation, from: unwrapFromVC, to: unwrapToVC)
    }
    return nil
  }
}

extension VMNavigationController: UIGestureRecognizerDelegate {
  
  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return gestureRecognizer == self.interactivePopGestureRecognizer
  }
  
  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return gestureRecognizer == self.interactivePopGestureRecognizer
  }
}

#endif

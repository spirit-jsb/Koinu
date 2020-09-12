//
//  VMContainerNavigationController.swift
//  Koinu
//
//  Created by max on 2020/9/12.
//  Copyright © 2020 max. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public class VMContainerNavigationController: UINavigationController {
  
  public override init(rootViewController: UIViewController) {
    super.init(navigationBarClass: rootViewController.navigationBarClass(), toolbarClass: nil)
    self.pushViewController(rootViewController, animated: false)
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
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    self.interactivePopGestureRecognizer?.isEnabled = false
    
    if self.vm.navigationController?.transferNavigationBarAttributes == true && self.navigationController != nil {
      self.navigationBar.isTranslucent = self.navigationController!.navigationBar.isTranslucent
      self.navigationBar.tintColor = self.navigationController!.navigationBar.tintColor
      self.navigationBar.barTintColor = self.navigationController!.navigationBar.barTintColor
      self.navigationBar.barStyle = self.navigationController!.navigationBar.barStyle
      self.navigationBar.backgroundColor = self.navigationController!.navigationBar.backgroundColor
      
      let backgroundImage = self.navigationController!.navigationBar.backgroundImage(for: .default)
      self.navigationBar.setBackgroundImage(backgroundImage, for: .default)
      let adjustment = self.navigationController!.navigationBar.titleVerticalPositionAdjustment(for: .default)
      self.navigationBar.setTitleVerticalPositionAdjustment(adjustment, for: .default)
      
      self.navigationBar.titleTextAttributes = self.navigationController!.navigationBar.titleTextAttributes
      self.navigationBar.shadowImage = self.navigationController!.navigationBar.shadowImage
      self.navigationBar.backIndicatorImage = self.navigationController!.navigationBar.backIndicatorImage
      self.navigationBar.backIndicatorTransitionMaskImage = self.navigationController!.navigationBar.backIndicatorTransitionMaskImage
    }
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    let visibleViewController = self.visibleViewController
    if visibleViewController?.vm.disableInteractivePop != true {
      let hasLeftBarButtonItem = visibleViewController?.navigationItem.leftBarButtonItem != nil
      let isNavigationBarHidden = self.isNavigationBarHidden
      visibleViewController?.vm.disableInteractivePop = isNavigationBarHidden || hasLeftBarButtonItem
    }
    if self.parent is VMContainerViewController && self.parent?.parent is VMNavigationController {
      self.vm.navigationController?.setLeftBarButtonItem(to: visibleViewController)
    }
  }
  
  public override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  public override var tabBarController: UITabBarController? {
    let tabBarController = super.tabBarController
    let navigationController = self.vm.navigationController
    
    if tabBarController != nil {
      if navigationController?.tabBarController != tabBarController {
        return tabBarController!
      }
      else {
        let isTranslucent = tabBarController!.tabBar.isTranslucent
        let verifyResult = navigationController?.vmViewControllers.verify { $0.hidesBottomBarWhenPushed } == true
        return (!isTranslucent || verifyResult) ? nil : tabBarController!
      }
    }
    
    return nil
  }
  
  public override var viewControllers: [UIViewController] {
    set {
      super.viewControllers = newValue
    }
    get {
      if self.navigationController is VMNavigationController {
        return self.vm.navigationController!.vmViewControllers
      }
      return super.viewControllers
    }
  }
  
  public override var delegate: UINavigationControllerDelegate? {
    set {
      if self.navigationController != nil {
        self.navigationController!.delegate = newValue
      }
      else {
        super.delegate = newValue
      }
    }
    get {
      return super.delegate
    }
  }
  
  public override var preferredStatusBarStyle: UIStatusBarStyle {
    return self.topViewController?.preferredStatusBarStyle ?? .default
  }
  
  public override var prefersStatusBarHidden: Bool {
    return self.topViewController?.prefersStatusBarHidden ?? false
  }
  
  public override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
    return self.topViewController?.preferredStatusBarUpdateAnimation ?? .fade
  }
  
  @available(iOS 11.0, *)
  public override var childForHomeIndicatorAutoHidden: UIViewController? {
    return self.topViewController
  }
  
  @available(iOS 11.0, *)
  public override var prefersHomeIndicatorAutoHidden: Bool {
    return self.topViewController?.prefersHomeIndicatorAutoHidden ?? false
  }
  
  @available(iOS 11.0, *)
  public override var childForScreenEdgesDeferringSystemGestures: UIViewController? {
    return self.topViewController
  }
  
  @available(iOS 11.0, *)
  public override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
    return self.topViewController?.preferredScreenEdgesDeferringSystemGestures ?? []
  }
  
  public override func allowedChildrenForUnwinding(from source: UIStoryboardUnwindSegueSource) -> [UIViewController] {
    if self.navigationController != nil {
      return self.navigationController!.allowedChildrenForUnwinding(from: source)
    }
    return super.allowedChildrenForUnwinding(from: source)
  }
  
  public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
    if self.navigationController != nil {
      self.navigationController!.pushViewController(viewController, animated: animated)
    }
    else {
      super.pushViewController(viewController, animated: animated)
    }
  }
  
  public override func popViewController(animated: Bool) -> UIViewController? {
    if self.navigationController != nil {
      return self.navigationController!.popViewController(animated: animated)
    }
    return super.popViewController(animated: animated)
  }
  
  public override func popToRootViewController(animated: Bool) -> [UIViewController]? {
    if self.navigationController != nil {
      return self.navigationController!.popToRootViewController(animated: animated)
    }
    return super.popToRootViewController(animated: animated)
  }
  
  public override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
    if self.navigationController != nil {
      return self.navigationController!.popToViewController(viewController, animated: animated)
    }
    return super.popToViewController(viewController, animated: animated)
  }
  
  public override func forwardingTarget(for aSelector: Selector!) -> Any? {
    if self.navigationController?.responds(to: aSelector) == true {
      return self.navigationController
    }
    return nil
  }
  
  public override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
    if self.navigationController != nil {
      self.navigationController!.setViewControllers(viewControllers, animated: animated)
    }
    else {
      super.setViewControllers(viewControllers, animated: animated)
    }
  }
  
  public override func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
    super.setNavigationBarHidden(hidden, animated: animated)
    if self.visibleViewController?.vm.disableInteractivePop != true {
      self.visibleViewController?.vm.disableInteractivePop = hidden
    }
  }
}

#endif

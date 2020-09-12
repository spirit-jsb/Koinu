//
//  VMContainerViewController.swift
//  Koinu
//
//  Created by max on 2020/9/12.
//  Copyright © 2020 max. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public class VMContainerViewController: UIViewController {
  
  public private(set) var contentViewController: UIViewController!
  
  private var containerNavigationController: UINavigationController?
  
  public class func containerViewController(_ viewController: UIViewController) -> VMContainerViewController {
    return VMContainerViewController(viewController: viewController)
  }
  
  public class func containerViewController(_ viewController: UIViewController, navigationBarClass: AnyClass?) -> VMContainerViewController {
    return VMContainerViewController(viewController: viewController, navigationBarClass: navigationBarClass)
  }
  
  public class func containerViewController(_ viewController: UIViewController, navigationBarClass: AnyClass?, hasPlaceholderViewController: Bool) -> VMContainerViewController {
    return VMContainerViewController(viewController: viewController, navigationBarClass: navigationBarClass, hasPlaceholderViewController: hasPlaceholderViewController)
  }
  
  public class func containerViewController(_ viewController: UIViewController, navigationBarClass: AnyClass?, hasPlaceholderViewController: Bool, backBarButtonItem: UIBarButtonItem?, title: String?) -> VMContainerViewController {
    return VMContainerViewController(viewController: viewController, navigationBarClass: navigationBarClass, hasPlaceholderViewController: hasPlaceholderViewController, backBarButtonItem: backBarButtonItem, title: title)
  }
  
  public convenience init(viewController: UIViewController) {
    self.init(viewController: viewController, navigationBarClass: nil)
  }
  
  public convenience init(viewController: UIViewController, navigationBarClass: AnyClass?) {
    self.init(viewController: viewController, navigationBarClass: navigationBarClass, hasPlaceholderViewController: false)
  }
  
  public convenience init(viewController: UIViewController, navigationBarClass: AnyClass?, hasPlaceholderViewController: Bool) {
    self.init(viewController: viewController, navigationBarClass: navigationBarClass, hasPlaceholderViewController: hasPlaceholderViewController, backBarButtonItem: nil, title: nil)
  }
  
  public init(viewController: UIViewController, navigationBarClass: AnyClass?, hasPlaceholderViewController: Bool, backBarButtonItem: UIBarButtonItem?, title: String?) {
    super.init(nibName: nil, bundle: nil)
    
    self.contentViewController = viewController
    self.containerNavigationController = VMContainerNavigationController(navigationBarClass: navigationBarClass, toolbarClass: nil)
    
    if hasPlaceholderViewController {
      let placeholderViewController = UIViewController()
      placeholderViewController.title = title
      placeholderViewController.navigationItem.backBarButtonItem = backBarButtonItem
      self.containerNavigationController!.viewControllers = [placeholderViewController, viewController]
    }
    else {
      self.containerNavigationController!.viewControllers = [viewController]
    }
    
    self.addChild(self.containerNavigationController!)
    self.containerNavigationController!.didMove(toParent: self)
  }
  
  public init(contentViewController: UIViewController) {
    super.init(nibName: nil, bundle: nil)
    
    self.contentViewController = contentViewController
    
    self.addChild(self.contentViewController)
    self.contentViewController.didMove(toParent: self)
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
    
    if self.containerNavigationController != nil {
      self.containerNavigationController!.view.frame = self.view.bounds
      self.containerNavigationController!.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      self.view.addSubview(self.containerNavigationController!.view)
    }
    else {
      self.contentViewController.view.frame = self.view.bounds
      self.contentViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      self.view.addSubview(self.contentViewController.view)
    }
  }
  
  public override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  public override var canBecomeFirstResponder: Bool {
    return self.contentViewController.canBecomeFirstResponder
  }
  
  public override var preferredStatusBarStyle: UIStatusBarStyle {
    return self.contentViewController.preferredStatusBarStyle
  }
  
  public override var prefersStatusBarHidden: Bool {
    return self.contentViewController.prefersStatusBarHidden
  }
  
  public override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
    return self.contentViewController.preferredStatusBarUpdateAnimation
  }
  
  public override var shouldAutorotate: Bool {
    return self.contentViewController.shouldAutorotate
  }
  
  public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return self.contentViewController.supportedInterfaceOrientations
  }
  
  public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
    return self.contentViewController.preferredInterfaceOrientationForPresentation
  }
  
  public override var hidesBottomBarWhenPushed: Bool {
    set {
      super.hidesBottomBarWhenPushed = newValue
    }
    get {
      return self.contentViewController.hidesBottomBarWhenPushed
    }
  }
  
  public override var title: String? {
    set {
      super.title = newValue
    }
    get {
      return self.contentViewController.title
    }
  }
  
  public override var tabBarItem: UITabBarItem! {
    set {
      super.tabBarItem = newValue
    }
    get {
      return self.contentViewController.tabBarItem
    }
  }
  
  @available(iOS 11.0, *)
  public override var childForHomeIndicatorAutoHidden: UIViewController? {
    return self.contentViewController
  }
  
  @available(iOS 11.0, *)
  public override var prefersHomeIndicatorAutoHidden: Bool {
    return self.contentViewController.prefersHomeIndicatorAutoHidden
  }
  
  @available(iOS 11.0, *)
  public override var childForScreenEdgesDeferringSystemGestures: UIViewController? {
    return self.contentViewController
  }
  
  @available(iOS 11.0, *)
  public override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
    return self.contentViewController.preferredScreenEdgesDeferringSystemGestures
  }
  
  public override func becomeFirstResponder() -> Bool {
    return self.contentViewController.becomeFirstResponder()
  }
}

#endif

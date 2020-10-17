//
//  Koinu+.swift
//  Koinu
//
//  Created by max on 2020/9/11.
//  Copyright © 2020 max. All rights reserved.
//

#if canImport(UIKit)

import UIKit

struct RuntimeKeys {
  static var disableInteractivePop = "com.max.jian.Koinu.disable.interactive.pop"
}

extension KoinuWrapper where Base: UIViewController {
  
  /// 将此属性设置为 true 以禁用侧滑返回功能
  public var disableInteractivePop: Bool? {
    set {
      objc_setAssociatedObject(self.base, &RuntimeKeys.disableInteractivePop, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    get {
      return objc_getAssociatedObject(self.base, &RuntimeKeys.disableInteractivePop) as? Bool
    }
  }
  
  /// 使用 `self.navigationController` 将返回一个被包装的 `UINavigationController`, 使用该属性可以获得正确的 `navigation controller`
  public var navigationController: VMNavigationController? {
    var viewController: UIViewController? = self.base
    while viewController != nil && !(viewController is VMNavigationController) {
      viewController = viewController!.navigationController
    }
    return viewController as? VMNavigationController
  }
}

#endif

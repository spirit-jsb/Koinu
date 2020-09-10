//
//  UIViewController+Koinu.swift
//  Koinu
//
//  Created by max on 2020/9/11.
//  Copyright © 2020 max. All rights reserved.
//

#if canImport(UIKit)

import UIKit

extension UIViewController: KoinuCompatible {
  
}

extension UIViewController {
  
  /// 重写此方法以提供 `UINavigationBar` 的自定义子类, 默认返回 nil
  public func navigationBarClass() -> AnyClass? {
    return nil
  }
}

#endif

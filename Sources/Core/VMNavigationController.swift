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

open class VMNavigationController: UINavigationController {
  
}

#endif

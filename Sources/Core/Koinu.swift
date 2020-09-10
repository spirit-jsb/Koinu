//
//  Koinu.swift
//  Koinu
//
//  Created by max on 2020/9/11.
//  Copyright © 2020 max. All rights reserved.
//

#if canImport(Foundation)

import Foundation

public struct KoinuWrapper<Base> {
  
  public let base: Base
  
  public init(base: Base) {
    self.base = base
  }
}

public protocol KoinuCompatible: class {
  
}

extension KoinuCompatible {
  
  public var vm: KoinuWrapper<Self> {
    set {  }
    get { return KoinuWrapper(base: self) }
  }
}

#endif

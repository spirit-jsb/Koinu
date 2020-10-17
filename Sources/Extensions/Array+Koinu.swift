//
//  Array+Koinu.swift
//  Koinu
//
//  Created by max on 2020/9/11.
//  Copyright © 2020 max. All rights reserved.
//

#if canImport(UIKit)

import UIKit

extension Array where Element: UIViewController {
  
  subscript(index: Int) -> Element? {
    return self.indices ~= index ? self[index] : nil
  }
  
  func verify(_ completion: (Element) -> Bool) -> Bool {
    var result = false
    for value in self {
      if completion(value) {
        result = true
        break
      }
    }
    return result
  }
}

#endif

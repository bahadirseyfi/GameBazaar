//
//  Dictionary+Extension.swift
//  GameBazaar
//
//  Created by bahadir on 6.06.2021.
//

import Foundation

extension Dictionary {
  subscript(i: Int) -> (key: Key, value: Value) {
    get {
      return self[index(startIndex, offsetBy: i)]
    }
  }
}

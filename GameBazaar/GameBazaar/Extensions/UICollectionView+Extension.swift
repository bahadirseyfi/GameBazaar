//
//  UICollectionViewExtension.swift
//  GameBazaar
//
//  Created by bahadir on 31.05.2021.
//

import Foundation

public extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

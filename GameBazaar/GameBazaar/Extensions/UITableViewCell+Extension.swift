//
//  UITableViewCell+Extension.swift
//  GameBazaar
//
//  Created by bahadir on 2.06.2021.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}

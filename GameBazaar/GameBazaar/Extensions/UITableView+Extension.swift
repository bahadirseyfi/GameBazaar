//
//  UITableView+Extension.swift
//  GameBazaar
//
//  Created by bahadir on 2.06.2021.
//

import UIKit

extension UITableView {
    func register(cellType: UITableViewCell.Type) {
        register(cellType.nib, forCellReuseIdentifier: cellType.identifier)
    }
    func dequeCell<T: UITableViewCell>(cellType: T.Type, indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as? T else {
            fatalError()
        }
        return cell
    }
}

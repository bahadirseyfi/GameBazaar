//
//  PlatformCell.swift
//  GameBazaar
//
//  Created by bahadir on 26.05.2021.
//

import UIKit

final class PlatformCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "PlatformCell"
    
    @IBOutlet weak var platformLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    override var isSelected: Bool {
        didSet{
            if self.isSelected {
                UIView.animate(withDuration: 0.3) { // for animation effect
                    self.backView.backgroundColor = UIColor(red: 115/255, green: 190/255, blue: 170/255, alpha: 1.0)
                }
            }
            else {
                UIView.animate(withDuration: 0.3) { // for animation effect
                     self.backView.backgroundColor = UIColor(red: 60/255, green: 63/255, blue: 73/255, alpha: 1.0)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backView.backgroundColor = UIColor(red: 60/255, green: 63/255, blue: 73/255, alpha: 1.0)
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
    }
    
    func setCell(label: String) {
        self.platformLabel.text = label
    }
}


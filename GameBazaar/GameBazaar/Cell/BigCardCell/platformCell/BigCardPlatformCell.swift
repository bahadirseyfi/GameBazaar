//
//  BigCardPlatformCell.swift
//  GameBazaar
//
//  Created by bahadir on 3.06.2021.
//

import UIKit

class BigCardPlatformCell: UICollectionViewCell {
    static let reuseIdentifier: String = "BigCardPlatformCell"
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // nameLabel.setMargins()
    }
    
    func initializeCell(label: String) {
        nameLabel.text = label
      //  nameLabel.setMargins(5)
        nameLabel.layer.cornerRadius = 4
    }
}

//
//  WishlistCell.swift
//  GameBazaar
//
//  Created by bahadir on 5.06.2021.
//

import UIKit

protocol WishlistCellDelegate: AnyObject {
    func reloadCollectionView()
}

final class WishlistCell: UICollectionViewCell {
    static let reuseIdentifier: String = "WishlistCell"
    
    @IBOutlet private weak var wishlistButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    private var wishListDict: [String:[String]] = [:]
    private var gameID: Int?
    weak var delegate: WishlistCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let wishListData = UserDefaults.standard.dictionary(forKey: "WishList") as? [String:[String]] {
            wishListDict = wishListData
        }
        layer.cornerRadius = 8
        wishlistButton.layer.cornerRadius = 5
    }

    @IBAction private func wishlistButtonTapped(_ sender: Any) {
        let id = String(gameID ?? 0)
        wishListDict.removeValue(forKey: id)
        UserDefaults.standard.set(wishListDict, forKey: "WishList")
        NotificationCenter.default.post(name: NSNotification.Name("load"), object: nil)
    }
    
    func initializeCell(id: Int, name: String, image: String) {
        nameLabel.text = name
        prepareGameImage(with: image)
        self.gameID = id
    }
    
    private func prepareGameImage(with urlString: String?) {
        if let imageUrlString = urlString, let url = URL(string: imageUrlString) {
            imageView.sd_setImage(with: url)
        }
    }
}


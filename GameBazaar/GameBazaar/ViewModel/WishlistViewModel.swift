//
//  WishlistViewModel.swift
//  GameBazaar
//
//  Created by bahadir on 6.06.2021.
//

import Foundation

protocol WishlistViewModelProtocol {
    var delegate: WishlistViewModelDelegate? { get set }
    func load()
    var numberOfItemsWishlist: Int { get }
    func wishlistID(_ index: Int) -> String
    func wishlistName(_ index: Int) -> String
    func wishlistImage(_ index: Int) -> String
    func showLoading()
    func hideLoading()
}

protocol WishlistViewModelDelegate: AnyObject {
    func prepareCollectionView()
    func reloadData()
}

final class WishlistViewModel {
    
    private var wishListDict: [String:[String]] = [:]
    weak var delegate: WishlistViewModelDelegate?
    
    private func fetchWishlist() {
        if let wishListData = UserDefaults.standard.dictionary(forKey: "WishList") as? [String:[String]] {
            wishListDict = wishListData
        }
    }
}

extension WishlistViewModel: WishlistViewModelProtocol {
    func showLoading() {
        ProgressView.shared.show()
    }
    
    func hideLoading() {
        ProgressView.shared.hide()
    }
    
    var numberOfItemsWishlist: Int {
        wishListDict.count
    }
    
    func wishlistID(_ index: Int) -> String {
        wishListDict[index].key
    }
    
    func wishlistName(_ index: Int) -> String {
        wishListDict[index].value[0]
    }
    
    func wishlistImage(_ index: Int) -> String {
        wishListDict[index].value[1]
    }
    
    func load() {
        showLoading()
        delegate?.prepareCollectionView()
        fetchWishlist()
        hideLoading()
    }
}

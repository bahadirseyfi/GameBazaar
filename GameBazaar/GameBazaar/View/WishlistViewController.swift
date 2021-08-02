//
//  WishlistViewController.swift
//  GameBazaar
//
//  Created by bahadir on 24.05.2021.
//

import UIKit

final class WishlistViewController: UIViewController {

    private var collectionView: UICollectionView!
    @IBOutlet private var noWishlistLabel: UILabel!
    
    var viewModel: WishlistViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Wishlist"
        viewModel.load()
        notificationWishlist()
    }
    
    private func notificationWishlist() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadList(notification:)), name: NSNotification.Name(rawValue: "load"), object: nil)
        viewModel.load()
    }
    
    @objc
    private func loadList(notification: NSNotification) {
        viewModel.load()
    }
}

extension WishlistViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItemsWishlist
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WishlistCell.reuseIdentifier, for: indexPath) as! WishlistCell
        let index = indexPath.item
        let id = viewModel.wishlistID(index)
        let name = viewModel.wishlistName(index)
        let image = viewModel.wishlistImage(index)
        cell.initializeCell(id: Int(id) ?? 0, name: name, image: image)
        return cell
    }
}

extension WishlistViewController: WishlistViewModelDelegate {
    func prepareCollectionView() {
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout())
        view.addSubview(collectionView)
        collectionView.register(UINib.loadNib(name: WishlistCell.reuseIdentifier), forCellWithReuseIdentifier: WishlistCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}

extension WishlistViewController {
    func makeVerticalLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(CGFloat(0.5)),
                                              heightDimension: .fractionalWidth(0.7))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalWidth(0.7))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
        return section
    }
}

extension WishlistViewController {
    func layout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout {_,_ in
            return self.makeVerticalLayout()
        }
    }
}


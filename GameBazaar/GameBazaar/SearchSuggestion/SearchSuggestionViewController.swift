//
//  SearchSuggestionViewController.swift
//  GameBazaar
//
//  Created by bahadir on 31.05.2021.
//

import UIKit
import CoreAPI

class SearchSuggestionViewController: UIViewController {
    private var networkManager: NetworkManager<HomeEndPointItem> = NetworkManager()
    private var collectionView: UICollectionView!
    private var games: [Game] = []
    private let count = 3
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollectionView()
        view.backgroundColor = .red
    }
    
    private func fetchGames(query: String, device: String) {
        networkManager.request(endpoint: .homepage(query: query, device: device), type: HomeResponse.self) { [weak self] (result) in
            switch result {
            case.success(let response):
                self?.games.append(contentsOf: response.results ?? [])
                self?.collectionView?.reloadData()
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
}

extension SearchSuggestionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BigCardCell.reuseIdentifier, for: indexPath) as! BigCardCell
       // cell.initializeCell(game: games[indexPath.item])
        return cell
    }
}

extension SearchSuggestionViewController {
    func makeVerticalLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(CGFloat(1)),
                                              heightDimension: .fractionalWidth(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalWidth(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
        return section
    }
}

extension SearchSuggestionViewController {
    func prepareCollectionView() {
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout())
        view.addSubview(collectionView)
        collectionView.register(UINib.loadNib(name: BigCardCell.reuseIdentifier), forCellWithReuseIdentifier: BigCardCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension SearchSuggestionViewController {
    func layout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout {_,_ in
            return self.makeVerticalLayout()
        }
    }
}


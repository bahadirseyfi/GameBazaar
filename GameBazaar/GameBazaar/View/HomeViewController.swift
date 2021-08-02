//
//  ViewController.swift
//  GameBazaar
//
//  Created by bahadir on 24.05.2021.
//

import UIKit

extension HomeViewController {
    fileprivate enum Constants {
        static var layoutSize: CGFloat = 1.0
        static var headerSize: CGFloat = 0.3
        static let searchBarTitle: String = "Cancel"
        static let searcBarItemColor: UIColor = UIColor.cyan //Color Extn
        static let searchBarTextPozitionVertical: CGFloat = 0
        static let searchBarTextPozitionHorizontal: CGFloat = 10
        static let numberOfSections: Int = 2
        static let itemContentInsets: CGFloat = 5
        static let sectionContentInsets: CGFloat = 10
        static let groupSizeWidthDimension: CGFloat = 0.4
        static let groupSizeHeightEstimateDimension: CGFloat = 20
        static let itemSizeWidthDimension: CGFloat = 0.9
    }
}

final class HomeViewController: UIViewController {
    private var collectionView: UICollectionView!
    var viewModel: HomeViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareSearchController()
        viewModel.load()
        notificationWishlist()
    }
    
    private func notificationWishlist() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadList(notification:)), name: NSNotification.Name(rawValue: "load"), object: nil)
        viewModel.delegate?.reloadData()
    }
    
    @objc
    private func pullToRefresh() {
        viewModel.pullToRefresh()
    }
    
    @objc
    private func loadList(notification: NSNotification) {
        viewModel.load()
    }
    
    private func redirectTo(gameID: String) {
        self.view.endEditing(true)
        let viewController: DetailViewController = DetailViewController.instantiate(storyboards: .detail)
        viewController.viewModel = DetailViewModel(gameID: gameID)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func prepareSearchController() {
        let searchSuggestionVC = SearchSuggestionViewController.instantiate(storyboards: .main)
        let searchController = UISearchController(searchResultsController: searchSuggestionVC)
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.tintColor = Constants.searcBarItemColor
        searchController.searchBar.searchTextPositionAdjustment = .init(horizontal: Constants.searchBarTextPozitionHorizontal,
                                                                        vertical: Constants.searchBarTextPozitionVertical)
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = Constants.searchBarTitle
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = Constants.searcBarItemColor
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    @IBAction private func layoutButtonTapped(_ sender: Any) {
        switch Constants.layoutSize {
        case 1.0:
            Constants.layoutSize = 0.5
            collectionView.reloadData()
        case 0.5:
            Constants.layoutSize = 1.0
            collectionView.reloadData()
        default:
            break
        }
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Constants.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.numberOfItemsPlatforms
        default:
            return viewModel.numberOfItemsGames
        }
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0:
            let item = collectionView.cellForItem(at: indexPath)
            if item?.isSelected == true {
                viewModel.filteredDisplay(device: "")
                collectionView.deselectItem(at: indexPath, animated: true)
                return false
            } else {
                if let platform = viewModel.platform(indexPath.item)?.slug {
                    viewModel.filteredDisplay(device: platform)
                }
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
                return true
            }
        default:
            guard let selectedGameID = viewModel.game(indexPath.item)?.id else { return false }
            redirectTo(gameID: String(selectedGameID))
            return false
        }
      }
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlatformCell.reuseIdentifier,
                                                          for: indexPath) as! PlatformCell
            if let item = viewModel.platform(indexPath.item) {
                cell.setCell(label: item.name)
            }
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BigCardCell.reuseIdentifier,
                                                          for: indexPath) as! BigCardCell
            if let item = viewModel.game(indexPath.item) {
                cell.initializeCell(game: item)
            }
            return cell
        }
    }
}

// MARK: - UISearchResultsUpdating
extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text ?? "")
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            break
        case 1:
            viewModel.willDisplay(indexPath.item)
            break
        default:
            debugPrint("UICollectionViewDelegate")
        }
    }
}

extension HomeViewController {
    func layout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch sectionIndex {
            case 0:
                return self.createHorizontalLayout()
            default:
                break
            }
            if sectionIndex == 1 {
                return self.makeVerticalLayout()
            }
            return self.makeVerticalLayout()
        }
    }
}

extension HomeViewController {
    func createHorizontalLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Constants.itemSizeWidthDimension),
                                              heightDimension: .fractionalWidth(Constants.headerSize))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: Constants.itemContentInsets,
                                   leading: Constants.itemContentInsets,
                                   bottom: Constants.itemContentInsets,
                                   trailing: Constants.itemContentInsets)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Constants.groupSizeWidthDimension),
                                               heightDimension: .estimated(Constants.groupSizeHeightEstimateDimension))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: Constants.sectionContentInsets,
                                      bottom: 0, trailing: Constants.sectionContentInsets)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
}

extension HomeViewController {
    func makeVerticalLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Constants.layoutSize),
                                              heightDimension: .fractionalWidth(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: Constants.itemContentInsets,
                                   leading: Constants.itemContentInsets,
                                   bottom: Constants.itemContentInsets,
                                   trailing: Constants.itemContentInsets)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalWidth(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: Constants.sectionContentInsets,
                                      bottom: 0, trailing: Constants.sectionContentInsets)
        return section
    }
}

// MARK: - HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
    func reloadData() {
        collectionView.reloadData()
    }
    
    func prepareCollectionView() {
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout())
        view.addSubview(collectionView)
        collectionView.register(UINib.loadNib(name: BigCardCell.reuseIdentifier), forCellWithReuseIdentifier: BigCardCell.reuseIdentifier)
        collectionView.register(UINib.loadNib(name: PlatformCell.reuseIdentifier), forCellWithReuseIdentifier: PlatformCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

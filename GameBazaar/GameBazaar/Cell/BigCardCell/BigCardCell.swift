//
//  BigCardCell.swift
//  GameBazaar
//
//  Created by bahadir on 26.05.2021.
//

import UIKit
import SDWebImage



final class BigCardCell: UICollectionViewCell {
    static let reuseIdentifier: String = "BigCardCell"
    
    @IBOutlet private weak var gameImage: UIImageView!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var infoTableView: UITableView!
    @IBOutlet private weak var wishListButton: UIButton!
    @IBOutlet private weak var nameLabelTrailingConst: NSLayoutConstraint!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var wishListDict: [String:[String]] = [:]
    private var wishArray = [[:]]
    private var infoCells: [[String:String]] = []
    private var game: Game?
    
    @IBOutlet private weak var collectionLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    @IBAction private func wishListButtonTapped(_ sender: UIButton) {
    
        let id = String(game?.id ?? 0)
        if wishListDict.keys.contains(id) {
            wishListDict.removeValue(forKey: id)
            UserDefaults.standard.set(wishListDict, forKey: "WishList")
            wishListButton.backgroundColor = .gray
            wishListButton.tintColor = .white
        } else {
            guard let gameID = game?.id else { return }
            guard let gameName = game?.name else { return }
            guard let gameImage = game?.backgroundImage else { return }
            addWishListData(id: gameID, name: gameName, image: gameImage)
            wishListButton.backgroundColor = .green
            wishListButton.tintColor = .white
        }
        NotificationCenter.default.post(name: NSNotification.Name("load"), object: nil)
    }
    
    private func addWishListData(id: Int, name: String, image: String) {
        let defaults = UserDefaults.standard
        wishListDict["\(id)"] = [name, image]
        defaults.set(wishListDict, forKey: "WishList")
    }
    
    private func setupUI() {
        if let wishListData = UserDefaults.standard.dictionary(forKey: "WishList") as? [String:[String]] {
            wishListDict = wishListData
        }
        configureConstraints()
        infoTableView.separatorStyle = .none
        preparePlatformCell()
        prepareInfoTableView()
        self.layer.cornerRadius = 8
        wishListButton.layer.cornerRadius = 8
    }
    
    private func prepareInfoTableView() {
        infoTableView.register(UINib.loadNib(name: InfoCell.reuseIdentifier),
                               forCellReuseIdentifier: InfoCell.reuseIdentifier)
    }
    
    func initializeCell(game: Game) {
        self.game = game
        nameLabel.text = game.name
        prepareGameImage(with: game.backgroundImage)
        prepareRatingLabel(rating: game.metacritic ?? 0)
        prepareInfoCell(initgame: game)
        infoTableView.reloadData()
        
        let id = String(game.id ?? 0)
        if wishListDict.keys.contains(id) {
            wishListButton.backgroundColor = .green
            wishListButton.tintColor = .white
        } else {
            wishListButton.backgroundColor = .gray
            wishListButton.tintColor = .white
        }
    }
    
    private func prepareInfoCell(initgame: Game) {
        //        RELEASED
        if initgame.released != "" {
            if let released = initgame.released {
                infoCells.append(["Released date: ": released])
            }
        }
        
        //        GENRES
        var genresArray: [String]?
        if let genres = initgame.genres {
            genresArray = genres.map { $0.name! }
        }
        guard let genresDict = genresArray?.joined(separator: ", ") else { return }
        infoCells.append(["Genres: ":genresDict])
        
        //        PLAY TIME
        if initgame.playtime != nil && initgame.playtime != 0 {
            if let playTime = initgame.playtime {
                infoCells.append(["Play Time: ": String(playTime) + " hours"])
            }
        }
    }
    
    private func prepareGameImage(with urlString: String?) {
        if let imageUrlString = urlString, let url = URL(string: imageUrlString) {
            gameImage.sd_setImage(with: url)
        }
    }
    
    private func prepareRatingLabel(rating: Int) {
        ratingLabel.layer.cornerRadius = 4
        ratingLabel.layer.borderWidth = 1
        if rating >= 75 {
            ratingLabel.layer.borderColor = CGColor.green
            ratingLabel.textColor = UIColor.green
        } else if rating >= 50 {
            ratingLabel.layer.borderColor = CGColor.banana
            ratingLabel.textColor = UIColor.orange
        } else {
            ratingLabel.layer.borderColor = CGColor.red
            ratingLabel.textColor = UIColor.red
        }
        ratingLabel.text = String(rating)
    }
    
    private func configureConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

//  MARK: - UITableViewDataSource & UITabBarDelegate
extension BigCardCell: UITableViewDataSource, UITabBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !infoCells.isEmpty {
            infoTableView.isHidden = false
            if infoCells.count > 3 {
                return 3
            } else {
                return infoCells.count
            }
        } else {
            infoTableView.isHidden = true
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeCell(cellType: InfoCell.self, indexPath: indexPath)
        if !infoCells.isEmpty {
            let conf = infoCells[indexPath.row]
            cell.configure(infos: conf)
        }
        return cell
    }
}

//  MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension BigCardCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let platformCount = game?.parentPlatforms?.count else { return 0 }
        if platformCount < 4 {
            return platformCount
        } else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BigCardPlatformCell.reuseIdentifier, for: indexPath) as! BigCardPlatformCell
        guard let platformCount = game?.parentPlatforms?.count else { return .init() }
        if indexPath.item > 2 {
            let lastIndex = platformCount - 3
            cell.initializeCell(label: "+\(lastIndex)")
            return cell
        } else {
            if let platName = game?.parentPlatforms?[safe: indexPath.item]?.platform?.name {
                cell.initializeCell(label: platName)
            }
            return cell
        }
    }
}

extension BigCardCell {
    func preparePlatformCell() {
        collectionView.register(UINib.loadNib(name: BigCardPlatformCell.reuseIdentifier), forCellWithReuseIdentifier: BigCardPlatformCell.reuseIdentifier)
    }
}




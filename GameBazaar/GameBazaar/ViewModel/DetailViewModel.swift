//
//  DetailViewModel.swift
//  GameBazaar
//
//  Created by bahadir on 6.06.2021.
//

import Foundation
import CoreAPI


protocol DetailViewModelProtocol {
    var delegate: DetailViewModelDelegate? { get set }
    func informationCell(_ index: Int) -> [String:String]?
    var gameDescriptionRaw: String { get }
    var numberOfRowsInSection: Int { get }
    var gameWebsiteUrl: String { get }
    var gameRedditUrl: String { get }
    var gameImageUrl: String { get }
    var gameMetacritic: Int { get }
    var gameName: String { get }
    func showLoading()
    func hideLoading()
    func load()
}

protocol DetailViewModelDelegate: AnyObject {
    func reloadData()
    func prepareTableView()
    func prepareDescription()
    func prepareDetail()
    func prepareInformationUI()
    func hideImage()
    func showImage()
}

final class DetailViewModel {
    private var networkManager: NetworkManager<DetailEndPointItem> = NetworkManager()
    private var informationCells: [[String:String]] = []
    
    var gameID: String?
    
    private var game: DetailResponse?
    weak var delegate: DetailViewModelDelegate?
    
    init(gameID: String) {
        self.gameID = gameID
    }
    
    private func fetchDetail(gameID: String) {
        showLoading()
        delegate?.hideImage()
        networkManager.request(endpoint: .detailPage(query: gameID), type: DetailResponse.self) { [weak self] (result) in
            switch result {
            case.success(let response):
                self?.game = response
                self?.fetchInformation()
                self?.delegate?.reloadData()
                self?.delegate?.prepareDetail()
                self?.delegate?.prepareDescription()
                self?.delegate?.prepareTableView()
                self?.hideLoading()
                self?.delegate?.showImage()
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    private func fetchInformation() {
        //        RELEASED
        
        if game?.released != "" {
            if let released = game?.released {
                informationCells.append(["Release date: ": released])
            }
        }
        //        GENRES
        var genresArray: [String]?
        if let genres = game?.genres {
            genresArray = genres.map { $0.name! }
        }
        guard let genresDict = genresArray?.joined(separator: ", ") else { return }
        informationCells.append(["Genres: ":genresDict])
        
        //        PLAY TIME
        if game?.playtime != nil && game?.playtime != 0 {
            if let playTime = game?.playtime {
                informationCells.append(["Play Time: ": String(playTime) + " hours"])
            }
        }
        self.delegate?.reloadData()
    }
}

extension DetailViewModel: DetailViewModelProtocol {
    
    func load() {
        fetchDetail(gameID: gameID ?? "0")
        delegate?.prepareDescription()
        delegate?.prepareDetail()
        delegate?.prepareInformationUI()
        delegate?.prepareTableView()
    }
    
    func informationCell(_ index: Int) -> [String : String]? {
        return informationCells[safe: index]
    }
    
    var numberOfRowsInSection: Int {
        informationCells.count
    }
    
    var gameMetacritic: Int {
        game?.metacritic ?? 0
    }
    
    var gameDescriptionRaw: String {
        game?.descriptionRaw ?? ""
    }
    
    var gameImageUrl: String {
        game?.backgroundImage ?? ""
    }
    
    var gameRedditUrl: String {
        game?.redditURL ?? ""
    }
    
    var gameWebsiteUrl: String {
        game?.website ?? ""
    }
    
    var gameName: String {
        game?.name ?? ""
    }
    
    func showLoading() {
        ProgressView.shared.show()
    }
    
    func hideLoading() {
        ProgressView.shared.hide()
    }
}

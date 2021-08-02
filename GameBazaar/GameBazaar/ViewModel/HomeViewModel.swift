//
//  HomeViewModel.swift
//  GameBazaar
//
//  Created by bahadir on 31.05.2021.
//

import Foundation
import CoreAPI

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    var numberOfItemsPlatforms: Int { get }
    func platform(_ index: Int) -> Device?
    func filteredDisplay(device: String)
    var numberOfItemsGames: Int { get }
    func game(_ index: Int) -> Game?
    func willDisplay(_ index: Int)
    func pullToRefresh()
    func showLoading()
    func hideLoading()
    func load()
}

protocol HomeViewModelDelegate: AnyObject {
    func reloadData()
    func prepareCollectionView()
}

final class HomeViewModel {
    private var networkManager: NetworkManager<HomeEndPointItem> = NetworkManager()
    private var platforms: [Device] = []
    private var nextPage: String = "1"
    private var games: [Game] = []
    private var device: String = ""
    weak var delegate: HomeViewModelDelegate?
    
    init(networkManager: NetworkManager<HomeEndPointItem>) {
        self.networkManager = networkManager
    }
    
    private func fetchGames(query: String, device: String) {
        showLoading()
        networkManager.request(endpoint: .homepage(query: query, device: self.device),
                               type: HomeResponse.self) { [weak self] (result) in
            self?.hideLoading()
            switch result {
            case.success(let response):
                self?.games.append(contentsOf: response.results ?? [])
                self?.delegate?.reloadData()
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    private func fetchDevice() {
        networkManager.request(endpoint: .platform, type: PlatformResponse.self) { [weak self] (result) in
            switch result {
            case.success(let response):
                self?.platforms.append(contentsOf: response.results )
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
}

extension HomeViewModel: HomeViewModelProtocol {
    func game(_ index: Int) -> Game? {
        games[safe: index]
    }
    
    func platform(_ index: Int) -> Device? {
        platforms[safe: index]
    }
    
    func willDisplay(_ index: Int) {
        if index == (games.count - 1), !nextPage.isEmpty {
            guard var intPage = Int(nextPage) else { return }
            intPage += 1
            nextPage = String(intPage)
            fetchGames(query: nextPage, device: device)
        }
    }
    
    func filteredDisplay(device: String) {
        games.removeAll()
        self.device = device
        fetchGames(query: nextPage, device: self.device)
        self.delegate?.reloadData()
    }
    
    func pullToRefresh() {
        self.games.removeAll()
        fetchGames(query: nextPage, device: device)
    }
    
    var numberOfItemsGames: Int {
        games.count
    }
    
    var numberOfItemsPlatforms: Int {
        platforms.count
    }
    
    func load() {
        delegate?.prepareCollectionView()
        fetchGames(query: nextPage, device: device)
        fetchDevice()
    }
    
    func showLoading() {
        ProgressView.shared.show()
    }
    
    func hideLoading() {
        ProgressView.shared.hide()
    }
}

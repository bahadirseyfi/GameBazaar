//
//  DetailViewController.swift
//  GameBazaar
//
//  Created by bahadir on 28.05.2021.
//

import UIKit
import CoreAPI

final class DetailViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var gameImage: UIImageView!
    @IBOutlet private weak var downImage: UIImageView!
    @IBOutlet private weak var visitRedditView: UIView!
    @IBOutlet private weak var visitWebsiteView: UIView!
    @IBOutlet private weak var descriptionView: UIView!
    @IBOutlet private weak var informationView: UIView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var visitWebSiteToTableViewConstarint: NSLayoutConstraint!
    @IBOutlet private weak var websiteToRedditConstraint: NSLayoutConstraint!
        
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tableViewHeightConstraint?.constant = self.tableView.contentSize.height
    }
    
    var viewModel: DetailViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.load()
        navigationItem.title = "Game Detail"
    }
    
    @IBAction private func redditButtonTapped(_ sender: Any) {
        redirectTo(website: viewModel.gameRedditUrl)
    }
    
    @IBAction private func websiteButtonTapped(_ sender: Any) {
        redirectTo(website: viewModel.gameWebsiteUrl)
    }
    
    private func redirectTo(website: String) {
        self.view.endEditing(true)
        let viewController: WebsiteViewController = WebsiteViewController.instantiate(storyboards: .detail)
        viewController.initWebView(urlString: website)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func prepareWebsites() {
        if viewModel.gameRedditUrl == "" {
            visitRedditView.isHidden = true
            websiteToRedditConstraint.isActive = false
            visitWebSiteToTableViewConstarint.isActive = true
        }
    }
    
    @objc
    private func handleTapDescription(_ sender: UITapGestureRecognizer?) {
        if let descriptionLabel = descriptionLabel {
            descriptionLabel.numberOfLines = descriptionLabel.numberOfLines == 20 ? 4 : 20
            if descriptionLabel.numberOfLines == 4 {
                downImage.image = UIImage(systemName: "chevron.down")
            } else {
                downImage.image = UIImage(systemName: "chevron.up")
            }
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           options: [.allowUserInteraction],
                           animations: {
                            self.view.layoutIfNeeded()
                           }, completion: nil)
        }
    }
 
    private func prepareGameImage(with urlString: String?) {
        if let imageUrlString = urlString, let url = URL(string: imageUrlString) {
            gameImage.sd_setImage(with: url)
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
        if viewModel.numberOfRowsInSection != 0 {
            let temp = viewModel.informationCell(indexPath.item)
            cell.textLabel?.text = temp?.keys.first
            cell.detailTextLabel?.text = temp?.values.first
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
}

extension DetailViewController: DetailViewModelDelegate {
    func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
     func prepareDetail() {
        prepareGameImage(with: viewModel.gameImageUrl)
        nameLabel.text = viewModel.gameName
        descriptionLabel.text = viewModel.gameDescriptionRaw
        
        // Rating Label Configure !
        ratingLabel.layer.borderWidth = 1
        ratingLabel.layer.cornerRadius = 4
        let rating = viewModel.gameMetacritic
        ratingLabel.text = String(rating)
        if rating > 75 {
            ratingLabel.layer.borderColor = .green
            ratingLabel.textColor = .green
        } else if rating > 50 {
            ratingLabel.layer.borderColor = .banana
            ratingLabel.textColor = .yellow
        } else {
            ratingLabel.layer.borderColor = .red
            ratingLabel.textColor = .red
        }
        visitWebsiteView.layer.cornerRadius = 8
        visitRedditView.layer.cornerRadius = 8
    }
    
     func prepareInformationUI() {
        informationView.clipsToBounds = true
        informationView.layer.cornerRadius = 8
        informationView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 8
        tableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
     func prepareDescription() {
        descriptionView.clipsToBounds = true
        descriptionView.layer.cornerRadius = 10
        descriptionView.layer.maskedCorners = [.layerMaxXMinYCorner,
                                               .layerMinXMinYCorner]
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(DetailViewController.handleTapDescription))
        descriptionLabel.layer.maskedCorners = [.layerMinXMaxYCorner,
                                                .layerMaxXMaxYCorner]
        descriptionLabel.isUserInteractionEnabled = true
        descriptionLabel.addGestureRecognizer(tap)
        descriptionLabel.setMargins(16)
        descriptionLabel.clipsToBounds = true
        descriptionLabel.layer.cornerRadius = 10
    }
    
    func hideImage() {
        gameImage.isHidden = true
    }
    
    func showImage() {
        gameImage.isHidden = false
    }
}



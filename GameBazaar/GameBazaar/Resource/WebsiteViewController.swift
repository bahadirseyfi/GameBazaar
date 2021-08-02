//
//  WebsiteViewController.swift
//  GameBazaar
//
//  Created by bahadir on 6.06.2021.
//

import UIKit
import WebKit

final class WebsiteViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    private let webView = WKWebView()
    private var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.uiDelegate = self
        prepareWebView()
    }
    
    private func prepareWebView() {
        view.addSubview(webView)
        view.addSubview(activityIndicator)
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.color = .cyan
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10).isActive = true
    }
    
    func initWebView(urlString: String) {
        if let url = URL(string: urlString) {
            self.webView.load(URLRequest(url: url))
        }
    }
}

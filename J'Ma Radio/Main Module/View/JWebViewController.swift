//
//  JWebViewController.swift
//  J'Ma Radio
//
//  Created by Федор Рубченков on 13.03.2023.
//

import UIKit
import WebKit

class JWebViewController: UIViewController {
    
    private let url: URL
    private let activityIndicatorSize: CGFloat = 40
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        return view
    }()
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        return view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .j_backgroundColor()
        webView.navigationDelegate = self
        view.addSubview(webView)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        webView.isHidden = true
        webView.load(URLRequest(url: url))
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
        activityIndicator.frame = CGRect(x: (view.frame.width - activityIndicatorSize)/2.0, y: (view.frame.height - activityIndicatorSize)/2.0, width: activityIndicatorSize, height: activityIndicatorSize)
    }

}

extension JWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = true
            self.webView.isHidden = false
        }
    }
    
}

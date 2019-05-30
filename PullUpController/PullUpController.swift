//
//  PullUpController.swift
//  PullUpController
//
//  Created by Jose Manuel Solis Bulos on 5/30/19.
//  Copyright © 2019 Jose Manuel Solis Bulos. All rights reserved.
//

import UIKit
import WebKit

class PullUpController: UIViewController {

    lazy var draggableBar: UIImageView = {
        let draggableBar = UIImageView()
        draggableBar.image = UIImage(named: "closeBar")
        draggableBar.contentMode = .center
        draggableBar.translatesAutoresizingMaskIntoConstraints = false
        return draggableBar
    }()

    lazy var navigationContainer: UIView = {
        let navigationContainer = UIView()
        navigationContainer.backgroundColor = .white
        navigationContainer.translatesAutoresizingMaskIntoConstraints = false
        return navigationContainer
    }()

    lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "closeBtn"), for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return closeButton
    }()

    lazy var goBackButton: UIButton = {
        let goBackButton = UIButton()
        goBackButton.setImage(UIImage(named: "icBackExplorer"), for: .normal)
        goBackButton.translatesAutoresizingMaskIntoConstraints = false
        goBackButton.addTarget(self, action: #selector(goBackButtonTapped), for: .touchUpInside)
        return goBackButton
    }()

    lazy var urlDescriptionLabel: UILabel = {
        let urlDescriptionLabel = UILabel()
        urlDescriptionLabel.textAlignment = .center
        urlDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return urlDescriptionLabel
    }()

    lazy var goForwardButton: UIButton = {
        let goForwardButton = UIButton()
        goForwardButton.setImage(UIImage(named: "icNextExplorer"), for: .normal)
        goForwardButton.translatesAutoresizingMaskIntoConstraints = false
        goForwardButton.addTarget(self, action: #selector(goForwardButtonTapped), for: .touchUpInside)
        return goForwardButton
    }()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [progressView, webView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()

    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()

    lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    private let keyPathObserver: String =  "estimatedProgress"

    deinit {
        webView.removeObserver(self, forKeyPath: keyPathObserver)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addDraggableBar()
        addNavigationContainer()
        addCloseButton()
        addGoBackButton()
        addGoForwardButton()
        addURLDescriptionLabel()
        addStackView()

        configureNavigationContainer()

        setWebViewDelegate()
        setWebViewProgressObserver()

        loadWebSite()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.1) { [unowned self] in
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        }
    }

    private func addDraggableBar() {
        view.addSubview(draggableBar)
        draggableBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        draggableBar.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        draggableBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        draggableBar.heightAnchor.constraint(equalToConstant: 42).isActive = true
    }

    private func addNavigationContainer() {
        view.addSubview(navigationContainer)
        navigationContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navigationContainer.topAnchor.constraint(equalTo: draggableBar.bottomAnchor).isActive = true
        navigationContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        navigationContainer.heightAnchor.constraint(equalToConstant: 42).isActive = true
    }

    private func addCloseButton() {
        view.addSubview(closeButton)
        closeButton.leftAnchor.constraint(equalTo: navigationContainer.leftAnchor).isActive = true
        closeButton.topAnchor.constraint(equalTo: navigationContainer.layoutMarginsGuide.topAnchor).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 55).isActive = true
        closeButton.bottomAnchor.constraint(equalTo: navigationContainer.layoutMarginsGuide.bottomAnchor).isActive = true
    }

    private func addGoBackButton() {
        view.addSubview(goBackButton)
        goBackButton.leftAnchor.constraint(equalTo: closeButton.layoutMarginsGuide.rightAnchor).isActive = true
        goBackButton.topAnchor.constraint(equalTo: navigationContainer.layoutMarginsGuide.topAnchor).isActive = true
        goBackButton.widthAnchor.constraint(equalToConstant: 55).isActive = true
        goBackButton.bottomAnchor.constraint(equalTo: navigationContainer.layoutMarginsGuide.bottomAnchor).isActive = true
    }

    private func addGoForwardButton() {
        view.addSubview(goForwardButton)
        goForwardButton.widthAnchor.constraint(equalToConstant: 55).isActive = true
        goForwardButton.topAnchor.constraint(equalTo: navigationContainer.layoutMarginsGuide.topAnchor).isActive = true
        goForwardButton.rightAnchor.constraint(equalTo: navigationContainer.layoutMarginsGuide.rightAnchor, constant: -43).isActive = true
        goForwardButton.bottomAnchor.constraint(equalTo: navigationContainer.layoutMarginsGuide.bottomAnchor).isActive = true
    }

    private func addURLDescriptionLabel() {
        view.addSubview(urlDescriptionLabel)
        urlDescriptionLabel.leftAnchor.constraint(equalTo: goBackButton.layoutMarginsGuide.rightAnchor).isActive = true
        urlDescriptionLabel.topAnchor.constraint(equalTo: navigationContainer.layoutMarginsGuide.topAnchor).isActive = true
        urlDescriptionLabel.rightAnchor.constraint(equalTo: goForwardButton.layoutMarginsGuide.leftAnchor).isActive = true
        urlDescriptionLabel.bottomAnchor.constraint(equalTo: navigationContainer.layoutMarginsGuide.bottomAnchor).isActive = true
    }

    private func addStackView() {
        view.addSubview(stackView)
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: navigationContainer.bottomAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func configureNavigationContainer() {
        navigationContainer.clipsToBounds = true
        navigationContainer.layer.cornerRadius = 8
        navigationContainer.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }

    private func setWebViewDelegate() {
        webView.navigationDelegate = self
    }

    private func setWebViewProgressObserver() {
        webView.addObserver(self,
                            forKeyPath: #keyPath(WKWebView.estimatedProgress),
                            options: .new,
                            context: nil)
    }

    private func loadWebSite() {
        webView.load(URLRequest(url: URL(string: "https://www.ticketmaster.com")!))
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == keyPathObserver {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

    @objc func closeButtonTapped() {
        dismiss(animated: true)
    }

    @objc func goBackButtonTapped() {
        if webView.canGoBack {
            webView.goBack()
        }
    }

    @objc func goForwardButtonTapped() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
}

extension PullUpController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
        goBackButton.isEnabled = webView.canGoBack
        goForwardButton.isEnabled = webView.canGoForward
        urlDescriptionLabel.text = webView.url?.absoluteString.replacingOccurrences(of: "https://", with: "", options: [], range: nil)
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.isHidden = false
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        progressView.isHidden = true
    }
}

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

    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()

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

    lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        return panGestureRecognizer
    }()

    private var url: URL

    private let keyPathObserver: String =  "estimatedProgress"

    deinit {
        webView.removeObserver(self, forKeyPath: keyPathObserver)
    }

    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addContainerView()
        addDraggableBar()
        addNavigationContainer()
        addCloseButton()
        addGoBackButton()
        addGoForwardButton()
        addURLDescriptionLabel()
        addStackView()

        configurePresentationStyle()
        configureNavigationContainer()

        setWebViewDelegate()
        setWebViewProgressObserver()

        loadURL(url)

        containerView.addGestureRecognizer(panGestureRecognizer)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addGrayedBackground()
        moveViewToParentsCenter(containerView)
    }

    private func addContainerView() {
        view.addSubview(containerView)
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func addDraggableBar() {
        containerView.addSubview(draggableBar)
        draggableBar.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        draggableBar.topAnchor.constraint(equalTo: containerView.layoutMarginsGuide.topAnchor).isActive = true
        draggableBar.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        draggableBar.heightAnchor.constraint(equalToConstant: 42).isActive = true
    }

    private func addNavigationContainer() {
        containerView.addSubview(navigationContainer)
        navigationContainer.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        navigationContainer.topAnchor.constraint(equalTo: draggableBar.bottomAnchor).isActive = true
        navigationContainer.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        navigationContainer.heightAnchor.constraint(equalToConstant: 42).isActive = true
    }

    private func addCloseButton() {
        containerView.addSubview(closeButton)
        closeButton.leftAnchor.constraint(equalTo: navigationContainer.leftAnchor).isActive = true
        closeButton.topAnchor.constraint(equalTo: navigationContainer.layoutMarginsGuide.topAnchor).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 55).isActive = true
        closeButton.bottomAnchor.constraint(equalTo: navigationContainer.layoutMarginsGuide.bottomAnchor).isActive = true
    }

    private func addGoBackButton() {
        containerView.addSubview(goBackButton)
        goBackButton.leftAnchor.constraint(equalTo: closeButton.layoutMarginsGuide.rightAnchor).isActive = true
        goBackButton.topAnchor.constraint(equalTo: navigationContainer.layoutMarginsGuide.topAnchor).isActive = true
        goBackButton.widthAnchor.constraint(equalToConstant: 55).isActive = true
        goBackButton.bottomAnchor.constraint(equalTo: navigationContainer.layoutMarginsGuide.bottomAnchor).isActive = true
    }

    private func addGoForwardButton() {
        containerView.addSubview(goForwardButton)
        goForwardButton.widthAnchor.constraint(equalToConstant: 55).isActive = true
        goForwardButton.topAnchor.constraint(equalTo: navigationContainer.layoutMarginsGuide.topAnchor).isActive = true
        goForwardButton.rightAnchor.constraint(equalTo: navigationContainer.layoutMarginsGuide.rightAnchor, constant: -43).isActive = true
        goForwardButton.bottomAnchor.constraint(equalTo: navigationContainer.layoutMarginsGuide.bottomAnchor).isActive = true
    }

    private func addURLDescriptionLabel() {
        containerView.addSubview(urlDescriptionLabel)
        urlDescriptionLabel.leftAnchor.constraint(equalTo: goBackButton.layoutMarginsGuide.rightAnchor).isActive = true
        urlDescriptionLabel.topAnchor.constraint(equalTo: navigationContainer.layoutMarginsGuide.topAnchor).isActive = true
        urlDescriptionLabel.rightAnchor.constraint(equalTo: goForwardButton.layoutMarginsGuide.leftAnchor).isActive = true
        urlDescriptionLabel.bottomAnchor.constraint(equalTo: navigationContainer.layoutMarginsGuide.bottomAnchor).isActive = true
    }

    private func addStackView() {
        containerView.addSubview(stackView)
        stackView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: navigationContainer.bottomAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }

    private func addGrayedBackground() {
        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }
    }

    private func removeGrayedBackground() {
        UIView.animate(withDuration: 0.1) { [unowned self] in
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        }
    }

    private func configurePresentationStyle() {
        self.modalPresentationStyle = .overCurrentContext
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

    private func loadURL(_ url: URL) {
        webView.load(URLRequest(url: url))
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

    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .changed:
            webView.isUserInteractionEnabled = false
            if containerView.frame.origin.y < 0 {
                moveViewToParentsCenter(containerView)
            } else {
                removeGrayedBackground()
                dragView(containerView, with: recognizer)
            }
        case .ended:
            webView.isUserInteractionEnabled = true
            if containerView.frame.origin.y > view.frame.height / 2 {
                removeGrayedBackground()
                moveViewOutsideScreen(containerView)
            } else {
                moveViewToParentsCenter(containerView)
                addGrayedBackground()
            }
        default:
            break
        }
    }

    private func dragView(_ draggableView: UIView, with recognizer: UIPanGestureRecognizer) {
        self.view.bringSubviewToFront(draggableView)
        let yCoordinate = draggableView.center.y + recognizer.translation(in: containerView).y
        draggableView.center = CGPoint(x: draggableView.center.x, y: yCoordinate)
        recognizer.setTranslation(CGPoint.zero, in: draggableView)
    }

    private func moveViewToParentsCenter(_ view: UIView) {
        UIView.animate(withDuration: 0.3) { [unowned self] in
            view.center = self.view.center
        }
    }

    private func moveViewOutsideScreen(_ view: UIView) {
        UIView.animate(withDuration: 0.3, animations: { [unowned self] in
            self.view.center.y = self.view.frame.maxY
        }) { [unowned self] (_)  in
            self.dismiss(animated: true)
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

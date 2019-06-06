//
//  ViewController.swift
//  PullUpController
//
//  Created by Jose Manuel Solis Bulos on 5/30/19.
//  Copyright © 2019 Jose Manuel Solis Bulos. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    lazy var openButton: UIButton = {
        let openButton = UIButton()
        openButton.setTitle("Open", for: .normal)
        openButton.setTitleColor(.blue, for: .normal)
        openButton.translatesAutoresizingMaskIntoConstraints = false
        openButton.addTarget(self, action: #selector(openWebViewController), for: .touchUpInside)
        return openButton
    }()

    lazy var pullUpController = PullUpController(url: URL(string: "https://www.manuelbulos.com")!)

    override func viewDidLoad() {
        super.viewDidLoad()
        addButton()
    }

    private func addButton() {
        view.addSubview(openButton)
        openButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        openButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    @objc func openWebViewController() {
        let completion: () -> Void = {}
        present(pullUpController, animated: true, completion: completion)
    }
}

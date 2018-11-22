//
//  handleInternet.swift
//  Retainer
//
//  Created by NTGMM-02 on 12/11/18.
//  Copyright © 2018 NTGMM-02. All rights reserved.
//

import UIKit
class handleInternet:UIViewController{
    let reachability = Reachability()!
    let connectionView = UIView().getView(backgroundColor: .white)
    let imageView:UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = #imageLiteral(resourceName: "lost connection").withRenderingMode(.alwaysOriginal)
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFill
        return view
    }()
    let retryButton = UIButton().getButton(Title: "RETRY", Font: 20, Color: .black, image: nil, type: .system, bgColor: .clear, fontWeight: .bold)
    let label = UILabel().getLabel(Text: "You are offline, connect to the internet", Font: 17, Color: .black, weight: .medium)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        retryButton.addTarget(self, action: #selector(handleRetry), for: .touchUpInside)
        addobserverForConnection()
        }
    func addobserverForConnection(){
        reachability.whenReachable = {  _ in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
        do{
            try reachability.startNotifier()
        }
        catch{
            print("could not start notifier")
        }
    }
    @objc func handleRetry(){
        if reachability.connection != .none{
            self.dismiss(animated: true, completion: nil)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        reachability.stopNotifier()
    }
    func setupViews(){
        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(retryButton)
        retryButton.layer.cornerRadius = 10
        retryButton.layer.borderWidth = 2
        retryButton.layer.borderColor = UIColor.black.cgColor
        NSLayoutConstraint.activate([imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -15)])
        NSLayoutConstraint.activate([label.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15)])
        NSLayoutConstraint.activate([retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),retryButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 15),retryButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1, constant: 0),retryButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25, constant: 0)])
    }
}

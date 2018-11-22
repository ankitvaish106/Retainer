//
//  myAccount.swift
//  Retainer
//
//  Created by NTGMM-02 on 14/11/18.
//  Copyright © 2018 NTGMM-02. All rights reserved.
//

import UIKit
class myAccount:UIViewController{
    let topView = UIView().getView(backgroundColor: .black)
    let BottomView = UIView().getView(backgroundColor: .clear)
    let profileImage = UIImageView().getImageView(image: #imageLiteral(resourceName: "retainer_logo"), backgroundColor: .clear)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }
    func setupViews(){
        setupTopViews()
        setupBottomViews()
    }
    func setupTopViews(){
      view.addSubview(topView)
        NSLayoutConstraint.activate([topView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),topView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),topView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),topView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5, constant: 0)])
    }
    func setupBottomViews(){
        view.addSubview(BottomView)
        NSLayoutConstraint.activate([BottomView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),BottomView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),BottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),BottomView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5, constant: 0)])
    }
}

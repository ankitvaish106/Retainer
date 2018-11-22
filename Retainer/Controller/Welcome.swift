//
//  Welcome.swift
//  Retainer
//
//  Created by NTGMM-02 on 23/10/18.
//  Copyright © 2018 NTGMM-02. All rights reserved.
//

import UIKit
class Welcome:UIViewController{
    
    let topView = UIView().getView(backgroundColor: .clear)
    let bottomView = UIView().getView(backgroundColor: .clear)
    let logoImage = UIImageView().getImageView(image: #imageLiteral(resourceName: "retainer_logo").withRenderingMode(.alwaysOriginal), backgroundColor: .clear)
    let mainLabel = UILabel().getLabel(Text: "Get Your Lawer In Minutes", Font: 26, Color: .black, weight: .bold)
    let signInButton = UIButton().getButton(Title: "Sign In", Font: 16, Color: .white, image: nil, type: .system, bgColor: #colorLiteral(red: 0.178735362, green: 0.3213080802, blue: 0.1210859129, alpha: 1), fontWeight: .bold)
    let SignUpButton = UIButton().getButton(Title: "Sign Up", Font: 16, Color: .white, image: nil, type: .system, bgColor: #colorLiteral(red: 0.178735362, green: 0.3213080802, blue: 0.1210859129, alpha: 1), fontWeight: .bold)
    let AttorneysignInButton = UIButton().getButton(Title: "Attorney Sign In", Font: 20, Color: .white, image: nil, type: .system, bgColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), fontWeight: .bold)
    let NumberSignIn = UIButton().getButton(Title: "SignIn With Number", Font: 20, Color: .white, image: nil, type: .system, bgColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), fontWeight: .bold)
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(r: 119, g: 211, b: 83, a: 1)
        setupViews()
    }
    func setupViews(){
        view.addSubview(topView)
        view.addSubview(bottomView)
        view.addConstraintsWithFormat("V:|[v0(v1)][v1]|", views: topView,bottomView)
        view.addConstraintsWithFormat("H:|[v0]|", views: topView)
        view.addConstraintsWithFormat("H:|[v0]|", views: bottomView)
        setUpTopView()
        setUpBottomView()
        signInButton.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        SignUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        AttorneysignInButton.addTarget(self, action: #selector(handleAttorneysignIn), for: .touchUpInside)
        NumberSignIn.addTarget(self, action: #selector(handleNumberSignIn), for: .touchUpInside)
        
    }
    @objc func handleSignIn(){
        let controller =  AttornrySignIn()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @objc func handleSignUp(){
        let controller =  SignUp()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @objc func handleAttorneysignIn(){
        let controller =  AttornrySignIn()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @objc func handleNumberSignIn(){
        let controller =  SignInWithNo()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func setUpTopView(){
        topView.addSubview(logoImage)
        NSLayoutConstraint.activate([logoImage.centerXAnchor.constraint(equalTo: topView.centerXAnchor, constant: 0),logoImage.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: 0),logoImage.heightAnchor.constraint(equalTo: topView.widthAnchor, multiplier: 0.27, constant: 0),logoImage.widthAnchor.constraint(equalTo: topView.widthAnchor, multiplier: 0.27, constant: 0)])
        topView.addSubview(mainLabel)
        mainLabel.numberOfLines = 0
        mainLabel.textAlignment = .center
        mainLabel.font = UIFont(name: "verdana", size: 35)
        NSLayoutConstraint.activate([mainLabel.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 30),mainLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: 0)])
        mainLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width-20).isActive = true
        mainLabel.heightAnchor.constraint(equalToConstant: 150)
    }
    func setUpBottomView(){
        bottomView.addSubview(signInButton)
        signInButton.layer.cornerRadius = 5
        bottomView.addSubview(SignUpButton)
        SignUpButton.layer.cornerRadius = 5
        bottomView.addSubview(AttorneysignInButton)
        AttorneysignInButton.layer.cornerRadius = 5
        bottomView.addSubview(NumberSignIn)
        NumberSignIn.layer.cornerRadius = 5
        NSLayoutConstraint.activate([AttorneysignInButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor, constant: 0),AttorneysignInButton.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: 0),AttorneysignInButton.widthAnchor.constraint(equalTo: bottomView.widthAnchor, multiplier: 0.7, constant: 0),AttorneysignInButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07, constant: 0)])
        NSLayoutConstraint.activate([signInButton.bottomAnchor.constraint(equalTo: AttorneysignInButton.topAnchor, constant: -20),signInButton.leftAnchor.constraint(equalTo: AttorneysignInButton.leftAnchor, constant: 0),signInButton.widthAnchor.constraint(equalTo: AttorneysignInButton.widthAnchor, multiplier: 0.45, constant: 0),signInButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07, constant: 0)])
        NSLayoutConstraint.activate([SignUpButton.bottomAnchor.constraint(equalTo: AttorneysignInButton.topAnchor, constant: -20),SignUpButton.rightAnchor.constraint(equalTo: AttorneysignInButton.rightAnchor, constant: 0),SignUpButton.widthAnchor.constraint(equalTo: AttorneysignInButton.widthAnchor, multiplier: 0.45, constant: 0),SignUpButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07, constant: 0)])
        NSLayoutConstraint.activate([NumberSignIn.topAnchor.constraint(equalTo: AttorneysignInButton.bottomAnchor, constant: 20),NumberSignIn.rightAnchor.constraint(equalTo: AttorneysignInButton.rightAnchor, constant: 0),NumberSignIn.widthAnchor.constraint(equalTo: AttorneysignInButton.widthAnchor, constant: 0),NumberSignIn.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07, constant: 0)])
       
    }
}

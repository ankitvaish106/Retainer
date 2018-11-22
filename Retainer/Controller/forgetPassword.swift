//
//  forgetPassword.swift
//  Retainer
//
//  Created by NTGMM-02 on 12/11/18.
//  Copyright © 2018 NTGMM-02. All rights reserved.
//

import UIKit
import FirebaseAuth
class forgetPassword:UIViewController{
    let rechability = Reachability()!
    let topView = UIView().getView(backgroundColor: .clear)
    let bottomView = UIView().getView(backgroundColor: .clear)
    let logoImage = UIImageView().getImageView(image: #imageLiteral(resourceName: "retainer_logo").withRenderingMode(.alwaysOriginal), backgroundColor: .clear)
    let mainLabel = UILabel().getLabel(Text: "Forget Password", Font: 30, Color: .black, weight: .medium)
    let EmailTextField = UITextField().getTextField(placeholder: "Email", txColor: .black, cornerRadius: 5, bgcolor: .white, font: 18, fontWeight: .medium)
    let OtpButton = UIButton().getButton(Title: "Reset Password", Font: 16, Color: .white, image: nil, type: .system, bgColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), fontWeight: .bold)
    let AlreadyLabel = UILabel().getLabel(Text: "Remember Password?", Font: 18, Color: .white, weight: .bold)
    let SignInButton = UIButton().getButton(Title: "SignIn", Font: 18, Color: .black, image: nil, type: .system, bgColor: .clear, fontWeight: .bold)
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 119, g: 211, b: 83, a: 1)
        setupViews()
        setupMyActivityIndicator()
        SignInButton.addTarget(self, action: #selector(handleSignInButton), for: .touchUpInside)
        OtpButton.addTarget(self, action: #selector(sendforgetPassword), for: .touchUpInside)
    }
    @objc func sendforgetPassword(){
        if rechability.connection == .none{
            let controller = handleInternet()
            self.present(controller, animated: true, completion: nil)
            return
        }
        if EmailTextField.text == ""{
            ShowController(title: "Detail Required", message: "please enter valid email address", handler: makeResponder)
            return
        }
        myActivityIndicator.startAnimating()
        resetPassword { (Success) in
            if Success{
                self.myActivityIndicator.stopAnimating()
                self.ShowController(title: "Password Successfully send", message: "your reset password link has been send to \"\(self.EmailTextField.text!)\"", handler: nil)
            }
        }
        
    }
    func resetPassword(completionHandler:@escaping (_ Success:Bool)->Void){
        Auth.auth().sendPasswordReset(withEmail: EmailTextField.text!) { error in
            if error != nil{
                self.ShowController(title: "Error", message: error!.localizedDescription, handler: self.makeResponder)
                return
            }
            completionHandler(true)
        }
    }
    func makeResponder(alert:UIAlertAction!){
        EmailTextField.becomeFirstResponder()
    }
    func ShowController(title:String,message:String,handler:((UIAlertAction)->Void)?){
        let controller = UIAlertController(title:title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: handler)
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
    }
    @objc func handleSignInButton(){
        let controller = AttornrySignIn()
        self.present(controller, animated: true, completion: nil)
    }
    func setupViews(){
        
        view.addSubview(topView)
        view.addSubview(bottomView)
        view.addConstraintsWithFormat("V:|[v0(v1)][v1]|", views: topView,bottomView)
        view.addConstraintsWithFormat("H:|[v0]|", views: topView)
        view.addConstraintsWithFormat("H:|[v0]|", views: bottomView)
        setUpTopView()
        setUpBottomView()
    }
    func setUpTopView(){
        topView.addSubview(logoImage)
        topView.addSubview(mainLabel)
        NSLayoutConstraint.activate([logoImage.centerXAnchor.constraint(equalTo: topView.centerXAnchor, constant: 0),logoImage.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: -20),logoImage.heightAnchor.constraint(equalTo: topView.widthAnchor, multiplier: 0.27, constant: 0),logoImage.widthAnchor.constraint(equalTo: topView.widthAnchor, multiplier: 0.27, constant: 0)])
        NSLayoutConstraint.activate([mainLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor, constant: 0),mainLabel.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 10)])
    }
    func setUpBottomView(){
        bottomView.addSubview(EmailTextField)
        bottomView.addSubview(OtpButton)
        bottomView.addSubview(AlreadyLabel)
        bottomView.addSubview(SignInButton)
        EmailTextField.layer.cornerRadius = 5
        OtpButton.layer.cornerRadius = 5
        NSLayoutConstraint.activate([EmailTextField.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: 0),EmailTextField.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 0),EmailTextField.widthAnchor.constraint(equalTo: bottomView.widthAnchor, multiplier: 0.7, constant: 0),EmailTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.065, constant: 0)])
        NSLayoutConstraint.activate([OtpButton.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: 0),OtpButton.widthAnchor.constraint(equalTo: bottomView.widthAnchor, multiplier: 0.7, constant: 0),OtpButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07, constant: 0),OtpButton.topAnchor.constraint(equalTo: EmailTextField.bottomAnchor, constant: 20)])
        
        NSLayoutConstraint.activate([AlreadyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -30),AlreadyLabel.topAnchor.constraint(equalTo: OtpButton.bottomAnchor, constant: 20)])
        NSLayoutConstraint.activate([SignInButton.leftAnchor.constraint(equalTo: AlreadyLabel.rightAnchor, constant: 10),SignInButton.centerYAnchor.constraint(equalTo: AlreadyLabel.centerYAnchor, constant: 0)])
    }
    func setupMyActivityIndicator(){
        view.addSubview(myActivityIndicator)
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = true
        myActivityIndicator.color = .black
        let transform1 = CGAffineTransform(scaleX: 1.5, y: 1.5)
        myActivityIndicator.transform = transform1
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

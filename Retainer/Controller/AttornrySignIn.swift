//
//  AttornrySignIn.swift
//  Retainer
//
//  Created by NTGMM-02 on 23/10/18.
//  Copyright © 2018 NTGMM-02. All rights reserved.
//

import UIKit
import FirebaseAuth
class AttornrySignIn:UIViewController{
    let rechability = Reachability()!
    let topView = UIView().getView(backgroundColor: .clear)
    let bottomView = UIView().getView(backgroundColor: .clear)
    let logoImage = UIImageView().getImageView(image: #imageLiteral(resourceName: "retainer_logo").withRenderingMode(.alwaysOriginal), backgroundColor: .clear)
    let mainLabel = UILabel().getLabel(Text: "Attorney Sign In", Font: 30, Color: .black, weight: .medium)
    let signInButton = UIButton().getButton(Title: "Sign In", Font: 16, Color: .white, image: nil, type: .system, bgColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), fontWeight: .bold)
    let EmailTextField = UITextField().getTextField(placeholder: "Email", txColor: .black, cornerRadius: 5, bgcolor: .white, font: 18, fontWeight: .medium)
    let PasswordTextField = UITextField().getTextField(placeholder: "Password", txColor: .black, cornerRadius: 5, bgcolor: .white, font: 18, fontWeight: .medium)
    let forgetPasswordButton = UIButton().getButton(Title: "", Font: 20, Color: .black, image: nil, type: .system, bgColor: .clear, fontWeight: .light)
    let AlreadyLabel = UILabel().getLabel(Text: "Don't have an account?", Font: 18, Color: .white, weight: .bold)
    let SignUpButton = UIButton().getButton(Title: "SignUp", Font: 18, Color: .black, image: nil, type: .system, bgColor: .clear, fontWeight: .bold)
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    override func viewDidLoad(){
        view.backgroundColor = UIColor(r: 119, g: 211, b: 83, a: 1)
        setupViews()
        setupMyActivityIndicator()
        addObserver()
        signInButton.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        SignUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
       
    }
    func setupViews(){
        view.addSubview(topView)
        view.addSubview(bottomView)
        view.addConstraintsWithFormat("V:|[v0(v1)][v1]|", views: topView,bottomView)
        view.addConstraintsWithFormat("H:|[v0]|", views: topView)
        view.addConstraintsWithFormat("H:|[v0]|", views: bottomView)
        setUpTopView()
        setUpBottomView()
        PasswordTextField.isSecureTextEntry = true
        forgetPasswordButton.addTarget(self, action: #selector(handleForgetPassword), for: .touchUpInside)
        forgetPasswordButton.setAttributedTitle(NSAttributedString(string: "forget Password?", attributes: [NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue,NSAttributedStringKey.foregroundColor:UIColor.black,NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16, weight: .bold)]), for: .normal)
    }
    func setUpTopView(){
        topView.addSubview(logoImage)
        topView.addSubview(mainLabel)
        NSLayoutConstraint.activate([logoImage.centerXAnchor.constraint(equalTo: topView.centerXAnchor, constant: 0),logoImage.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: -20),logoImage.heightAnchor.constraint(equalTo: topView.widthAnchor, multiplier: 0.27, constant: 0),logoImage.widthAnchor.constraint(equalTo: topView.widthAnchor, multiplier: 0.27, constant: 0)])
        mainLabel.font = UIFont(name: "verdana", size: 35)
        NSLayoutConstraint.activate([mainLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor, constant: 0),mainLabel.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 10)])
    }
    func setUpBottomView(){
        bottomView.addSubview(EmailTextField)
        bottomView.addSubview(PasswordTextField)
        bottomView.addSubview(signInButton)
        bottomView.addSubview(AlreadyLabel)
        bottomView.addSubview(SignUpButton)
        bottomView.addSubview(forgetPasswordButton)
        EmailTextField.layer.cornerRadius = 5
        PasswordTextField.layer.cornerRadius = 5
        signInButton.layer.cornerRadius = 5
        NSLayoutConstraint.activate([EmailTextField.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: 0),EmailTextField.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 0),EmailTextField.widthAnchor.constraint(equalTo: bottomView.widthAnchor, multiplier: 0.7, constant: 0),EmailTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.065, constant: 0)])
        NSLayoutConstraint.activate([PasswordTextField.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: 0),PasswordTextField.topAnchor.constraint(equalTo: EmailTextField.bottomAnchor, constant: 30),PasswordTextField.widthAnchor.constraint(equalTo: bottomView.widthAnchor, multiplier: 0.7, constant: 0),PasswordTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.065, constant: 0)])
        NSLayoutConstraint.activate([signInButton.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: 0),signInButton.widthAnchor.constraint(equalTo: bottomView.widthAnchor, multiplier: 0.7, constant: 0),signInButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07, constant: 0),signInButton.topAnchor.constraint(equalTo: PasswordTextField.bottomAnchor, constant: 20)])
        NSLayoutConstraint.activate([AlreadyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -30),AlreadyLabel.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20)])
        NSLayoutConstraint.activate([SignUpButton.leftAnchor.constraint(equalTo: AlreadyLabel.rightAnchor, constant: 10),SignUpButton.centerYAnchor.constraint(equalTo: AlreadyLabel.centerYAnchor, constant: 0)])
        NSLayoutConstraint.activate([forgetPasswordButton.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: 0),forgetPasswordButton.topAnchor.constraint(equalTo: AlreadyLabel.bottomAnchor, constant: 15)])
    }
    func setupMyActivityIndicator(){
        view.addSubview(myActivityIndicator)
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = true
        myActivityIndicator.color = .black
        let transform1 = CGAffineTransform(scaleX: 1.5, y: 1.5)
        myActivityIndicator.transform = transform1
    }
    func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardhide), name: .UIKeyboardWillHide, object: nil)
    }
    @objc func keyboardShow(){
        let y1:CGFloat = -100
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.view.frame=CGRect(x: 0, y: y1, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    @objc func keyboardhide(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.view.frame=CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    @objc func handleSignIn(){
        if rechability.connection == .none{
            let controller = handleInternet()
            self.present(controller, animated: true, completion: nil)
            return
        }
        if EmailTextField.text == ""{
            ShowController(title: "Details Required", message: "Please Enter Email address", handler: EmailTextresponder)
            return
        }
        if PasswordTextField.text == ""{
            ShowController(title: "Details Required", message: "Please Enter Password", handler: PasswordTextresponder)
            return
        }
        myActivityIndicator.startAnimating()
        checkTheLoginDetails{ (Success) in
            if Success{
                self.myActivityIndicator.stopAnimating()
                self.ShowController(title: "Success", message: "Successfully login...", handler: self.presentMainPage)
            }
            if !Success{
                 self.myActivityIndicator.stopAnimating()
            }
        }
        
    }

    func EmailTextresponder(alert: UIAlertAction!){
        EmailTextField.becomeFirstResponder()
    }
    func PasswordTextresponder(alert: UIAlertAction!){
        PasswordTextField.becomeFirstResponder()
    }
    @objc func handleSignUp(){
        let controller =  SignUp()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func presentMainPage(alert:UIAlertAction){
        let pageToShow = mainPage()
        let controller = UINavigationController(rootViewController: pageToShow)
        self.present(controller, animated: true, completion: nil)
    }
    func checkTheLoginDetails(compleationHandler:@escaping (_ Success:Bool)->Void){
        Auth.auth().signIn(withEmail: EmailTextField.text!, password: PasswordTextField.text!) { (Result, error) in
            if error != nil{
                self.ShowController(title: "Error", message: error!.localizedDescription, handler: nil)
                print(error!.localizedDescription)
                compleationHandler(false)
                return
            }
            let userId = Result?.user.uid
            print(userId!)
            compleationHandler(true)
        }
    }
    func ShowController(title:String,message:String,handler:((UIAlertAction)->Void)?){
        let controller = UIAlertController(title:title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: handler)
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
    }
    
    @objc func handleForgetPassword(){
        let controller = forgetPassword()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
  
}

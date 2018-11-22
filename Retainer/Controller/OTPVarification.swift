//
//  OTPVarification.swift
//  Retainer
//
//  Created by NTGMM-02 on 15/11/18.
//  Copyright © 2018 NTGMM-02. All rights reserved.
//

import UIKit
import FirebaseAuth
class OTPVarification:UIViewController{
    let label = UILabel().getLabel(Text: "Enter OTP", Font: 25, Color: .black, weight: .bold)
    let otpTextField = UITextField().getTextField(placeholder: "Enter otp", txColor: .black, cornerRadius: 5, bgcolor: .white, font: 18, fontWeight: .medium)
    let button = UIButton().getButton(Title: "Varify Otp", Font: 20, Color: .white, image: nil, type: .system, bgColor: .black, fontWeight: .medium)
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    var varificationId:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 119, g: 211, b: 83, a: 1)
        setupViews()
        setupMyActivityIndicator()
        button.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
    }
    func setupViews(){
        view.addSubview(label)
        view.addSubview(otpTextField)
        view.addSubview(button)
        otpTextField.layer.cornerRadius = 5
        button.layer.cornerRadius = 5
        NSLayoutConstraint.activate([label.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50)])
        NSLayoutConstraint.activate([otpTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),otpTextField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),otpTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7, constant: 0),otpTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.065, constant: 0)])
        NSLayoutConstraint.activate([button.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7, constant: 0),button.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07, constant: 0),button.topAnchor.constraint(equalTo: otpTextField.bottomAnchor, constant: 20)])
    }
    func setupMyActivityIndicator(){
        view.addSubview(myActivityIndicator)
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = true
        myActivityIndicator.color = .black
        let transform1 = CGAffineTransform(scaleX: 1.5, y: 1.5)
        myActivityIndicator.transform = transform1
    }
    @objc func handleButton(){
        myActivityIndicator.startAnimating()
        checkOTP { (Success) in
            if Success{
                self.myActivityIndicator.stopAnimating()
                self.ShowController(title: "Success", message: "Successfully login...", handler: self.presentMainPage)
            }
        }
    }
    func checkOTP(completionHandler:@escaping (_ Success:Bool)->Void){
        if otpTextField.text == ""{
            ShowController(title: "Fill Required Details", message: "please enter valid otp", handler: otp)
            return
        }
        if let varificationId = varificationId{
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: varificationId,
                                                                     verificationCode:otpTextField.text!)
            Auth.auth().signInAndRetrieveData(with: credential) { authData, error in
                if ((error) != nil){
                    print(error!)
                    return
                }
                completionHandler(true)
                print(authData!.user)
            }
        }
    }
    func otp(alert: UIAlertAction!){
        otpTextField.becomeFirstResponder()
    }
    func ShowController(title:String,message:String,handler:((UIAlertAction)->Void)?){
        let controller = UIAlertController(title:title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: handler)
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
    }
    func presentMainPage(alert:UIAlertAction){
        let pageToShow = mainPage()
        let controller = UINavigationController(rootViewController: pageToShow)
        self.present(controller, animated: true, completion: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

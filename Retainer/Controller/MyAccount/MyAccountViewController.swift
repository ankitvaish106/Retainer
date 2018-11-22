//
//  MyAccountViewController.swift
//  Retainer
//
//  Created by NTGMM-02 on 14/11/18.
//  Copyright © 2018 NTGMM-02. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
class myAccount:UIViewController{
    let rechability = Reachability()!
    let topView = UIView().getView(backgroundColor: .black)
    let BottomView = UIView().getView(backgroundColor: .white)
    let profileImage = UIImageView().getImageView(image: #imageLiteral(resourceName: "retainer_logo"), backgroundColor: .black)
    var name = UILabel().getLabel(Text: "Name", Font: 25, Color: .white, weight: .bold)
    var phone = UILabel().getLabel(Text: "Mobile", Font: 20, Color: .white, weight: .bold)
    var email = UILabel().getLabel(Text: "Email", Font: 20, Color: .white, weight: .bold)
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.setupViews()
        setupMyActivityIndicator()
        if rechability.connection != .none{
            self.getdetail()
        }else{
            let controller = handleInternet()
            self.navigationController?.present(controller, animated: true, completion: nil)
        }
    }
    func checkInternet(){
        rechability.whenReachable = {  _ in
            DispatchQueue.main.async {
                self.getdetail()
            }
        }
        rechability.whenUnreachable = { _ in
            DispatchQueue.main.async {
                let controller = handleInternet()
                self.navigationController?.present(controller, animated: true, completion: nil)
            }
        }
        do{
            try rechability.startNotifier()
        }
        catch{
            print("could not start notifier")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        //checkInternet()
    }
    override func viewWillDisappear(_ animated: Bool) {
        rechability.stopNotifier()
    }
    func getdetail(){
        self.myActivityIndicator.startAnimating()
        self.getUserDetails { (Success) in
            if Success{
                self.myActivityIndicator.stopAnimating()
            }
            if !Success{
                self.myActivityIndicator.stopAnimating()
            }
        }
    }
    var userDetailGet:Bool = false
    func getUserDetails(completionHandler:@escaping (_ Success:Bool)->Void){
        if let id = Auth.auth().currentUser?.uid{
            let databaseRefrence = Database.database().reference(withPath: "Users")
            let UserRefrence = databaseRefrence.child("\(id)")
            UserRefrence.observe(.value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    completionHandler(false)
                    return
                }
                print(dictionary)
                self.name.text = dictionary["Name"] as? String ?? "Name"
                self.email.text = dictionary["email"] as? String ?? "email"
                self.phone.text = "\(dictionary["phoneNumber"] as? String ?? "Phone")"
                self.profileImage.loadImageUsingCacheWithUrlString(dictionary["profileImageUrl"] as? String ?? "email")
                completionHandler(true)
            })
        }
    }
    func setupMyActivityIndicator(){
        view.addSubview(myActivityIndicator)
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = true
        myActivityIndicator.color = .black
        let transform1 = CGAffineTransform(scaleX: 1.5, y: 1.5)
        myActivityIndicator.transform = transform1
    }
    func setupViews(){
        setupTopViews()
        profileImage.layer.cornerRadius = 15
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.borderWidth = 1
        name.font = UIFont(name: "Times New Roman", size: 25)
        phone.font = UIFont(name: "Times New Roman", size: 20)
        phone.font = UIFont(name: "Times New Roman", size: 20)
        setupBottomViews()
    }
    func setupTopViews(){
        view.addSubview(topView)
        NSLayoutConstraint.activate([topView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),topView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),topView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),topView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5, constant: 0)])
        topView.addSubview(profileImage)
        topView.addSubview(name)
        topView.addSubview(phone)
        topView.addSubview(email)
        NSLayoutConstraint.activate([profileImage.centerXAnchor.constraint(equalTo: topView.centerXAnchor, constant: 0),profileImage.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: -10),profileImage.widthAnchor.constraint(equalTo: topView.widthAnchor, multiplier: 0.35, constant: 0),profileImage.heightAnchor.constraint(equalTo: topView.widthAnchor, multiplier: 0.35, constant: 0)])
        NSLayoutConstraint.activate([name.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),name.centerXAnchor.constraint(equalTo: topView.centerXAnchor, constant: 0)])
        NSLayoutConstraint.activate([phone.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5),phone.centerXAnchor.constraint(equalTo: topView.centerXAnchor, constant: 0)])
        NSLayoutConstraint.activate([email.topAnchor.constraint(equalTo: phone.bottomAnchor, constant: 2),email.centerXAnchor.constraint(equalTo: topView.centerXAnchor, constant: 0)])
    }
    func setupBottomViews(){
        view.addSubview(BottomView)
        NSLayoutConstraint.activate([BottomView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),BottomView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),BottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),BottomView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5, constant: 0)])
    }
}


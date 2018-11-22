//
//  mainPage.swift
//  Retainer
//
//  Created by NTGMM-02 on 12/11/18.
//  Copyright © 2018 NTGMM-02. All rights reserved.
//

import UIKit
import FirebaseAuth
class mainPage:UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    let arrayOfContents:[modelForMainPage] = [modelForMainPage(image: "ss", name: "Looking for an Attorney?"),modelForMainPage(image: "ss", name: "Chat with Lawyer"),modelForMainPage(image: "ss", name: "My Account"),modelForMainPage(image: "ss", name: "My Lawyer")]
    var blackWindow = UIView()
    var IsSideMenuOpen:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setupnavigationController()
        setupViews()
    }
    func setupViews(){
        setupTopCollectionView()
        collectionView.register(mainPageTopView.self, forCellWithReuseIdentifier: "mainPageTopView")
        collectionView.register(mainPageBottomView.self, forCellWithReuseIdentifier: "mainPageBottomView")
    }
    func setupTopCollectionView(){
        view.addSubview(collectionView)

        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0{
            let controller = LookingForAttorneyViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
        if indexPath.item == 1{
            let controller = chatWithLawyer()
            self.navigationController?.pushViewController(controller, animated: true)
        }
        if indexPath.item == 2{
            let controller = myAccount()
            self.navigationController?.pushViewController(controller, animated: true)
        }
        if indexPath.item == 3{
            let controller = MyLawyers()
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var tableView:leftTableView = {
        let view = leftTableView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    func setupnavigationController(){
       // UINavigationBar.appearance().barTintColor = .black
        self.navigationController?.navigationBar.barTintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Menu Filled-50").withRenderingMode(.alwaysTemplate), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(handleMenu))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SignOut", style: .plain, target: self, action: #selector(handleSignOut))
    }

    @objc func handleSignOut(){
        let controller = UIAlertController(title: "Alert", message: "Are You sure you want to signout", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        controller.addAction(UIAlertAction(title: "Okay", style: .default, handler: SignOut))
       self.present(controller, animated: true, completion: nil)
    }
    func SignOut(alert:UIAlertAction){
        do{
            try Auth.auth().signOut()
        }
        catch{
            print("not able to signOut")
        }
        let controller = UINavigationController(rootViewController: Welcome())
        self.present(controller, animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfContents.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == arrayOfContents.count{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainPageBottomView", for: indexPath) as! mainPageBottomView
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainPageTopView", for: indexPath) as! mainPageTopView
        cell.label.text = self.arrayOfContents[indexPath.item].name
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 4{
             return CGSize(width: self.view.frame.width, height: (self.view.frame.height)/3 - 20)
        }
        return CGSize(width: self.view.frame.width/2, height: (self.view.frame.height)/3 + 10)
    }
}

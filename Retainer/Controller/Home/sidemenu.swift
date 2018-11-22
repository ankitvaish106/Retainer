//
//  sidemenu.swift
//  Retainer
//
//  Created by NTGMM-02 on 14/11/18.
//  Copyright © 2018 NTGMM-02. All rights reserved.
//

import UIKit
extension mainPage:UITableViewDelegate{
    @objc func handleMenu(){
        if !IsSideMenuOpen{
            if let window = UIApplication.shared.keyWindow{
                window.addSubview(blackWindow)
                let topmargin = navigationController!.topLayoutGuide.length
                window.addSubview(tableView)
                tableView.controller = self
                tableView.frame = CGRect(x: 0, y: topmargin+43, width: 0, height: view.frame.height)
                blackWindow.backgroundColor =  UIColor(white: 0, alpha: 0.5)
                blackWindow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDissmiss)))
                blackWindow.frame = CGRect(x: 0, y: topmargin+43, width: view.frame.width, height: view.frame.height)
                blackWindow.alpha = 0
                UIView.animate(withDuration: 0.5,delay:0,usingSpringWithDamping:1,initialSpringVelocity:3,options: .curveEaseOut,animations:{
                    self.blackWindow.alpha = 1
                    self.tableView.frame = CGRect(x: 0, y: topmargin+43, width: self.view.frame.width/2, height: self.view.frame.height)
                })
            }
            IsSideMenuOpen = !IsSideMenuOpen
        }else{
            handleDissmiss()
        }

    }
    @objc func  handleDissmiss(){
         IsSideMenuOpen = !IsSideMenuOpen
         let topmargin = navigationController!.topLayoutGuide.length
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackWindow.alpha = 0
            self.tableView.frame = CGRect(x: 0, y:topmargin+43, width: 0, height: self.view.frame.height)
        })
    }
}
class leftTableView:UITableView,UITableViewDelegate,UITableViewDataSource{
    
    private let titlesArray = ["Profile","News","Articles","Video","Music","SignOut"]
    weak var controller:mainPage?
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        delegate = self
        dataSource = self
        backgroundColor = .white
        register(sideMenuCell.self, forCellReuseIdentifier: "cell")
        separatorStyle = .none
        contentInset = UIEdgeInsets(top: 0, left: 0.0, bottom: 44.0, right: 0.0)
        showsVerticalScrollIndicator = false
        backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.item == titlesArray.count - 1{
           handleSignOut()
        }
    }
    func handleSignOut(){
        controller?.handleDissmiss()
        controller?.handleSignOut()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! sideMenuCell
        cell.textLabel!.text = titlesArray[indexPath.row]
        cell.isUserInteractionEnabled = (indexPath.row != 1 && indexPath.row != 3)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  44.0
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


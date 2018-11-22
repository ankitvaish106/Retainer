//
//  AttroneyForChat.swift
//  Retainer
//
//  Created by NTGMM-02 on 16/11/18.
//  Copyright © 2018 NTGMM-02. All rights reserved.
//

import UIKit
import Firebase
class AttroneysForChat:UITableViewController{
    let cellId = "cellId"
    
    var users = [user]()
    var messagesController: chatWithLawyer?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.register(UsersCell.self, forCellReuseIdentifier: cellId)
        fetchUser()
    }
    
    func fetchUser() {
        Database.database().reference().child("Attorneys").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user1 = user(dictionary: dictionary)
                user1.id = snapshot.key
                self.users.append(user1)
                
                //this will crash because of background thread, so lets use dispatch_async to fix
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                
            }
            
        }, withCancel: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UsersCell
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        if let profileImageUrl = user.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatViewToShow = chattingController(collectionViewLayout: UICollectionViewFlowLayout())
         let user = self.users[indexPath.row]
         chatViewToShow.user = user
         self.messagesController?.showChatControllerForUser(user)
    }
}

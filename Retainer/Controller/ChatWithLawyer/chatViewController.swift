//
//  chatViewController.swift
//  Retainer
//
//  Created by NTGMM-02 on 14/11/18.
//  Copyright © 2018 NTGMM-02. All rights reserved.
//

import UIKit
import Firebase
class chatWithLawyer:UITableViewController{
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    let label1 = UILabel().getLabel(Text: "You haven't chat with any Lawyer.", Font: 20, Color: .black, weight: .medium)
    let name = UILabel().getLabel(Text:"", Font: 20, Color: .white, weight: .medium)
    let titleView:UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAcknowlwgeView()
        observeUserMessages()
        view.backgroundColor = .white
        tableView.register(UsersCell.self, forCellReuseIdentifier: "UsersCell")
        navigationItem.titleView = titleView
        titleView.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
        titleView.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.text = "My Chats"
        NSLayoutConstraint.activate([name.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),name.centerYAnchor.constraint(equalTo: titleView.centerYAnchor, constant: 0)])
        tableView.allowsMultipleSelectionDuringEditing = true
        self.tableView.tableFooterView = UIView(frame: .zero)
        let image = #imageLiteral(resourceName: "edit")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
    }
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            Database.database().reference().child("user-messages").child(uid).child(messageId).observe(.childAdded, with: { (snapshot) in
                let userId =  snapshot.key
                self.fetchMessageWithMessageId(userId)
            }, withCancel: nil)
            
            
        }, withCancel: nil)
        
        ref.observe(.childRemoved, with: { (snapshot) in
            let key = snapshot.key
            self.messagesDictionary.removeValue(forKey: key)
            self.handleReloadTable()
        }, withCancel: nil)
        
        
    }
    
    func fetchMessageWithMessageId(_ messageId:String){
        let messagesReference = Database.database().reference().child("messages").child(messageId)
        messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
    
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary)
                let toId = message.chatPartnerId()
                self.messagesDictionary[toId] = message
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
            }
            
        }, withCancel: nil)
    }
    
    var timer:Timer?
    
    @objc func handleReloadTable(){
        self.messages = Array(self.messagesDictionary.values)
        self.messages.sort(by: { (message1, message2) -> Bool in
            
            return message1.timestamp!.int32Value > message2.timestamp!.int32Value
        })
        DispatchQueue.main.async(execute: {
            if self.messages.count == 0{
                self.label1.isHidden = false
            }else{
                self.label1.isHidden = true
            }
            self.tableView.reloadData()
        })
        
    }
    @objc func handleNewMessage() {
        let newMessageController = MyLawyers()
        self.navigationController?.pushViewController(newMessageController, animated: true)
    }
    func setupAcknowlwgeView(){
        view.addSubview(label1)
        label1.isHidden = true
        label1.numberOfLines = 0
        label1.textAlignment = .center
        label1.font = UIFont(name: "verdana", size: 25)
        label1.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width-20).isActive = true
        label1.heightAnchor.constraint(equalToConstant: 150)
        NSLayoutConstraint.activate([label1.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),label1.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)])
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersCell", for: indexPath) as! UsersCell
        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        let chatParterId = message.chatPartnerId()
        let ref = Database.database().reference().child("Attorneys").child(chatParterId)
        ref.observe(.value, with: { (snapshot) in
            guard let dictionary =  snapshot.value as? [String:AnyObject] else{ return }
            let user1 = user(dictionary: dictionary)
            user1.id = chatParterId
            self.showChatControllerForUser(user1)
            
        }, withCancel: nil)
        
    }
    func showChatControllerForUser(_ user: user) {
        let chatLogController = chattingController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        chatLogController.messageController = self
        navigationController?.pushViewController(chatLogController, animated: true)
    }
}

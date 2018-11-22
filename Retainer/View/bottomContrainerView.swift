//
//  bottomContrainerView.swift
//  Retainer
//
//  Created by NTGMM-02 on 16/11/18.
//  Copyright © 2018 NTGMM-02. All rights reserved.
//

import UIKit
class bottomConatinerView:UIView,UITextFieldDelegate{
    var chattingController:chattingController?{
        didSet{
            uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target:chattingController, action: #selector(chattingController?.handleUploadTap)))
            sendButton.addTarget(chattingController, action: #selector(chattingController?.handleSend), for: .touchUpInside)
        }
    }
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupcontainerView()
    }
    let uploadImageView = UIImageView()
    let sendButton = UIButton(type: .system)
    let separatorLineView = UIView()
    func  setupcontainerView(){
        addSubview(view)
        view.leftAnchor.constraint(equalTo: leftAnchor, constant: 2).isActive = true
        view.rightAnchor.constraint(equalTo: rightAnchor, constant: -2).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        setupUploadImage()
        setupsendButton()
        setupinputTextField()
       // setupSeparatorView()
    }
    let view:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    func setupUploadImage(){
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.image = UIImage(named: "upload_image_icon")
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(uploadImageView)
        uploadImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    func setupsendButton(){
        sendButton.setTitle("Send", for: UIControlState())
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    func setupinputTextField(){
        view.addSubview(self.inputTextField)
        inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    func setupSeparatorView(){
        separatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separatorLineView)
        separatorLineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        chattingController?.handleSend()
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

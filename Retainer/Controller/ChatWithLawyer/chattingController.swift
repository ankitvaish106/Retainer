//
//  chattingController.swift
//  Retainer
//
//  Created by NTGMM-02 on 16/11/18.
//  Copyright © 2018 NTGMM-02. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import AVFoundation
class chattingController:UICollectionViewController,UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var messages = [Message]()
    var messageController:chatWithLawyer?
    let name = UILabel().getLabel(Text: "", Font: 18, Color: .white, weight: .medium)
    let titleView:UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    var user: user? {
        didSet {
            navigationItem.titleView = titleView
            titleView.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
            titleView.addSubview(name)
            name.translatesAutoresizingMaskIntoConstraints = false
            name.text = user?.name
            NSLayoutConstraint.activate([name.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),name.centerYAnchor.constraint(equalTo: titleView.centerYAnchor, constant: 0)])
            observeMessages()
        }
    }
    func observeMessages(){
        guard let uid = Auth.auth().currentUser?.uid ,let toId = user?.id else{return}
        Database.database().reference().child("user-messages").child(uid).child(toId).observe(.childAdded, with: { (snapshot) in
            let messagesId = snapshot.key
            Database.database().reference().child("messages").child("\(messagesId)").observeSingleEvent(of: .value, with: { (snap) in
                guard let dictionary = snap.value as? [String:AnyObject] else{return}
                self.messages.append(Message(dictionary: dictionary))
                
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                    let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                    self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView?.register(chatMessagesCell.self, forCellWithReuseIdentifier: "chatMessagesCell")
        collectionView?.keyboardDismissMode = .interactive
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    @objc func handleUploadTap() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        present(imagePickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
               if let videoUrl = info[UIImagePickerControllerMediaURL] as? URL {
                    handleVideoSelectedForInfo(url: videoUrl as NSURL)
                }else{
                    handleImageSelectedForInfo(info as [String : AnyObject])
                }
                dismiss(animated: true, completion: nil)
    }
    private func handleVideoSelectedForInfo(url:NSURL){
        let filename = UUID().uuidString + ".mov"
        let storegRef = Storage.storage().reference().child("message_movies").child(filename)
        let ref  = storegRef.putFile(from: url as URL, metadata: nil) { (metadata, error) in
            if error != nil{
                print(error!)
                return
            }
            storegRef.downloadURL(completion: { (url, error) in
                if error != nil{
                    print(error!)
                    return
                }
                if let videoUrl = url?.absoluteString{
                    if let urlUrl = url?.absoluteURL{
                        if let thumbnailImage =  self.thumbnailImageForFileUrl(urlUrl){
                            self.uploadToFirebaseStorageUsingImage(thumbnailImage, completion: { (imageUrl) in
                                let properties: [String: AnyObject] = ["messages-images": imageUrl as AnyObject, "image-width": thumbnailImage.size.width as AnyObject, "image-height": thumbnailImage.size.height as AnyObject, "videoUrl": videoUrl as AnyObject]
                                self.sendMessageWithProperties(properties)
                                
                            })
                        }
                    }
                }
            })
        }
        // Add a progress observer to an upload task
        _ = ref.observe(.progress) { snapshot in
            if let completionUnitCount = snapshot.progress?.completedUnitCount{
                self.navigationItem.title = String(completionUnitCount)
            }
        }
        _ = ref.observe(.success, handler: { (snapshot) in
            self.navigationItem.title = self.user?.name
        })
    }
    fileprivate func thumbnailImageForFileUrl(_ fileUrl: URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
            
        } catch let err {
            print(err)
        }
        return nil
    }
    fileprivate func handleImageSelectedForInfo(_ info: [String: AnyObject]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            uploadToFirebaseStorageUsingImage(selectedImage, completion: { (imageUrl) in
                self.sendMessageWithImageUrl(imageUrl, image: selectedImage)
            })
        }
    }
    fileprivate func sendMessageWithImageUrl(_ imageUrl: String, image: UIImage) {
        let properties: [String: AnyObject] = ["messages-images": imageUrl as AnyObject, "image-width": image.size.width as AnyObject, "image-height": image.size.height as AnyObject]
        sendMessageWithProperties(properties)
    }
    fileprivate func uploadToFirebaseStorageUsingImage(_ image: UIImage, completion: @escaping (_ imageUrl: String) -> ()) {
        let imageName = UUID().uuidString
        let ref = Storage.storage().reference().child("messages_images").child(imageName)
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
            ref.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("Failed to upload image:", error!)
                    return
                }
                
                ref.downloadURL { (url, error) in
                    
                    if error != nil{
                        print(error ?? "error")
                        return
                    }
                    if let urlstring = url?.absoluteString{
                        completion(urlstring)
                        
                    }}
            }
        }
    }
    @objc func handleSend() {
        let properties = ["text": inputContainerView.inputTextField.text!]
        sendMessageWithProperties(properties as [String : AnyObject])
    }
   
    fileprivate func sendMessageWithProperties(_ properties: [String: AnyObject]) {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user!.id!
        let fromId = Auth.auth().currentUser!.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        var values:[String:AnyObject] = ["deleteId":childRef.key as AnyObject,"toId": toId as AnyObject, "fromId": fromId as AnyObject, "timestamp": timestamp as AnyObject]
        properties.forEach({values[$0] = $1})
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil{
                print(error!.localizedDescription)
                return
            }
            self.inputContainerView.inputTextField.text = nil
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(toId)
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId!: 1])
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId)
            recipientUserMessagesRef.updateChildValues([messageId!: 1])
        }
        
    }

    lazy var inputContainerView: bottomConatinerView = {
        let containerView = bottomConatinerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        containerView.chattingController = self
        return containerView
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    func setupKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    @objc func handleKeyboardDidShow() {
        if messages.count > 0 {
            let indexPath = IndexPath(item: messages.count - 1, section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
        }
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chatMessagesCell", for: indexPath) as! chatMessagesCell
        cell.chattingController = self
        let message = messages[indexPath.item]
        cell.message = message
        cell.messagesTextView.text = message.text
        setupCell(cell, message: message)
        if let text = message.text {
            cell.bubbelWidth?.constant = estimateFrameForText(text).width + 32
            cell.messagesTextView.isHidden = false
        } else if message.imageUrl != nil {
            cell.bubbelWidth?.constant = 200
            cell.messagesTextView.isHidden = true
        }
        cell.playButton.isHidden = message.videoUrl == nil
        cell.messageVideoView.isHidden = message.videoUrl == nil
        return cell
    }
    fileprivate func setupCell(_ cell: chatMessagesCell, message: Message) {
        if let profileImageUrl = self.user?.profileImageUrl {
            cell.profileImageInMessage.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        if message.fromId == Auth.auth().currentUser?.uid {
            //outgoing blue
            cell.bubbleView.backgroundColor = UIColor(r: 0, g: 137, b: 249)
            cell.messagesTextView.textColor = UIColor.white
            cell.profileImageInMessage.isHidden = true
            
            cell.bubbelrightAncher?.isActive = true
            cell.bubbelleftAncher?.isActive = false
            
        } else {
            //incoming gray
            cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            cell.messagesTextView.textColor = UIColor.black
            cell.profileImageInMessage.isHidden = false
            
            cell.bubbelrightAncher?.isActive = false
            cell.bubbelleftAncher?.isActive = true
        }
        
        if let messageImageUrl = message.imageUrl {
            cell.messageImage.loadImageUsingCacheWithUrlString(messageImageUrl)
            cell.messageImage.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.clear
        } else {
            cell.messageImage.isHidden = true
        }
    }
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    var height: CGFloat = 80
    let message = messages[indexPath.item]
    if let text = message.text {
        height = estimateFrameForText(text).height + 20
    }
    else if let imageWidth = message.image_width?.floatValue, let imageHeight = message.image_height?.floatValue {
        height = CGFloat(imageHeight / imageWidth * 200)
    }
    let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    fileprivate func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return  NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
    func performZoomInForStartingImageView(_ startingImageView: UIImageView) {
        
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = UIColor.red
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        
        if let keyWindow = UIApplication.shared.keyWindow {
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = UIColor.black
            blackBackgroundView?.alpha = 0
            keyWindow.addSubview(blackBackgroundView!)
            
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackBackgroundView?.alpha = 1
                self.inputContainerView.alpha = 0
                
                // h2 / w1 = h1 / w1
                // h2 = h1 / w1 * w1
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                
                zoomingImageView.center = keyWindow.center
                
            }, completion: { (completed) in
                //                    do nothing
            })
            
        }
    }
    @objc func handleZoomOut(_ tapGesture: UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            //need to animate back out to controller
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                self.inputContainerView.alpha = 1
                
            }, completion: { (completed) in
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
            })
        }
    }
}

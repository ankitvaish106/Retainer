//
//  chatMessageCell.swift
//  Retainer
//
//  Created by NTGMM-02 on 19/11/18.
//  Copyright © 2018 NTGMM-02. All rights reserved.
//

import UIKit
class chatMessagesCell: CollectionViewcell{
    
    var message: Message?
    var chattingController: chattingController?
    
    var bubbelWidth: NSLayoutConstraint?
    var bubbelrightAncher: NSLayoutConstraint?
    var bubbelleftAncher: NSLayoutConstraint?
    var startingFrame: CGRect?
    var blackBackgroundView: blackbackGroundView?
    var startingImageView: UIView?
    var zoomingView:videoView?
    var keyWindow:UIWindow?
    
    override func setupViews() {
        setupView()
        addgestureRecognizers()
    }
    func addgestureRecognizers(){
        messageImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageInMessages)))
        messageVideoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlemessageVideo)))
        //        messageVideoView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress)))
    }
    @objc func handleImageInMessages(_ tapGesture: UITapGestureRecognizer){
        if message?.videoUrl != nil {
            return
        }
        
        if let imageView = tapGesture.view as? UIImageView {
            self.chattingController?.performZoomInForStartingImageView(imageView)
        }
    }
    func setupView(){
        addSubview(bubbleView)
        bubbleView.layer.cornerRadius = 16
        bubbleView.layer.masksToBounds = true
        addSubview(messagesTextView)
        addSubview(profileImageInMessage)
        
        bubbleView.addSubview(messageImage)
        messageImage.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messageImage.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageImage.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messageImage.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        
        bubbleView.addSubview(playButton)
        playButton.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        
        bubbleView.addSubview(messageVideoView)
        messageVideoView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        messageVideoView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messageVideoView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageVideoView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor).isActive = true
        
        profileImageInMessage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageInMessage.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageInMessage.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageInMessage.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        bubbelrightAncher = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbelrightAncher?.isActive = true
        bubbelleftAncher = bubbleView.leftAnchor.constraint(equalTo: profileImageInMessage.rightAnchor, constant: 8)
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbelWidth = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbelWidth?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        messagesTextView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        messagesTextView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        messagesTextView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        messagesTextView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    let bubbleView = UIView().getView(backgroundColor: UIColor(r: 0, g: 137, b: 249))
    let messagesTextView: UITextView = {
        let tv = UITextView()
        tv.text = ""
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = .white
        tv.isEditable = false
        return tv
    }()
    
    let profileImageInMessage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let messageImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    let playButton = UIButton().getButton(Title: nil, Font: nil, Color: .black, image: #imageLiteral(resourceName: "play").withRenderingMode(.alwaysTemplate), type: .system, bgColor: .clear, fontWeight: .medium)
    
    let messageVideoView:UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    @objc func handlemessageVideo(tapGesture:UITapGestureRecognizer){
        if let view =  tapGesture.view{
            self.performZoomForPlayingVedio(view)
        }
    }
    func performZoomForPlayingVedio(_ startingImageView: UIView) {
        self.startingImageView = startingImageView
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        zoomingView = videoView(frame: startingFrame!)
        zoomingView?.message = self.message
        if  let KeyWindow = UIApplication.shared.keyWindow {
            keyWindow  = KeyWindow
            if let keyWindow = keyWindow {
                blackBackgroundView = blackbackGroundView(frame: keyWindow.frame)
                blackBackgroundView?.alpha = 0
                blackBackgroundView?.controller = self
                keyWindow.addSubview(blackBackgroundView!)
                keyWindow.addSubview(zoomingView!)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.blackBackgroundView?.alpha = 1
                    let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                    self.zoomingView?.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                    self.zoomingView?.center = keyWindow.center
                    if let url = self.message?.imageUrl{
                        self.zoomingView!.loadImageUsingCacheWithUrlString(url)
                    }
                    self.chattingController?.inputContainerView.isHidden = true
                }, completion: { (completed) in
                })
            }}
    }
    @objc func handleZoomOut(){
        zoomingView?.player?.pause()
        zoomingView?.tapView.isHidden = true
        zoomingView?.handleVedioView.isHidden = true
        zoomingView?.handleVedioView.removeFromSuperview()
        zoomingView?.startButton.isHidden = true
        zoomingView?.activityIndicatorView.stopAnimating()
        if let zoomOutImageView = zoomingView {
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                self.chattingController?.inputContainerView.isHidden = false
            }, completion: { (completed) in
                zoomOutImageView.removeFromSuperview()
                self.messageImage.isHidden = false
            })
        }
    }

}

//
//  VideoView.swift
//  Retainer
//
//  Created by NTGMM-02 on 20/11/18.
//  Copyright © 2018 NTGMM-02. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
class blackbackGroundView:UIView{
    weak var controller:chatMessagesCell?
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        setupViews()
    }
    let minimizeButton = UIButton().getButton(Title: "Cancel", Font: 20, Color: .white, image: nil, type: .system, bgColor: .clear, fontWeight: .medium)
    func setupViews(){
        setupminimizeButton()
        minimizeButton.addTarget(self, action: #selector(self.handleZoomOut), for: .touchUpInside)
    }
    @objc func handleZoomOut(){
        controller?.handleZoomOut()
    }
    func  setupminimizeButton(){
        addSubview(minimizeButton)
        NSLayoutConstraint.activate([minimizeButton.centerXAnchor.constraint(equalTo: centerXAnchor),minimizeButton.topAnchor.constraint(equalTo: topAnchor, constant: 50)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
class videoView:UIImageView{
    var message: Message?
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var isPlaying = true
    let tapView = UIView().getView(backgroundColor:.clear)
    let startButton = UIButton().getButton(Title: nil, Font: nil, Color: .black, image: #imageLiteral(resourceName: "play").withRenderingMode(.alwaysTemplate), type: .system, bgColor: .clear, fontWeight: .medium)
    let videoPlayerLabelLeft = UILabel().getLabel(Text: "00:00", Font: 13, Color: .white, weight: .medium)
    let videoPlayerLabelRight = UILabel().getLabel(Text: "00:00", Font: 13, Color: .white, weight: .medium)
    lazy var slider:UISlider = {
        let slide = UISlider()
        slide.minimumTrackTintColor = .red
        slide.maximumTrackTintColor = .white
        slide.setThumbImage(UIImage(named: "thumb"), for: .normal)
        slide.translatesAutoresizingMaskIntoConstraints = false
        return slide
    }()
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        aiv.color = .black
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()
    let playPauseButton = UIButton().getButton(Title: nil, Font: nil, Color: .white, image: #imageLiteral(resourceName: "pause").withRenderingMode(.alwaysOriginal), type: .system, bgColor: .clear, fontWeight: .medium)
    let handleVedioView = UIView().getView(backgroundColor: .clear)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        isUserInteractionEnabled = true
        layer.cornerRadius = 15
        layer.masksToBounds = true
        setupViews()
        videoPlayerLabelLeft.textAlignment = .left
        videoPlayerLabelLeft.textAlignment = .right
        tapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handletapView)))
        startButton.addTarget(self, action: #selector(self.handlePlay), for: .touchUpInside)
        handleVedioView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRemoveVedioView)))
        playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        slider.addTarget(self, action: #selector(handleSlideChange), for: .valueChanged)
    }
    
    func setupViews(){
        handleTapView()
        setUpStartButton()
        setupActivityIndicatorView()
    }
    
    func handleTapView(){
        addSubview(tapView)
        tapView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tapView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tapView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tapView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    func setUpStartButton(){
        addSubview(startButton)
        startButton.isHidden = false
        NSLayoutConstraint.activate([self.startButton.centerXAnchor.constraint(equalTo: centerXAnchor),self.startButton.centerYAnchor.constraint(equalTo: centerYAnchor)])
    }
    func setupPlayerView(){
        handleVedioView.addSubview(playPauseButton)
        playPauseButton.centerXAnchor.constraint(equalTo: handleVedioView.centerXAnchor).isActive = true
        playPauseButton.centerYAnchor.constraint(equalTo: handleVedioView.centerYAnchor).isActive = true
        
        handleVedioView.addSubview(videoPlayerLabelRight)
        handleVedioView.addSubview(videoPlayerLabelLeft)
        
        NSLayoutConstraint.activate([videoPlayerLabelRight.rightAnchor.constraint(equalTo: handleVedioView.rightAnchor, constant: -8),videoPlayerLabelRight.bottomAnchor.constraint(equalTo: handleVedioView.bottomAnchor),videoPlayerLabelRight.widthAnchor.constraint(equalToConstant: 50),videoPlayerLabelRight.heightAnchor.constraint(equalToConstant: 24)])
        NSLayoutConstraint.activate([videoPlayerLabelLeft.leftAnchor.constraint(equalTo: handleVedioView.leftAnchor, constant: 8),videoPlayerLabelLeft.bottomAnchor.constraint(equalTo: handleVedioView.bottomAnchor),videoPlayerLabelLeft.widthAnchor.constraint(equalToConstant: 50),videoPlayerLabelLeft.heightAnchor.constraint(equalToConstant: 24)])
        handleVedioView.addSubview(slider)
        NSLayoutConstraint.activate([slider.rightAnchor.constraint(equalTo: videoPlayerLabelRight.leftAnchor,constant:-5),slider.bottomAnchor.constraint(equalTo: handleVedioView.bottomAnchor),slider.heightAnchor.constraint(equalToConstant: 25),slider.leftAnchor.constraint(equalTo: videoPlayerLabelLeft.rightAnchor,constant:5)])
    }
    func setupVideoView(){
        addSubview(handleVedioView)
        handleVedioView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        handleVedioView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        handleVedioView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        handleVedioView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        handleVedioView.isHidden = true
    }
    var timer:Timer?
    @objc func handletapView(_ tapGesture: UITapGestureRecognizer){
        if let view = tapGesture.view{
            setuphandleVedioView(view)
            self.timer = Timer.scheduledTimer(timeInterval: 7, target: self, selector: #selector(self.handleRemoveVedioView), userInfo: nil, repeats: false)
        }
    }
    @objc func handleRemoveVedioView(){
        timer?.invalidate()
        handleVedioView.isHidden = true
    }
    @objc func handlePlay() {
        if let videoUrlString = message?.videoUrl, let url = URL(string: videoUrlString) {
            player = AVPlayer(url: url)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = bounds
            layer.addSublayer(playerLayer!)
            setupVideoView()
            setupPlayerView()
            player?.play()
            playerObservers()
            activityIndicatorView.startAnimating()
            playPauseButton.isHidden = true
            startButton.isHidden = true
        }
    }
    @objc func handlePlayPause(){
        if isPlaying{
            player?.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else{
            player?.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        isPlaying = !isPlaying
    }
    func playerObservers(){
        player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        let interval = CMTime(value: 1, timescale: 2)
        player?.addPeriodicTimeObserver(forInterval: interval, queue:DispatchQueue.main, using: { (completion) in
            let duration = CMTimeGetSeconds(completion)
            let seconds = String(format:"%02d", Int(duration.truncatingRemainder(dividingBy:60)))
            let minute = String(format:"%02d",Int(duration/60))
            self.videoPlayerLabelLeft.text = "\(minute):\(seconds)"
            if let durations = self.player?.currentItem?.duration {
                let durationSeconds = CMTimeGetSeconds(durations)
                self.slider.value =  Float(duration / durationSeconds)
            }
        })
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath ==  "currentItem.loadedTimeRanges"{
            activityIndicatorView.stopAnimating()
            playPauseButton.isHidden = false
            if let duration = player?.currentItem?.duration{
                let durationInSecond  = CMTimeGetSeconds(duration)
                let seconds = Int(durationInSecond.truncatingRemainder(dividingBy: 60))
                let minute = Int(durationInSecond) / 60
                let minuteInString = String(format: "%02d", minute)
                videoPlayerLabelRight.text = "\(minuteInString):\(seconds)"
            }
        }
        
    }
    func setupActivityIndicatorView(){
        addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([activityIndicatorView.centerXAnchor.constraint(equalTo:centerXAnchor),activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)])
    }
    @objc func handleSlideChange(){
        if let duration = player?.currentItem?.duration{
            let totalSecond = CMTimeGetSeconds(duration)
            let value = Float64(slider.value)*totalSecond
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            player?.seek(to: seekTime, completionHandler: { (completion) in
            })
        }
        
    }
    
    func setuphandleVedioView(_ view:UIView){
        self.handleVedioView.isHidden = false
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

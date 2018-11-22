//
//  mainPageView.swift
//  Retainer
//
//  Created by NTGMM-02 on 13/11/18.
//  Copyright © 2018 NTGMM-02. All rights reserved.
//

import UIKit
class mainPageTopView:CollectionViewcell{
    var label = UILabel().getLabel(Text: "", Font: 25, Color: .white, weight: .bold)
    let view = UIView().getView(backgroundColor: .black)
    let labelView = UIView().getView(backgroundColor: .black)
    var image = UIImageView().getImageView(image: #imageLiteral(resourceName: "dummy-avatar"), backgroundColor: .clear)
    override func setupViews() {
        backgroundColor = .white
        addSubview(view)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.addSubview(image)
        view.addSubview(labelView)
        NSLayoutConstraint.activate([view.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),view.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),view.topAnchor.constraint(equalTo: topAnchor, constant: 10),view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)])
        NSLayoutConstraint.activate([image.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),image.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -30),image.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5, constant: 0),image.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6, constant: 0)])
        NSLayoutConstraint.activate([labelView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),labelView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),labelView.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 0),labelView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)])
        labelView.addSubview(label)
        label.font = UIFont(name: "verdana", size: 20)
        label.numberOfLines = 0
        label.textAlignment = .center
        NSLayoutConstraint.activate([label.centerXAnchor.constraint(equalTo: labelView.centerXAnchor, constant: 0),label.centerYAnchor.constraint(equalTo: labelView.centerYAnchor, constant: 0)])
        label.widthAnchor.constraint(equalToConstant: bounds.size.width - 20).isActive = true
       // label.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
    }
}
class mainPageBottomView:CollectionViewcell{
    var label = UILabel().getLabel(Text: "", Font: 40, Color: .black, weight: .bold)
    let view = UIView().getView(backgroundColor: .white)
    var image = UIImageView().getImageView(image: #imageLiteral(resourceName: "dummy-avatar"), backgroundColor: .clear)
    let textArea:UITextView = {
        let view = UITextView()
        view.text = "This is featured attorney this will available as soon as we got the detail..."
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "verdana", size: 18)
        return view
    }()
    override func setupViews() {
        backgroundColor = .white
        addSubview(view)
        view.layer.cornerRadius = 15
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.layer.masksToBounds = true
        NSLayoutConstraint.activate([view.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),view.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),view.topAnchor.constraint(equalTo: topAnchor, constant: 15),view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)])
        view.addSubview(image)
        NSLayoutConstraint.activate([image.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),image.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),image.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8, constant: 0),image.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.85,constant: 0)])
        view.addSubview(textArea)
        NSLayoutConstraint.activate([textArea.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 5),textArea.topAnchor.constraint(equalTo: image.topAnchor, constant: -8),textArea.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5),textArea.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6, constant: 0)])
    }
}

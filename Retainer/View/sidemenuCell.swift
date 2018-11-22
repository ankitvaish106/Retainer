//
//  sidemenuCell.swift
//  Retainer
//
//  Created by NTGMM-02 on 14/11/18.
//  Copyright © 2018 NTGMM-02. All rights reserved.
//

import UIKit
class sideMenuCell: UITableViewCell {
    
    let separatorView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return  view
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        backgroundColor = .black
        
        textLabel!.font = UIFont.boldSystemFont(ofSize: 16.0)
        textLabel!.textColor = .white
        
        // -----
        separatorView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        addSubview(separatorView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel!.frame.origin.x = 8.0
        textLabel!.frame.size.width = self.frame.width - 16.0
        
        let height = UIScreen.main.scale == 1.5 ? 1.5 : 1.0 as CGFloat
        
        separatorView.frame = CGRect(x: 0.0, y: frame.size.height-height, width: frame.size.width*0.9, height: height)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        textLabel!.alpha = highlighted ? 0.5 : 1.0
    }
    
}

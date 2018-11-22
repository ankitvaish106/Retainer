//
//  extension.swift
//  starkCan
//
//  Created by NTGMM-02 on 06/08/18.
//  Copyright © 2018 NTGMM-02. All rights reserved.
//

import UIKit
extension UIColor {
    
    convenience public init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(r: r, g: g, b: b, a: 1)
    }
    
    convenience public init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    
}
extension UIView{
    func getView(backgroundColor:UIColor)->UIView{
        let view = UIView()
        view.backgroundColor = backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
extension UIImageView{
    func getImageView(image:UIImage,backgroundColor:UIColor)->UIImageView{
        let view = UIImageView()
        view.image = image
        view.backgroundColor = backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
extension UITextField{
    func getTextField(placeholder:String,txColor:UIColor,cornerRadius:CGFloat,bgcolor:UIColor,font:CGFloat,fontWeight:UIFont.Weight)->UITextField{
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = bgcolor
        tf.autocorrectionType = .no
        tf.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                               attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
        tf.autocapitalizationType = .none
        tf.font = UIFont.systemFont(ofSize: font, weight: fontWeight)
        tf.textColor = .black
        tf.layer.cornerRadius = cornerRadius
        tf.setLeftPaddingPoints(13)
        return tf
    }
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
}
extension UILabel{
    func getLabel(Text:String,Font:CGFloat,Color:UIColor,weight:UIFont.Weight)->UILabel{
        let label = UILabel()
        label.text = Text
        label.font = UIFont.systemFont(ofSize: Font, weight: weight)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Color
        return label
    }
}
extension UIButton{
    func getButton(Title:String?,Font:CGFloat?,Color:UIColor?,image:UIImage?,type:UIButtonType?,bgColor:UIColor,fontWeight:UIFont.Weight)->UIButton{
        let button:UIButton?
        if let type = type{
            button = UIButton(type: type)
        }else{
            button = UIButton()
        }
        button?.backgroundColor = bgColor
        button?.translatesAutoresizingMaskIntoConstraints = false
        if let Title = Title{
            button?.setTitle(Title, for: .normal)
            button?.setTitleColor(Color, for: .normal)
        }
        if let image = image{
            button?.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
            if let color = Color{
                 button?.tintColor = color
            }
           
        }
        if let font = Font{
            button?.titleLabel?.font = UIFont.systemFont(ofSize: font, weight: fontWeight)
        }
        return button!
    }
}
let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView{
    func loadImageUsingCacheWithUrlString(_ urlString: String) {
        
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            //download hit an error so lets return out
            if error != nil {
                print(error ?? "")
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    
                    self.image = downloadedImage
                }
            })
            
        }).resume()
    }
}
extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}

extension UIColor{
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
class CollectionViewcell:UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    func setupViews(){
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension Date {
    func dayOfWeek(gap:Double) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let minute:TimeInterval = 60.0
        let hour:TimeInterval = 60.0 * minute
        let day:TimeInterval = 24 * hour * gap
        return dateFormatter.string(from: self.addingTimeInterval(day)).capitalized
        // or use capitalized(with: locale) if you want
    }
    func getTime(gap:Double)->String{
        let timestamp = Date().timeIntervalSince1970
        let minute:TimeInterval = 60.0
        let hour:TimeInterval = 60.0 * minute
        let day:TimeInterval = 24 * hour * gap + timestamp
        let timestampDate = Date(timeIntervalSince1970: day)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: timestampDate)
    }
}
extension UIView{
    public func addConstraintsWithFormat(_ format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}


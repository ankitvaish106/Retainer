//
//  SignUp.swift
//  Retainer
//
//  Created by NTGMM-02 on 23/10/18.
//  Copyright © 2018 NTGMM-02. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase
class SignUp:UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    let rechability = Reachability()!
    let topView = UIView().getView(backgroundColor: .clear)
    let bottomView = UIView().getView(backgroundColor: .clear)
    let logoImage = UIImageView().getImageView(image:#imageLiteral(resourceName: "dummy-avatar").withRenderingMode(.alwaysOriginal), backgroundColor: .clear)
    let changePicture = UIButton().getButton(Title: nil, Font: nil, Color: .black, image: #imageLiteral(resourceName: "edit").withRenderingMode(.alwaysOriginal), type: .system, bgColor: .white, fontWeight: .medium)
    let FullName = UITextField().getTextField(placeholder: "Full Name", txColor: .black, cornerRadius: 5, bgcolor: .white, font: 18, fontWeight: .medium)
    let EmailTextField = UITextField().getTextField(placeholder: "Email", txColor: .black, cornerRadius: 5, bgcolor: .white, font: 18, fontWeight: .medium)
    let PasswordTextField = UITextField().getTextField(placeholder: "Password", txColor: .black, cornerRadius: 5, bgcolor: .white, font: 18, fontWeight: .medium)
    let phoneNo = UITextField().getTextField(placeholder: "Phone No", txColor: .black, cornerRadius: 5, bgcolor: .white, font: 18, fontWeight: .medium)
    let radioButton = UIButton().getButton(Title: "", Font: 15, Color: .black, image: nil, type: nil, bgColor: .white, fontWeight: .medium)
    let TermLabel = UILabel().getLabel(Text: "I agree with the Terms of Use", Font: 16, Color: .white, weight: .medium)
    let CreateAccountButton = UIButton().getButton(Title: "Create Your Account", Font: 16, Color: .white, image: nil, type: .system, bgColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), fontWeight: .bold)
    let AlreadyLabel = UILabel().getLabel(Text: "Already have an account?", Font: 18, Color: .white, weight: .bold)
    let SignInButton = UIButton().getButton(Title: "SignIn", Font: 18, Color: .black, image: nil, type: .system, bgColor: .clear, fontWeight: .bold)
    var selectedImage:UIImage?
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    override func viewDidLoad() {
        view.backgroundColor = UIColor(r: 119, g: 211, b: 83, a: 1)
        setupViews()
        setupMyActivityIndicator()
        addObserver()
        CreateAccountButton.addTarget(self, action: #selector(handleCreateAccount), for: .touchUpInside)
        changePicture.addTarget(self, action: #selector(handleProfileImage), for: .touchUpInside)
    }
    func setupViews(){
        view.addSubview(topView)
        view.addSubview(bottomView)
        view.addConstraintsWithFormat("V:|[v0(v1)][v1]|", views: topView,bottomView)
        view.addConstraintsWithFormat("H:|[v0]|", views: topView)
        view.addConstraintsWithFormat("H:|[v0]|", views: bottomView)
        setUpTopView()
        setUpBottomView()
        PasswordTextField.isSecureTextEntry = true
    }
    func setUpTopView(){
        topView.addSubview(logoImage)
        logoImage.layer.cornerRadius = 15
        logoImage.layer.masksToBounds = true
        logoImage.layer.borderColor = UIColor.black.cgColor
        logoImage.layer.borderWidth = 1
        NSLayoutConstraint.activate([logoImage.centerXAnchor.constraint(equalTo: topView.centerXAnchor, constant: 0),logoImage.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: -20),logoImage.heightAnchor.constraint(equalTo: topView.widthAnchor, multiplier: 0.27, constant: 0),logoImage.widthAnchor.constraint(equalTo: topView.widthAnchor, multiplier: 0.27, constant: 0)])
        topView.addSubview(changePicture)
        changePicture.layer.cornerRadius = 15
        changePicture.layer.masksToBounds = true
        NSLayoutConstraint.activate([changePicture.bottomAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 5),changePicture.rightAnchor.constraint(equalTo: logoImage.rightAnchor, constant: 5),changePicture.heightAnchor.constraint(equalToConstant: 30),changePicture.widthAnchor.constraint(equalToConstant: 30)])
    }
    func setUpBottomView(){
        topView.addSubview(FullName)
        bottomView.addSubview(EmailTextField)
        bottomView.addSubview(PasswordTextField)
        bottomView.addSubview(phoneNo)
        bottomView.addSubview(radioButton)
        bottomView.addSubview(TermLabel)
        bottomView.addSubview(CreateAccountButton)
        bottomView.addSubview(AlreadyLabel)
        bottomView.addSubview(SignInButton)
        FullName.layer.cornerRadius = 5
        EmailTextField.layer.cornerRadius = 5
        PasswordTextField.layer.cornerRadius = 5
        CreateAccountButton.layer.cornerRadius = 5
        radioButton.layer.cornerRadius = 12.5
        radioButton.addTarget(self, action: #selector(handleRadio), for: .touchUpInside)
        SignInButton.addTarget(self, action: #selector(handleSignInButton), for: .touchUpInside)
        NSLayoutConstraint.activate([FullName.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: 0),FullName.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: -70),FullName.widthAnchor.constraint(equalTo: bottomView.widthAnchor, multiplier: 0.7, constant: 0),FullName.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.065, constant: 0)])
        NSLayoutConstraint.activate([EmailTextField.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: 0),EmailTextField.topAnchor.constraint(equalTo: FullName.bottomAnchor, constant: 10),EmailTextField.widthAnchor.constraint(equalTo: bottomView.widthAnchor, multiplier: 0.7, constant: 0),EmailTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.065, constant: 0)])
        NSLayoutConstraint.activate([PasswordTextField.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: 0),PasswordTextField.topAnchor.constraint(equalTo: EmailTextField.bottomAnchor, constant: 10),PasswordTextField.widthAnchor.constraint(equalTo: bottomView.widthAnchor, multiplier: 0.7, constant: 0),PasswordTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.065, constant: 0)])
        NSLayoutConstraint.activate([phoneNo.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: 0),phoneNo.topAnchor.constraint(equalTo: PasswordTextField.bottomAnchor, constant: 10),phoneNo.widthAnchor.constraint(equalTo: bottomView.widthAnchor, multiplier: 0.7, constant: 0),phoneNo.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.065, constant: 0)])
        NSLayoutConstraint.activate([radioButton.leftAnchor.constraint(equalTo: PasswordTextField.leftAnchor, constant: 0),radioButton.topAnchor.constraint(equalTo: phoneNo.bottomAnchor, constant: 20),radioButton.heightAnchor.constraint(equalToConstant: 25),radioButton.widthAnchor.constraint(equalToConstant: 25)])
        NSLayoutConstraint.activate([TermLabel.leftAnchor.constraint(equalTo: radioButton.rightAnchor, constant: 10),TermLabel.centerYAnchor.constraint(equalTo: radioButton.centerYAnchor, constant: 0)])
        NSLayoutConstraint.activate([CreateAccountButton.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: 0),CreateAccountButton.topAnchor.constraint(equalTo: TermLabel.bottomAnchor, constant: 30),CreateAccountButton.widthAnchor.constraint(equalTo: bottomView.widthAnchor, multiplier: 0.7, constant: 0),CreateAccountButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.065, constant: 0)])
        NSLayoutConstraint.activate([AlreadyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -30),AlreadyLabel.topAnchor.constraint(equalTo: CreateAccountButton.bottomAnchor, constant: 20)])
        NSLayoutConstraint.activate([SignInButton.leftAnchor.constraint(equalTo: AlreadyLabel.rightAnchor, constant: 10),SignInButton.centerYAnchor.constraint(equalTo: AlreadyLabel.centerYAnchor, constant: 0)])
    }
    func setupMyActivityIndicator(){
        view.addSubview(myActivityIndicator)
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = true
        myActivityIndicator.color = .black
        let transform1 = CGAffineTransform(scaleX: 1.5, y: 1.5)
        myActivityIndicator.transform = transform1
    }
    func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardhide), name: .UIKeyboardWillHide, object: nil)
    }
    @objc func keyboardShow(){
        let y1:CGFloat = -100
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.view.frame=CGRect(x: 0, y: y1, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    @objc func keyboardhide(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.view.frame=CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    @objc func handleCreateAccount(){
        if rechability.connection == .none{
            let controller = handleInternet()
            self.present(controller, animated: true, completion: nil)
            return
        }
        if FullName.text == ""{
            ShowController(title: "Details Required", message: "Please Enter Full Name", handler: FullNameresponder)
           return
        }
        if EmailTextField.text == ""{
            ShowController(title: "Details Required", message: "Please Enter Email", handler: EmailTextresponder)
           return
        }
        if PasswordTextField.text == ""{
            ShowController(title: "Details Required", message: "Please Enter Password", handler: PasswordTextresponder)
          return
        }
        if phoneNo.text == ""{
            ShowController(title: "Details Required", message: "Please Enter phone Number", handler: phoneNoTextresponder)
            return
        }
        if toggled{
            ShowController(title: "Details Required", message: "Please check the term and condition", handler: nil)
            return
        }
        myActivityIndicator.startAnimating()
        registerUserWithDetails { (Success) in
            if Success{
                self.myActivityIndicator.stopAnimating()
                self.ShowController(title: "Success", message: "You are Successfully Register with us", handler: self.Welcome)
            }
            if !Success{
                self.myActivityIndicator.stopAnimating()
            }
        }
    }
    func FullNameresponder(alert: UIAlertAction!){
        FullName.becomeFirstResponder()
    }
    func EmailTextresponder(alert: UIAlertAction!){
         EmailTextField.becomeFirstResponder()
    }
    func PasswordTextresponder(alert: UIAlertAction!){
        PasswordTextField.becomeFirstResponder()
    }
    func phoneNoTextresponder(alert: UIAlertAction!){
        phoneNo.becomeFirstResponder()
    }
    func Welcome(alert: UIAlertAction!)
    {
        let pageToShow = mainPage()
        let controller = UINavigationController(rootViewController: pageToShow)
        self.present(controller, animated: true, completion: nil)
    }
    @objc func handleProfileImage(){
        let controller = UIAlertController(title: "Upload Profile Picture", message: "Choose one for Uploading Picture", preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: "From Camera", style: .default, handler: OpenCamera))
        controller.addAction(UIAlertAction(title: "From Gallary", style: .default, handler: OpenGallary))
        controller.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        if let popoverController = controller.popoverPresentationController{
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        present(controller, animated: true, completion: nil)
      
    }
    func OpenCamera(alert: UIAlertAction!)
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    func OpenGallary(alert: UIAlertAction!)
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerEditedImage"] as? UIImage{
            self.selectedImage = image
            logoImage .image = image
        }else{
            if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
                self.selectedImage = image
                logoImage .image = image
            }
        }

        dismiss(animated:true, completion: nil)
    }
    func registerUserWithDetails(completionHandler: @escaping (_ Success:Bool)->Void){
        Auth.auth().createUser(withEmail: EmailTextField.text!, password: PasswordTextField.text!) { (User, error) in
            if error != nil{
                print(error?.localizedDescription)
                return
            }
            let imageName = UUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
            
            if let profileImage = self.logoImage.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                
                storageRef.putData(uploadData, metadata: nil, completion: { (metadeta, error) in
                    
                    if error != nil {
                        print(error ?? "")
                        return
                    }
                    
                    storageRef.downloadURL { (url, error) in
                        
                        if error != nil{
                            print(error ?? "error")
                            completionHandler(false)
                            return
                        }
                        if let urlstring = url?.absoluteString{
                            
                            let values = ["email": self.EmailTextField.text!,"Name":self.FullName.text!,"profileImageUrl": urlstring,"phoneNumber":self.phoneNo.text!] as [String : Any]
                            
                            self.resisterUserInDatabase(user: (User?.user)!, values: values as [String : AnyObject])
                            
                        }}
                })
                
            }
            
            completionHandler(true)
        }
    }
    func resisterUserInDatabase(user:User,values:[String : AnyObject]){
        let databaseRef = Database.database().reference().child("Users")
        let userId = user.uid
        let childRef = databaseRef.child(userId)
        childRef.updateChildValues(values)
    }
    func ShowController(title:String,message:String,handler:((UIAlertAction)->Void)?){
        let controller = UIAlertController(title:title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: handler)
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
    }
    var toggled:Bool = true
    @objc func handleSignInButton(){
        let controller = AttornrySignIn()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @objc func handleRadio(){
        handleToggled(toggled: self.toggled)
    }
    func handleToggled(toggled:Bool){
        if toggled{
            self.radioButton.setTitle("✓", for: .normal)
        }else{
            self.radioButton.setTitle("", for: .normal)
        }
        self.toggled = !toggled
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


//
//  SignupController.swift
//
//  Created by Mac Book on 30.10.16.
//  Copyright © 2018 raccoonsquare@gmail.com All rights reserved.
//

import FacebookLogin
import FacebookCore
import Foundation
import UIKit

class SignupController: UIViewController, UITextFieldDelegate, LoginButtonDelegate {
    
    @IBOutlet weak var usernameSeparator: UIView!
    @IBOutlet weak var fullnameSeparator: UIView!
    @IBOutlet weak var passwordSeparator: UIView!
    @IBOutlet weak var emailSeparator: UIView!
    
    @IBOutlet weak var fbRegularSignupButton: UIButton!
    
    @IBOutlet weak var usernameEditText: UITextField!
    @IBOutlet weak var fullnameEditText: UITextField!
    @IBOutlet weak var passwordEditText: UITextField!
    @IBOutlet weak var emailEditText: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var navTitle: UINavigationItem!
    
    var facebookButton = FBLoginButton(permissions: [.publicProfile, .email])
    
    var fbdata : [String : AnyObject]!
    
    var usernameError : Bool = false;
    var fullnameError : Bool = false;
    var emailError : Bool = false;
    var passwordError : Bool = false;
    
    var username : String = "";
    var fullname : String = "";
    var password : String = "";
    var email : String = "";
    
    var sex : Int = 0;
    var sex_orientation : Int = 1;
    var age : Int = 18;
    
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.usernameEditText.tag = 0
        self.fullnameEditText.tag = 1
        self.passwordEditText.tag = 2
        self.emailEditText.tag = 3
        
        self.usernameEditText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.fullnameEditText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.passwordEditText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.emailEditText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        signupButton.addTarget(self, action: #selector(self.signUpPressed), for: .touchUpInside)
        
        self.usernameEditText.delegate = self
        self.fullnameEditText.delegate = self
        self.passwordEditText.delegate = self
        self.emailEditText.delegate = self
        
        if AccessToken.current != nil{
            
            self.logoutFromFacebook()
        }
        
        facebookButton.delegate = self
        view.addSubview(facebookButton)
        
        facebookButton.translatesAutoresizingMaskIntoConstraints = false
        
        facebookButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        facebookButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        
        self.setLoginButtonTitle()
        
        if (!Constants.FACEBOOK_AUTHORIZATION) {
            
            self.facebookButton.isHidden = true
            self.fbRegularSignupButton.isHidden = true
            
        } else {
            
            if (iApp.sharedInstance.getFacebookId().count > 1) {
                
                self.regularSignup()
                
            } else {
                
                self.facebookSignup()
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        if ((error) != nil) {
            
            print(error!)
            
        } else if result!.isCancelled {
            
            print("User cancelled login.")
            
        } else {
            
            self.setLoginButtonTitle()
            
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            
            if result!.grantedPermissions.contains("email") {
                
                self.readFacebookData()
            }
            
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
        return
    }
    
//    func loginButtonDidCompleteLogin(_ loginButton: FBLoginButton, result: LoginResult) {
//
//        switch result {
//
//        case .cancelled:
//
//            print("User cancelled login.")
//
//
//        case .failed(let error):
//
//            print("Error")
//
//        case .success(let grantedPermissions, _, _):
//
//            self.readFacebookData()
//        }
//
//    }
//
//    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
//
//        return
//    }
    
    func readFacebookData() {
        
        if (AccessToken.current != nil) {
            
            GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil) {
                    
                    self.fbdata = result as? [String : AnyObject]
                    
                    iApp.sharedInstance.setFacebookId(fbId: (self.fbdata["id"] as! String?)!)
                    iApp.sharedInstance.setFacebookName(fbName: (self.fbdata["name"] as! String?)!)
                    iApp.sharedInstance.setFacebookEmail(fbEmail: (self.fbdata["email"] as! String?)!)
                    
                    // print(FBSDKAccessToken.current().userID)
                    
                    self.logoutFromFacebook(); // Kill Access token
                    
                    self.loginByFacebook(fbId: iApp.sharedInstance.getFacebookId())
                }
            })
        }
    }
    
    func setLoginButtonTitle() {
        
        let buttonText = NSAttributedString(string: NSLocalizedString("action_facebook_signup", comment: ""))
        self.facebookButton.setAttributedTitle(buttonText, for: .normal)
        self.facebookButton.setAttributedTitle(buttonText, for: .focused)
        self.facebookButton.setAttributedTitle(buttonText, for: .selected)
    }
    
    func logoutFromFacebook() {
        
        self.setLoginButtonTitle()
        
        let loginManager: LoginManager = LoginManager()
        loginManager.logOut()
    }
    
    func regularSignup() {
        
        self.fbRegularSignupButton.isHidden = false
        self.facebookButton.isHidden = true
    }
    
    func facebookSignup() {
        
        self.setLoginButtonTitle()
        
        self.fbRegularSignupButton.isHidden = true
        self.facebookButton.isHidden = false
    }
    
    @IBAction func regularSignupClick(_ sender: Any) {
        
        iApp.sharedInstance.setFacebookId(fbId: "")
        iApp.sharedInstance.setFacebookName(fbName: "")
        iApp.sharedInstance.setFacebookEmail(fbEmail: "")
        
        self.facebookSignup()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
            
        case self.usernameEditText:
            
            self.fullnameEditText.becomeFirstResponder()
            break
            
        case self.fullnameEditText:
            
            self.passwordEditText.becomeFirstResponder()
            break
            
        case self.passwordEditText:
            
            self.emailEditText.becomeFirstResponder()
            break
            
        default:
            
            textField.resignFirstResponder()
        }
        
        return true
    }
    

    @IBAction func userTappedBackground(sender: AnyObject) {
        
        view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 0.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        switch(textField.tag) {
            
        case 0:
            
            if (self.usernameError) {
                
                self.usernameError = false
                
                self.usernameSeparator.backgroundColor = UIColor.lightGray
            }
            
            break
            
        case 1:
            
            if (self.fullnameError) {
                
                self.fullnameError = false
                
                self.fullnameSeparator.backgroundColor = UIColor.lightGray
            }
            
            break
            
        case 2:
            
            if (self.passwordError) {
                
                self.passwordError = false
                
                self.passwordSeparator.backgroundColor = UIColor.lightGray
            }
            
            break
            
        default:
            
            if (self.emailError) {
                
                self.emailError = false
                
                self.emailSeparator.backgroundColor = UIColor.lightGray
            }
            
            break
        }
    }
    
    @objc func signUpPressed(sender: UIButton!) {
        
        username = self.usernameEditText.text!;
        fullname = self.fullnameEditText.text!;
        password = self.passwordEditText.text!;
        email = self.emailEditText.text!;
        
        if (username.count == 0) {
            
            self.usernameError = true
            
            self.usernameSeparator.backgroundColor = UIColor.red
        }
        
        if (fullname.count == 0) {
            
            self.fullnameError = true
            
            self.fullnameSeparator.backgroundColor = UIColor.red
        }
        
        if (email.count == 0) {
            
            self.emailError = true
            
            self.emailSeparator.backgroundColor = UIColor.red
        }
        
        if (password.count == 0) {
            
            self.passwordError = true
            
            self.passwordSeparator.backgroundColor = UIColor.red
        }
        
        if (!usernameError && !fullnameError && !emailError && !passwordError) {
            
            self.view.endEditing(true)
            
            self.signup(username: username, fullname: fullname, password: password, email: email);
        }
    }
    
    func signup(username: String, fullname: String, password: String, email: String) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_SIGNUP)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&username=" + username + "&fullname=" + fullname + "&password=" + password + "&email=" + email + "&fcm_regId=" + iApp.sharedInstance.getFcmRegId() + "&sex=" + String(self.sex) + "&year=2000" + "&day=1" + "&month=1" + "&facebookId=" + iApp.sharedInstance.getFacebookId() + "&age=" + String(self.age) + "&sex_orientation=" + String(self.sex_orientation) + "&appType=" + String(Constants.APP_TYPE_IOS) + "&lang=en" + "&hash=" + Helper.MD5(string: Helper.MD5(string: username) + Constants.CLIENT_SECRET);
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    print(response)
                    
                    if (responseError == false) {
                        
                        let accessToken = response["accessToken"] as! String;
                        
                        iApp.sharedInstance.setAccessToken(access_token: accessToken);
                        
                        DispatchQueue.global(qos: .background).async {
                            
                            //Get account array
                            let accountArray = response["account"] as! [AnyObject]
                            
                            iApp.sharedInstance.authorize(Response: accountArray[0]);
                            
                            DispatchQueue.main.async {
                                
                                let storyboard = UIStoryboard(name: "Content", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "TabController")
                                
                                // not root navigation controller
                                
                                // let navigationController = UINavigationController(rootViewController: vc)
                                
                                vc.modalPresentationStyle = .fullScreen
                                
                                self.present(vc, animated: true, completion: nil)
                            }
                        }
                        
                    } else {
                        
                        var error_code = 0;
                        
                        if let error_c = response["error_code"] as? String {
                            
                            error_code = Int(error_c)!
                            
                        } else {
                            
                           error_code = response["error_code"] as! Int
                        }
                        
                        switch error_code {
                            
                            case Constants.ERROR_CLIENT_ID:
                            
                                DispatchQueue.global(qos: .background).async {
                                
                                    DispatchQueue.main.async {
                                    
                                        let alert = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: "CLEINT_ID Incorrect or not the same in both config files! Make correct settings in config files!", preferredStyle: UIAlertController.Style.alert)
                                    
                                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                                    
                                        // show the alert
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                }
                            
                                break;
                            
                            case Constants.ERROR_CLIENT_SECRET:
                            
                                DispatchQueue.global(qos: .background).async {
                                
                                    DispatchQueue.main.async {
                                    
                                        let alert = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: "CLEINT_SECRET Incorrect or not the same in both config files! Make correct settings in config files!", preferredStyle: UIAlertController.Style.alert)
                                    
                                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                                    
                                        // show the alert
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                }
                            
                                break;
                            
                            case Constants.ERROR_LOGIN_TAKEN:
                            
                                DispatchQueue.global(qos: .background).async {
                                
                                    DispatchQueue.main.async {
                                    
                                        let alert = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: NSLocalizedString("login_taken_message", comment: ""), preferredStyle: UIAlertController.Style.alert)
                                    
                                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                                    
                                        // show the alert
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                }
                            
                                break;
                            
                            case Constants.ERROR_EMAIL_TAKEN:
                            
                                DispatchQueue.global(qos: .background).async {
                                
                                    DispatchQueue.main.async {
                                    
                                        let alert = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: NSLocalizedString("email_taken_message", comment: ""), preferredStyle: UIAlertController.Style.alert)
                                    
                                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                                    
                                        // show the alert
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                }
                            
                                break;
                            
                            default:
                                
                                var error_type: Int;
                                
                                if let l_error_type = response["error_type"] as? String {
                                    
                                    error_type = Int((l_error_type))!
                                    
                                } else {
                                    
                                    error_type = response["error_type"] as! Int
                                }
                                
                                switch error_type {
                                    
                                    case 0:
                                        
                                        DispatchQueue.global(qos: .background).async {
                                            
                                            DispatchQueue.main.async {
                                                
                                                let alert = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: NSLocalizedString("username_error", comment: ""), preferredStyle: UIAlertController.Style.alert)
                                                
                                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                                                
                                                // show the alert
                                                self.present(alert, animated: true, completion: nil)
                                                
                                                self.usernameError = true
                                                
                                                self.usernameSeparator.backgroundColor = UIColor.red
                                            }
                                        }
                                    
                                        break;
                                    
                                    case 1:
                                    
                                        DispatchQueue.global(qos: .background).async {
                                        
                                            DispatchQueue.main.async {
                                            
                                                let alert = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: NSLocalizedString("password_error", comment: ""), preferredStyle: UIAlertController.Style.alert)
                                            
                                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                                            
                                                // show the alert
                                                self.present(alert, animated: true, completion: nil)
                                            
                                                self.passwordError = true
                                            
                                                self.passwordSeparator.backgroundColor = UIColor.red
                                            }
                                        }
                                    
                                        break;
                                    
                                    case 2:
                                    
                                        DispatchQueue.global(qos: .background).async {
                                        
                                            DispatchQueue.main.async {
                                            
                                                let alert = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: NSLocalizedString("email_error", comment: ""), preferredStyle: UIAlertController.Style.alert)
                                            
                                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                                            
                                                // show the alert
                                                self.present(alert, animated: true, completion: nil)
                                            
                                                self.emailError = true
                                            
                                                self.emailSeparator.backgroundColor = UIColor.red
                                            }
                                        }
                                    
                                    break;
                                    
                                    case 4:
                                    
                                        DispatchQueue.global(qos: .background).async {
                                            
                                            DispatchQueue.main.async {
                                                
                                                let alert = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: NSLocalizedString("msg_signup_error_500", comment: ""), preferredStyle: UIAlertController.Style.alert)
                                                
                                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                                                
                                                // show the alert
                                                self.present(alert, animated: true, completion: nil)
                                            }
                                        }
                                    
                                    break;
                                    
                                    default:
                                        
                                        DispatchQueue.global(qos: .background).async {
                                            
                                            DispatchQueue.main.async {
                                                
                                                let alert = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: NSLocalizedString("fullname_error", comment: ""), preferredStyle: UIAlertController.Style.alert)
                                                
                                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                                                
                                                // show the alert
                                                self.present(alert, animated: true, completion: nil)
                                                
                                                self.fullnameError = true
                                                
                                                self.fullnameSeparator.backgroundColor = UIColor.red
                                            }
                                        }
                                    
                                        break
                                    
                                }
                            
                                break;
                        }
                    }
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                    }
                    
                } catch let error2 as NSError {
                    
                    print(error2)
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                    }
                }
            }
            
        }).resume();
    }
    
    func loginByFacebook(fbId: String) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_LOGINBYFACEBOOK)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&facebookId=" + fbId + "&ios_fcm_regId=" + iApp.sharedInstance.getFcmRegId();
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async() {
                    
                    self.serverRequestEnd();
                }
                
                print("start auth error")
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        if (response["accessToken"] as? String != nil) {
                            
                            let accessToken = response["accessToken"] as! String;
                            
                            iApp.sharedInstance.setAccessToken(access_token: accessToken);
                            
                            // all right. start to read auth data
                            
                            DispatchQueue.global(qos: .background).async {
                                
                                //Get account array
                                let accountArray = response["account"] as! [AnyObject]
                                
                                iApp.sharedInstance.authorize(Response: accountArray[0]);
                                
                                DispatchQueue.main.async {
                                    
                                    // run main content storyboard
                                    
                                    let storyboard = UIStoryboard(name: "Content", bundle: nil)
                                    let vc = storyboard.instantiateViewController(withIdentifier: "TabController")
                                    
                                    // not root navigation controller
                                    
                                    // let navigationController = UINavigationController(rootViewController: vc)
                                    
                                    vc.modalPresentationStyle = .fullScreen
                                    
                                    self.present(vc, animated: true, completion: nil)
                                }
                            }
                            
                        } else {
                            
                            // login error
                            // check account state
                            
                            var accountState: Int = 0;
                            
                            if (Constants.SERVER_ENGINE_VERSION > 1) {
                                
                                accountState = Int((response["account_state"] as? String)!)!
                                
                            } else {
                                
                                // old server engine
                                
                                accountState = Int((response["state"] as? String)!)!
                            }
                            
                            // for new version
                            // let accoutState = Int((response["account_state"] as? String)!)
                            
                            if (accountState == Constants.ACCOUNT_STATE_BLOCKED) {
                                
                                // account blocked
                                
                                DispatchQueue.global(qos: .background).async {
                                    
                                    DispatchQueue.main.async {
                                        
                                        // show message with error
                                        
                                        let alert = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: NSLocalizedString("alert_account_blocked", comment: ""), preferredStyle: UIAlertController.Style.alert)
                                        
                                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                                        
                                        // show the alert
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                }
                            }
                            
                        }
                        
                    } else {
                        
                        // go to signup with facebook
                        
                        // self.regularSignup()
                    }
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                        
                        if (iApp.sharedInstance.getFacebookId().count > 0) {
                            
                            self.regularSignup()
                            
                        } else {
                            
                            self.facebookSignup()
                        }
                    }
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                    }
                }
            }
            
        }).resume();
    }
    
    func serverRequestStart() {
        
        LoadingIndicatorView.show(NSLocalizedString("label_loading", comment: ""));
    }
    
    func serverRequestEnd() {
        
        LoadingIndicatorView.hide();
    }

}

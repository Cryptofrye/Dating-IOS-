//
//  PrepareSignupController.swift
//
//  Created by Mac Book on 07.03.18.
//  Copyright © 2018 raccoonsquare@gmail.com All rights reserved.
//

import UIKit

class PrepareSignupController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var ageSeparator: UIView!
    
    @IBOutlet weak var ageEditText: UITextField!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var selectGenderButton: UIButton!
    @IBOutlet weak var selectSexOrientationButton: UIButton!
    
    @IBOutlet weak var navTitle: UINavigationItem!
    
    var sexOrientationError : Bool = false;
    var ageError : Bool = false;
    
    var sex : Int = 0; // 0 = male, 1 = female
    var sex_orientation : Int = 0;
    var age : Int = 0;
    
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.ageEditText.tag = 0
        
        self.ageEditText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        nextButton.addTarget(self, action: #selector(self.nextPressed), for: .touchUpInside)
        
        self.ageEditText.delegate = self
        
        self.updateView();
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    @IBAction func selectGenderClick(_ sender: Any) {
        
        let alertController = UIAlertController(title: nil, message: NSLocalizedString("label_sex_select", comment: ""), preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
            
        }
        
        alertController.addAction(cancelAction)
        
        let action_0 = UIAlertAction(title: NSLocalizedString("label_male", comment: ""), style: .default) { action in
            
            self.sex = 0; // Male
            
            self.updateView();
        }
        
        alertController.addAction(action_0)
        
        let action_1 = UIAlertAction(title: NSLocalizedString("label_female", comment: ""), style: .default) { action in
            
            self.sex = 1; // Female
            
            self.updateView();
        }
        
        alertController.addAction(action_1)
        
        if let popoverController = alertController.popoverPresentationController {
            
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func selectSexOrientationClick(_ sender: Any) {
        
        let alertController = UIAlertController(title: nil, message: NSLocalizedString("label_sex_orientation_select", comment: ""), preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
            
        }
        
        alertController.addAction(cancelAction)
        
        let action_0 = UIAlertAction(title: NSLocalizedString("label_sex_orientation_1", comment: ""), style: .default) { action in
            
            self.sex_orientation = 1;
            
            self.updateView();
        }
        
        alertController.addAction(action_0)
        
        let action_1 = UIAlertAction(title: NSLocalizedString("label_sex_orientation_2", comment: ""), style: .default) { action in
            
            self.sex_orientation = 2;
            
            self.updateView();
        }
        
        alertController.addAction(action_1)
        
        let action_2 = UIAlertAction(title: NSLocalizedString("label_sex_orientation_3", comment: ""), style: .default) { action in
            
            self.sex_orientation = 3;
            
            self.updateView();
        }
        
        alertController.addAction(action_2)
        
        let action_3 = UIAlertAction(title: NSLocalizedString("label_sex_orientation_4", comment: ""), style: .default) { action in
            
            self.sex_orientation = 4;
            
            self.updateView();
        }
        
        alertController.addAction(action_3)
        
        if let popoverController = alertController.popoverPresentationController {
            
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if  (segue.identifier == "showNextSignup") {
            
            // Create a new variable to store the instance of SignupController
            let destinationVC = segue.destination as! SignupController
            destinationVC.age = self.age
            destinationVC.sex = self.sex
            destinationVC.sex_orientation = self.sex_orientation
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxLength = 3
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    @IBAction func userTappedBackground(_ sender: Any) {
        
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
            
            if (self.ageError) {
                
                self.ageError = false
                
                self.ageSeparator.backgroundColor = UIColor.lightGray
            }
            
            break
            
        default:
            
            break
        }
    }
    
    @objc func nextPressed(sender: UIButton!) {
        
        self.ageError = false;
        self.sexOrientationError = false;
        
        if (ageEditText.text?.count == 0) {
            
            self.age = 0;
            
        } else {
            
            self.age = Int(ageEditText.text!)!
        }
        
        
        if (self.age < 18 ) {
            
            let alert = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: NSLocalizedString("msg_age_error_1", comment: ""), preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            self.ageError = true
            
            self.ageSeparator.backgroundColor = UIColor.red
        }
        
        if (self.age > 110) {
            
            let alert = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: NSLocalizedString("msg_age_error_2", comment: ""), preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            self.ageError = true
            
            self.ageSeparator.backgroundColor = UIColor.red
        }
        
        if (self.sex_orientation == 0) {
            
            let alert = UIAlertController(title: Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String, message: NSLocalizedString("msg_sex_orientation_error", comment: ""), preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            // error true
            self.sexOrientationError = true
            
        }
        
        if (!ageError && !sexOrientationError) {
            
            self.view.endEditing(true)
            
            self.nextStep();
        }
    }
    
    func nextStep() {
        
        self.performSegue(withIdentifier: "showNextSignup", sender: self)
    }
    
    func updateView() {
        
        //
        
        selectGenderButton.setTitle(NSLocalizedString("label_gender", comment: "") + ": " + Dating.getGender(sex: self.sex), for: .normal);
        
        if (self.sex_orientation == 0) {
            
            selectSexOrientationButton.setTitle(NSLocalizedString("label_sex_orientation_select", comment: ""), for: .normal);
            
        } else {
            
            selectSexOrientationButton.setTitle(NSLocalizedString("label_sex_orientation", comment: "") + ": " + Dating.getSexOrientation(sex_orientation: self.sex_orientation), for: .normal);
        }
    }
    
    
    func serverRequestStart() {
        
        LoadingIndicatorView.show(NSLocalizedString("label_loading", comment: ""));
    }
    
    func serverRequestEnd() {
        
        LoadingIndicatorView.hide();
    }
    
}


//
//  ProfileSettingsController.swift
//  SocialApp
//
//  Created by raccoonsquare@gmail.com on 08.03.18.
//  Copyright © 2018 Ifsoft. All rights reserved.
//

import UIKit
import Darwin

class ProfileSettingsController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var uploadIndicator: UIActivityIndicatorView!
    
    var fullname: String = "";
    var location: String = "";
    var facebookPage: String = "";
    var instagramPage: String = "";
    
    var bio: String = "";
    
    var sex: Int = 0;
    var age: Int = 0;
    var sex_orientation: Int = 0;
    var height: Int = 0;
    var weight: Int = 0;
    
    var year: Int = 0;
    var month: Int = 0;
    var day: Int = 0;
    
    var relationshipStatus: Int = 0;
    var politicalViews: Int = 0;
    var worldViews: Int = 0;
    var personalPriority: Int = 0;
    var importantInOthers: Int = 0;
    var smokingViews: Int = 0;
    var alcoholViews: Int = 0;
    var lookingFor: Int = 0;
    var genderLike: Int = 0;
    
    var modified: Bool = false;
    
    var imgMode: Int = 0 // 0 - photo, 1 - cover
    
    var saveButton = UIBarButtonItem()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        saveButton = UIBarButtonItem(barButtonSystemItem: .save , target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem  = saveButton
        
        modify(modified: false)
        
        self.fullname = iApp.sharedInstance.getFullname()
        self.location = iApp.sharedInstance.getLocation()
        self.facebookPage = iApp.sharedInstance.getFacebookPage()
        self.instagramPage = iApp.sharedInstance.getInstagramPage()
        self.sex = iApp.sharedInstance.getSex()
        
        self.age = iApp.sharedInstance.getAge()
        self.sex_orientation = iApp.sharedInstance.getSexOrientation()
        self.height = iApp.sharedInstance.getHeight()
        self.weight = iApp.sharedInstance.getWeight()
        
        self.bio = iApp.sharedInstance.getBio()
        
        self.year = iApp.sharedInstance.getYear()
        self.month = iApp.sharedInstance.getMonth()
        self.day = iApp.sharedInstance.getDay()
        
        self.relationshipStatus = iApp.sharedInstance.getRelationshipStatus()
        self.politicalViews = iApp.sharedInstance.getPoliticalViews()
        self.worldViews = iApp.sharedInstance.getWorldViews()
        self.personalPriority = iApp.sharedInstance.getPersonalPriority()
        self.importantInOthers = iApp.sharedInstance.getImportantInOthers()
        self.smokingViews = iApp.sharedInstance.getSmokingViews()
        self.alcoholViews = iApp.sharedInstance.getAlcoholViews()
        self.lookingFor = iApp.sharedInstance.getLookingFor()
        self.genderLike = iApp.sharedInstance.getGenderLike()

        self.uploadIndicator.isHidden = true;
        
        self.photoView.layer.borderWidth = 1
        self.photoView.layer.masksToBounds = false
        self.photoView.layer.borderColor = UIColor.white.cgColor
        self.photoView.layer.cornerRadius = self.photoView.frame.height/2
        self.photoView.clipsToBounds = true
        
        self.coverView.clipsToBounds = true
        
        updatePhoto()
        updateCover()
    }
    
    @objc func save() {
        
        self.saveSettings(accountId: iApp.sharedInstance.getId(), accessToken: iApp.sharedInstance.getAccessToken(), fullname: self.fullname, location: self.location, facebookPage: self.facebookPage, instagramPage: self.instagramPage, sex: self.sex, age: self.age, sex_orientation: self.sex_orientation, height: self.height, weight: self.weight)
    }
    
    func modify(modified: Bool) {
        
        self.modified = modified
        
        if (self.modified) {
            
            self.navigationItem.rightBarButtonItem?.isEnabled = true;
            
        } else {
            
            self.navigationItem.rightBarButtonItem?.isEnabled = false;
        }
    }
    
    func updatePhoto() {
        
        if (iApp.sharedInstance.getPhotoUrl().count != 0 && Helper.isInternetAvailable()) {
            
            if (iApp.sharedInstance.getCache().object(forKey: iApp.sharedInstance.getPhotoUrl() as AnyObject) != nil) {
                
                self.photoView.image = iApp.sharedInstance.getCache().object(forKey: iApp.sharedInstance.getPhotoUrl() as AnyObject) as? UIImage
                
            } else {
                
                let imageUrl:URL = URL(string: iApp.sharedInstance.getPhotoUrl())!
                
                uploadPhotoRequestStart()
                
                DispatchQueue.global().async {
                    
                    let data = try? Data(contentsOf: imageUrl)
                    
                    DispatchQueue.main.async {
                        
                        if data != nil {
                            
                            let img = UIImage(data: data!)
                            
                            self.photoView.image = img
                        }
                        
                        self.uploadPhotoRequestEnd()
                    }
                }
            }
        }
    }
    
    func updateCover() {
        
        if (iApp.sharedInstance.getCoverUrl().count != 0 && Helper.isInternetAvailable()) {
            
            if (iApp.sharedInstance.getCache().object(forKey: iApp.sharedInstance.getCoverUrl() as AnyObject) != nil) {
                
                self.coverView.image = iApp.sharedInstance.getCache().object(forKey: iApp.sharedInstance.getCoverUrl() as AnyObject) as? UIImage
                
            } else {
                
                let imageUrl:URL = URL(string: iApp.sharedInstance.getCoverUrl())!
                
                uploadPhotoRequestStart()
                
                DispatchQueue.global().async {
                    
                    let data = try? Data(contentsOf: imageUrl)
                    
                    DispatchQueue.main.async {
                        
                        if data != nil {
                            
                            let img = UIImage(data: data!)
                            
                            self.coverView.image = img
                        }
                        
                        self.uploadPhotoRequestEnd()
                    }
                }
            }
        }
    }
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: NSLocalizedString("label_profile_photo", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
            
            
        }
        
        alertController.addAction(cancelAction)
        
        let librarylAction = UIAlertAction(title: NSLocalizedString("action_photo_from_library", comment: ""), style: .default) { action in
            
            self.imgMode = 0;
            
            self.photoFromLibrary()
        }
        
        alertController.addAction(librarylAction)
        
        let cameraAction = UIAlertAction(title: NSLocalizedString("action_photo_from_camera", comment: ""), style: .default) { action in
            
            self.imgMode = 0;
            
            self.photoFromCamera()
        }
        
        alertController.addAction(cameraAction)
        
        let coverLibrarylAction = UIAlertAction(title: NSLocalizedString("action_cover_from_library", comment: ""), style: .default) { action in
            
            self.imgMode = 1;
            
            self.photoFromLibrary()
        }
        
        alertController.addAction(coverLibrarylAction)
        
        let coverCameraAction = UIAlertAction(title: NSLocalizedString("action_cover_from_camera", comment: ""), style: .default) { action in
            
            self.imgMode = 1;
            
            self.photoFromCamera()
        }
        
        alertController.addAction(coverCameraAction)
        
        if let popoverController = alertController.popoverPresentationController {
            
            popoverController.sourceView = sender as? UIView
            popoverController.sourceRect = (sender as AnyObject).bounds
        }
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        
        var chosenImage = UIImage()
        
        chosenImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        
        if (self.imgMode == 0) {
            
            photoView.image = chosenImage
            
        } else {
            
            coverView.image = chosenImage
        }
        
        self.uploadImage()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func photoFromLibrary() {
        
        let myPickerController = UIImagePickerController()
        
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    func photoFromCamera() {
        
        let myPickerController = UIImagePickerController()
        
        myPickerController.delegate = self;
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            myPickerController.allowsEditing = false
            myPickerController.sourceType = UIImagePickerController.SourceType.camera
            myPickerController.cameraCaptureMode = .photo
            myPickerController.modalPresentationStyle = .fullScreen
            
            present(myPickerController, animated: true, completion: nil)
            
        } else {
            
            let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
            
            alertVC.addAction(okAction)
            
            present(alertVC, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField.tag {
            
            case 0:
                
                self.fullname = textField.text!
            
                break
            
            case 1:
                
                self.location = textField.text!
            
                break
            
            case 2:
                
                self.facebookPage = textField.text!
            
                break
            
            case 3:
                
                self.instagramPage = textField.text!
            
                break
            
            case 4:
                
                if (textField.text?.count == 0) {
                    
                    self.age = 0;
                    
                } else {
                    
                    self.age = Int(textField.text!)!
                }
                
                break
            
            case 5:
                
                if (textField.text?.count == 0) {
                    
                    self.height = 0;
                    
                } else {
                    
                    self.height = Int(textField.text!)!
                }
                
                break
            
            case 6:
                
                if (textField.text?.count == 0) {
                    
                    self.weight = 0;
                    
                } else {
                    
                    self.weight = Int(textField.text!)!
                }
                
                break
            
            default:
            
                break
        }
        
        modify(modified: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 18
    }
    
    override func tableView(_ tableView : UITableView,  titleForHeaderInSection section: Int) -> String? {
        
        return NSLocalizedString("label_profile_info", comment: "")
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row > 6) {
            
            var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "CustomCell")!
            
            if (cell == nil) {
                
                cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "CustomCell")
            }
        
            
            cell?.selectionStyle = .default
            
            switch indexPath.row {
                
            case 7:
                
                cell?.textLabel?.text  = NSLocalizedString("label_gender", comment: "")
                cell?.detailTextLabel?.text = Dating.getGender(sex: self.sex)
                cell?.imageView?.image = UIImage(named: "ic_gender_30")
                
                break
                
            case 8:
                
                var sex_orientation_img = "ic_feature_30"
                
                switch (self.sex_orientation) {
                    
                    case 1:
                        
                        sex_orientation_img = "ic_heterosexual_30"
                        
                        break;
                    
                    case 2:
                        
                        sex_orientation_img = "ic_gay_30"
                        
                        break;
                    
                    case 3:
                        
                        sex_orientation_img = "ic_lesbian_30"
                        
                        break;
                    
                    default:
                        
                        sex_orientation_img = "ic_feature_30"
                        
                        break;
                }
                
                cell?.textLabel?.text  = NSLocalizedString("label_sex_orientation", comment: "")
                cell?.detailTextLabel?.text = Dating.getSexOrientation(sex_orientation: self.sex_orientation);
                cell?.imageView?.image = UIImage(named: sex_orientation_img)
                
                break
                
            case 9:
                
                cell?.textLabel?.text  = NSLocalizedString("label_relationship_status", comment: "")
                cell?.detailTextLabel?.text = Dating.getRelationshipStatus(relationshipStatus: self.relationshipStatus)
                cell?.imageView?.image = UIImage(named: "ic_feature_30")
                
                break
                
            case 10:
                
                cell?.textLabel?.text  = NSLocalizedString("label_political_views", comment: "")
                cell?.detailTextLabel?.text = Dating.getPoliticalViews(politicalViews: self.politicalViews)
                cell?.imageView?.image = UIImage(named: "ic_feature_30")
                
                break
                
            case 11:
                
                cell?.textLabel?.text  = NSLocalizedString("label_world_views", comment: "")
                cell?.detailTextLabel?.text = Dating.getWorldViewsViews(worldViews: self.worldViews)
                cell?.imageView?.image = UIImage(named: "ic_feature_30")
                
                break
                
            case 12:
                
                cell?.textLabel?.text  = NSLocalizedString("label_personal_priority", comment: "")
                cell?.detailTextLabel?.text = Dating.getPersonalPriority(personalPriority: self.personalPriority)
                cell?.imageView?.image = UIImage(named: "ic_feature_30")
                
                break
                
            case 13:
                
                cell?.textLabel?.text  = NSLocalizedString("label_important_in_others", comment: "")
                cell?.detailTextLabel?.text = Dating.getImportantInOthers(importantInOthers: self.importantInOthers)
                cell?.imageView?.image = UIImage(named: "ic_feature_30")
                
                break
                
            case 14:
                
                cell?.textLabel?.text  = NSLocalizedString("label_smoking_views", comment: "")
                cell?.detailTextLabel?.text = Dating.getSmokingViews(smokingViews: self.smokingViews)
                cell?.imageView?.image = UIImage(named: "ic_smoking_30")
                
                break
                
            case 15:
                
                cell?.textLabel?.text  = NSLocalizedString("label_alcohol_views", comment: "")
                cell?.detailTextLabel?.text = Dating.getAlcoholViews(alcoholViews: self.alcoholViews)
                cell?.imageView?.image = UIImage(named: "ic_alcohol_30")
                
                break
                
            case 16:
                
                cell?.textLabel?.text  = NSLocalizedString("label_looking_for", comment: "")
                cell?.detailTextLabel?.text = Dating.getLookingFor(lookingFor: self.lookingFor)
                cell?.imageView?.image = UIImage(named: "ic_feature_30")
                
                break
                
            case 17:
                
                cell?.textLabel?.text  = NSLocalizedString("label_gender_like", comment: "")
                cell?.detailTextLabel?.text = Dating.getGenderLike(genderLike: self.genderLike)
                cell?.imageView?.image = UIImage(named: "ic_like_30")
                
                break
                
            default:
                
                break
            }
            
            return cell!
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditableCell", for: indexPath) as! EdiatableSettingsCell
            
            cell.selectionStyle = .none
            
            switch indexPath.row {
                
            case 0:
                
                cell.textField.tag = 0
                cell.textField.text = self.fullname
                cell.textField.placeholder = NSLocalizedString("label_fullname", comment: "")
                
                cell.iconView.image = UIImage(named: "ic_profile_30")
                
                break
                
            case 1:
                
                cell.textField.tag = 1
                cell.textField.text = self.location
                cell.textField.placeholder = NSLocalizedString("label_location", comment: "")
                
                cell.iconView.image = UIImage(named: "ic_nearby_30")
                
                break
                
            case 2:
                
                cell.textField.tag = 2
                cell.textField.text = self.facebookPage
                cell.textField.placeholder = NSLocalizedString("label_facebook", comment: "")
                
                cell.iconView.image = UIImage(named: "ic_web_30")
                
                break
                
            case 3:
                
                cell.textField.tag = 3
                cell.textField.text = self.instagramPage
                cell.textField.placeholder = NSLocalizedString("label_instagram", comment: "")
                
                cell.iconView.image = UIImage(named: "ic_web_30")
                
                break
                
            case 4:
                
                cell.textField.tag = 4
                cell.textField.text = String(self.age)
                cell.textField.keyboardType = .numberPad
                cell.textField.placeholder = NSLocalizedString("label_age", comment: "")
                
                cell.iconView.image = UIImage(named: "ic_age_30")
                
                break
                
            case 5:
                
                var h_ = "";
                
                if (self.height == 0) {
                    
                    h_ = "";
                    
                } else {
                    
                    h_ = String(self.height)
                }
                
                cell.textField.tag = 5
                cell.textField.text = h_
                cell.textField.keyboardType = .numberPad
                cell.textField.placeholder = NSLocalizedString("label_height", comment: "") + " (" + NSLocalizedString("label_cm", comment: "") + ")"
                
                cell.iconView.image = UIImage(named: "ic_height_30")
                
                break
                
            case 6:
                
                var w_ = "";
                
                if (self.weight == 0) {
                    
                    w_ = "";
                    
                } else {
                    
                    w_ = String(self.weight)
                }
                
                cell.textField.tag = 6
                cell.textField.text = w_
                cell.textField.keyboardType = .numberPad
                cell.textField.placeholder = NSLocalizedString("label_weight", comment: "") + " (" + NSLocalizedString("label_kg", comment: "") + ")"
                
                cell.iconView.image = UIImage(named: "ic_weight_30")
                
                break
                
            default:
                
                break
            }
            
            cell.textField.delegate = self
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.row == 7) {
            
            let alertController = UIAlertController(title: nil, message: NSLocalizedString("label_gender", comment: ""), preferredStyle: .actionSheet)
            
            let maleAction = UIAlertAction(title: NSLocalizedString("label_male", comment: ""), style: .default) { action in
                
                self.sex = Constants.SEX_MALE
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(maleAction)
            
            let femaleAction = UIAlertAction(title: NSLocalizedString("label_female", comment: ""), style: .default) { action in
                
                self.sex = Constants.SEX_FEMALE
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(femaleAction)
            
            if let popoverController = alertController.popoverPresentationController {
                
                popoverController.sourceView = tableView.cellForRow(at: indexPath)
                popoverController.sourceRect = (tableView.cellForRow(at: indexPath)?.bounds)!
                popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
            }
            
            self.present(alertController, animated: true, completion: nil)
            
        } else if (indexPath.row == 8) {
            
            let alertController = UIAlertController(title: nil, message: NSLocalizedString("label_sex_orientation_select", comment: ""), preferredStyle: .actionSheet)
            
            let sex_orientation_1 = UIAlertAction(title: NSLocalizedString("label_sex_orientation_1", comment: ""), style: .default) { action in
                
                self.sex_orientation = 1
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(sex_orientation_1)
            
            let sex_orientation_2 = UIAlertAction(title: NSLocalizedString("label_sex_orientation_2", comment: ""), style: .default) { action in
                
                self.sex_orientation = 2
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(sex_orientation_2)
            
            let sex_orientation_3 = UIAlertAction(title: NSLocalizedString("label_sex_orientation_3", comment: ""), style: .default) { action in
                
                self.sex_orientation = 3
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(sex_orientation_3)
            
            let sex_orientation_4 = UIAlertAction(title: NSLocalizedString("label_sex_orientation_4", comment: ""), style: .default) { action in
                
                self.sex_orientation = 4
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(sex_orientation_4)
            
            if let popoverController = alertController.popoverPresentationController {
                
                popoverController.sourceView = tableView.cellForRow(at: indexPath)
                popoverController.sourceRect = (tableView.cellForRow(at: indexPath)?.bounds)!
                popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
            }
            
            self.present(alertController, animated: true, completion: nil)
            
        } else if (indexPath.row == 9) {
            
            let alertController = UIAlertController(title: nil, message: NSLocalizedString("label_relationship_status", comment: ""), preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
                
            }
            
            alertController.addAction(cancelAction)
            
            let action_0 = UIAlertAction(title: NSLocalizedString("relationship_status_0", comment: ""), style: .default) { action in
                
                self.relationshipStatus = 0
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_0)
            
            let action_1 = UIAlertAction(title: NSLocalizedString("relationship_status_1", comment: ""), style: .default) { action in
                
                self.relationshipStatus = 1
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_1)
            
            let action_2 = UIAlertAction(title: NSLocalizedString("relationship_status_2", comment: ""), style: .default) { action in
                
                self.relationshipStatus = 2
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_2)
            
            let action_3 = UIAlertAction(title: NSLocalizedString("relationship_status_3", comment: ""), style: .default) { action in
                
                self.relationshipStatus = 3
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_3)
            
            let action_4 = UIAlertAction(title: NSLocalizedString("relationship_status_4", comment: ""), style: .default) { action in
                
                self.relationshipStatus = 4
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_4)
            
            let action_5 = UIAlertAction(title: NSLocalizedString("relationship_status_5", comment: ""), style: .default) { action in
                
                self.relationshipStatus = 5
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_5)
            
            let action_6 = UIAlertAction(title: NSLocalizedString("relationship_status_6", comment: ""), style: .default) { action in
                
                self.relationshipStatus = 6
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_6)
            
            let action_7 = UIAlertAction(title: NSLocalizedString("relationship_status_7", comment: ""), style: .default) { action in
                
                self.relationshipStatus = 7
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_7)
            
            if let popoverController = alertController.popoverPresentationController {
                
                popoverController.sourceView = tableView.cellForRow(at: indexPath)
                popoverController.sourceRect = (tableView.cellForRow(at: indexPath)?.bounds)!
                popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
            }
            
            self.present(alertController, animated: true, completion: nil)
            
        } else if (indexPath.row == 10) {
            
            let alertController = UIAlertController(title: nil, message: NSLocalizedString("label_political_views", comment: ""), preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
                
            }
            
            alertController.addAction(cancelAction)
            
            let action_0 = UIAlertAction(title: NSLocalizedString("political_views_0", comment: ""), style: .default) { action in
                
                self.politicalViews = 0
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_0)
            
            let action_1 = UIAlertAction(title: NSLocalizedString("political_views_1", comment: ""), style: .default) { action in
                
                self.politicalViews = 1
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_1)
            
            let action_2 = UIAlertAction(title: NSLocalizedString("political_views_2", comment: ""), style: .default) { action in
                
                self.politicalViews = 2
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_2)
            
            let action_3 = UIAlertAction(title: NSLocalizedString("political_views_3", comment: ""), style: .default) { action in
                
                self.politicalViews = 3
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_3)
            
            let action_4 = UIAlertAction(title: NSLocalizedString("political_views_4", comment: ""), style: .default) { action in
                
                self.politicalViews = 4
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_4)
            
            let action_5 = UIAlertAction(title: NSLocalizedString("political_views_5", comment: ""), style: .default) { action in
                
                self.politicalViews = 5
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_5)
            
            let action_6 = UIAlertAction(title: NSLocalizedString("political_views_6", comment: ""), style: .default) { action in
                
                self.politicalViews = 6
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_6)
            
            let action_7 = UIAlertAction(title: NSLocalizedString("political_views_7", comment: ""), style: .default) { action in
                
                self.politicalViews = 7
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_7)
            
            let action_8 = UIAlertAction(title: NSLocalizedString("political_views_8", comment: ""), style: .default) { action in
                
                self.politicalViews = 8
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_8)
            
            let action_9 = UIAlertAction(title: NSLocalizedString("political_views_9", comment: ""), style: .default) { action in
                
                self.politicalViews = 9
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_9)
            
            if let popoverController = alertController.popoverPresentationController {
                
                popoverController.sourceView = tableView.cellForRow(at: indexPath)
                popoverController.sourceRect = (tableView.cellForRow(at: indexPath)?.bounds)!
                popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
            }
            
            self.present(alertController, animated: true, completion: nil)
            
        } else if (indexPath.row == 11) {
            
            
            let alertController = UIAlertController(title: nil, message: NSLocalizedString("label_world_views", comment: ""), preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
                
            }
            
            alertController.addAction(cancelAction)
            
            let action_0 = UIAlertAction(title: NSLocalizedString("world_view_0", comment: ""), style: .default) { action in
                
                self.worldViews = 0
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_0)
            
            let action_1 = UIAlertAction(title: NSLocalizedString("world_view_1", comment: ""), style: .default) { action in
                
                self.worldViews = 1
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_1)
            
            let action_2 = UIAlertAction(title: NSLocalizedString("world_view_2", comment: ""), style: .default) { action in
                
                self.worldViews = 2
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_2)
            
            let action_3 = UIAlertAction(title: NSLocalizedString("world_view_3", comment: ""), style: .default) { action in
                
                self.worldViews = 3
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_3)
            
            let action_4 = UIAlertAction(title: NSLocalizedString("world_view_4", comment: ""), style: .default) { action in
                
                self.worldViews = 4
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_4)
            
            let action_5 = UIAlertAction(title: NSLocalizedString("world_view_5", comment: ""), style: .default) { action in
                
                self.worldViews = 5
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_5)
            
            let action_6 = UIAlertAction(title: NSLocalizedString("world_view_6", comment: ""), style: .default) { action in
                
                self.worldViews = 6
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_6)
            
            let action_7 = UIAlertAction(title: NSLocalizedString("world_view_7", comment: ""), style: .default) { action in
                
                self.worldViews = 7
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_7)
            
            let action_8 = UIAlertAction(title: NSLocalizedString("world_view_8", comment: ""), style: .default) { action in
                
                self.worldViews = 8
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_8)
            
            let action_9 = UIAlertAction(title: NSLocalizedString("world_view_9", comment: ""), style: .default) { action in
                
                self.worldViews = 9
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_9)
            
            if let popoverController = alertController.popoverPresentationController {
                
                popoverController.sourceView = tableView.cellForRow(at: indexPath)
                popoverController.sourceRect = (tableView.cellForRow(at: indexPath)?.bounds)!
                popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
            }
            
            self.present(alertController, animated: true, completion: nil)
            
        } else if (indexPath.row == 12) {
            
            let alertController = UIAlertController(title: nil, message: NSLocalizedString("label_personal_priority", comment: ""), preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
                
            }
            
            alertController.addAction(cancelAction)
            
            let action_0 = UIAlertAction(title: NSLocalizedString("personal_priority_0", comment: ""), style: .default) { action in
                
                self.personalPriority = 0
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_0)
            
            let action_1 = UIAlertAction(title: NSLocalizedString("personal_priority_1", comment: ""), style: .default) { action in
                
                self.personalPriority = 1
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_1)
            
            let action_2 = UIAlertAction(title: NSLocalizedString("personal_priority_2", comment: ""), style: .default) { action in
                
                self.personalPriority = 2
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_2)
            
            let action_3 = UIAlertAction(title: NSLocalizedString("personal_priority_3", comment: ""), style: .default) { action in
                
                self.personalPriority = 3
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_3)
            
            let action_4 = UIAlertAction(title: NSLocalizedString("personal_priority_4", comment: ""), style: .default) { action in
                
                self.personalPriority = 4
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_4)
            
            let action_5 = UIAlertAction(title: NSLocalizedString("personal_priority_5", comment: ""), style: .default) { action in
                
                self.personalPriority = 5
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_5)
            
            let action_6 = UIAlertAction(title: NSLocalizedString("personal_priority_6", comment: ""), style: .default) { action in
                
                self.personalPriority = 6
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_6)
            
            let action_7 = UIAlertAction(title: NSLocalizedString("personal_priority_7", comment: ""), style: .default) { action in
                
                self.personalPriority = 7
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_7)
            
            let action_8 = UIAlertAction(title: NSLocalizedString("personal_priority_8", comment: ""), style: .default) { action in
                
                self.personalPriority = 8
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_8)
            
            if let popoverController = alertController.popoverPresentationController {
                
                popoverController.sourceView = tableView.cellForRow(at: indexPath)
                popoverController.sourceRect = (tableView.cellForRow(at: indexPath)?.bounds)!
                popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
            }
            
            self.present(alertController, animated: true, completion: nil)
            
        } else if (indexPath.row == 13) {
            
            let alertController = UIAlertController(title: nil, message: NSLocalizedString("label_important_in_others", comment: ""), preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
                
            }
            
            alertController.addAction(cancelAction)
            
            let action_0 = UIAlertAction(title: NSLocalizedString("important_in_others_0", comment: ""), style: .default) { action in
                
                self.importantInOthers = 0
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_0)
            
            let action_1 = UIAlertAction(title: NSLocalizedString("important_in_others_1", comment: ""), style: .default) { action in
                
                self.importantInOthers = 1
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_1)
            
            let action_2 = UIAlertAction(title: NSLocalizedString("important_in_others_2", comment: ""), style: .default) { action in
                
                self.importantInOthers = 2
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_2)
            
            let action_3 = UIAlertAction(title: NSLocalizedString("important_in_others_3", comment: ""), style: .default) { action in
                
                self.importantInOthers = 3
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_3)
            
            let action_4 = UIAlertAction(title: NSLocalizedString("important_in_others_4", comment: ""), style: .default) { action in
                
                self.importantInOthers = 4
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_4)
            
            let action_5 = UIAlertAction(title: NSLocalizedString("important_in_others_5", comment: ""), style: .default) { action in
                
                self.importantInOthers = 5
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_5)
            
            let action_6 = UIAlertAction(title: NSLocalizedString("important_in_others_6", comment: ""), style: .default) { action in
                
                self.importantInOthers = 6
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_6)
            
            if let popoverController = alertController.popoverPresentationController {
                
                popoverController.sourceView = tableView.cellForRow(at: indexPath)
                popoverController.sourceRect = (tableView.cellForRow(at: indexPath)?.bounds)!
                popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
            }
            
            self.present(alertController, animated: true, completion: nil)
            
        } else if (indexPath.row == 14) {
            
            let alertController = UIAlertController(title: nil, message: NSLocalizedString("label_smoking_views", comment: ""), preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
                
            }
            
            alertController.addAction(cancelAction)
            
            let action_0 = UIAlertAction(title: NSLocalizedString("smoking_views_0", comment: ""), style: .default) { action in
                
                self.smokingViews = 0
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_0)
            
            let action_1 = UIAlertAction(title: NSLocalizedString("smoking_views_1", comment: ""), style: .default) { action in
                
                self.smokingViews = 1
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_1)
            
            let action_2 = UIAlertAction(title: NSLocalizedString("smoking_views_2", comment: ""), style: .default) { action in
                
                self.smokingViews = 2
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_2)
            
            let action_3 = UIAlertAction(title: NSLocalizedString("smoking_views_3", comment: ""), style: .default) { action in
                
                self.smokingViews = 3
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_3)
            
            let action_4 = UIAlertAction(title: NSLocalizedString("smoking_views_4", comment: ""), style: .default) { action in
                
                self.smokingViews = 4
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_4)
            
            let action_5 = UIAlertAction(title: NSLocalizedString("smoking_views_5", comment: ""), style: .default) { action in
                
                self.smokingViews = 5
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_5)
            
            if let popoverController = alertController.popoverPresentationController {
                
                popoverController.sourceView = tableView.cellForRow(at: indexPath)
                popoverController.sourceRect = (tableView.cellForRow(at: indexPath)?.bounds)!
                popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
            }
            
            self.present(alertController, animated: true, completion: nil)
            
        } else if (indexPath.row == 15) {
            
            let alertController = UIAlertController(title: nil, message: NSLocalizedString("label_alcohol_views", comment: ""), preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
                
            }
            
            alertController.addAction(cancelAction)
            
            let action_0 = UIAlertAction(title: NSLocalizedString("alcohol_views_0", comment: ""), style: .default) { action in
                
                self.alcoholViews = 0
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_0)
            
            let action_1 = UIAlertAction(title: NSLocalizedString("alcohol_views_1", comment: ""), style: .default) { action in
                
                self.alcoholViews = 1
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_1)
            
            let action_2 = UIAlertAction(title: NSLocalizedString("alcohol_views_2", comment: ""), style: .default) { action in
                
                self.alcoholViews = 2
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_2)
            
            let action_3 = UIAlertAction(title: NSLocalizedString("alcohol_views_3", comment: ""), style: .default) { action in
                
                self.alcoholViews = 3
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_3)
            
            let action_4 = UIAlertAction(title: NSLocalizedString("alcohol_views_4", comment: ""), style: .default) { action in
                
                self.alcoholViews = 4
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_4)
            
            let action_5 = UIAlertAction(title: NSLocalizedString("alcohol_views_5", comment: ""), style: .default) { action in
                
                self.alcoholViews = 5
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_5)
            
            if let popoverController = alertController.popoverPresentationController {
                
                popoverController.sourceView = tableView.cellForRow(at: indexPath)
                popoverController.sourceRect = (tableView.cellForRow(at: indexPath)?.bounds)!
                popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
            }
            
            self.present(alertController, animated: true, completion: nil)
            
        } else if (indexPath.row == 16) {
            
            let alertController = UIAlertController(title: nil, message: NSLocalizedString("label_looking_for", comment: ""), preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
                
            }
            
            alertController.addAction(cancelAction)
            
            let action_0 = UIAlertAction(title: NSLocalizedString("you_looking_0", comment: ""), style: .default) { action in
                
                self.lookingFor = 0
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_0)
            
            let action_1 = UIAlertAction(title: NSLocalizedString("you_looking_1", comment: ""), style: .default) { action in
                
                self.lookingFor = 1
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_1)
            
            let action_2 = UIAlertAction(title: NSLocalizedString("you_looking_2", comment: ""), style: .default) { action in
                
                self.lookingFor = 2
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_2)
            
            let action_3 = UIAlertAction(title: NSLocalizedString("you_looking_3", comment: ""), style: .default) { action in
                
                self.lookingFor = 3
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_3)
            
            
            if let popoverController = alertController.popoverPresentationController {
                
                popoverController.sourceView = tableView.cellForRow(at: indexPath)
                popoverController.sourceRect = (tableView.cellForRow(at: indexPath)?.bounds)!
                popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
            }
            
            self.present(alertController, animated: true, completion: nil)
            
        } else if (indexPath.row == 17) {
            
            let alertController = UIAlertController(title: nil, message: NSLocalizedString("label_gender_like", comment: ""), preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
                
            }
            
            alertController.addAction(cancelAction)
            
            let action_0 = UIAlertAction(title: NSLocalizedString("you_looking_0", comment: ""), style: .default) { action in
                
                self.genderLike = 0
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_0)
            
            let action_1 = UIAlertAction(title: NSLocalizedString("gender_like_1", comment: ""), style: .default) { action in
                
                self.genderLike = 1
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_1)
            
            let action_2 = UIAlertAction(title: NSLocalizedString("gender_like_2", comment: ""), style: .default) { action in
                
                self.genderLike = 2
                
                self.tableView.reloadData()
                
                self.modify(modified: true)
            }
            
            alertController.addAction(action_2)
            
            if let popoverController = alertController.popoverPresentationController {
                
                popoverController.sourceView = tableView.cellForRow(at: indexPath)
                popoverController.sourceRect = (tableView.cellForRow(at: indexPath)?.bounds)!
                popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
            }
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    func uploadImage() {
        
        var imgType = Constants.UPLOAD_TYPE_PHOTO
        
        var imageData = Helper.rotateImage(image: photoView.image!).jpeg(.low)
        
        if (imgMode == 1) {
            
            imgType = Constants.UPLOAD_TYPE_COVER
            
            imageData = Helper.rotateImage(image: coverView.image!).jpeg(.low)
        }
        
        if (imageData == nil) {
            
            return;
        }
        
        let request = NSMutableURLRequest(url:NSURL(string: Constants.METHOD_ACCOUNT_UPLOAD_IMAGE)! as URL);
        request.httpMethod = "POST";
        
        let param = ["accountId" : String(iApp.sharedInstance.getId()), "accessToken" : iApp.sharedInstance.getAccessToken(), "imgType" : String(imgType)]
        
        let boundary = Helper.generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = Helper.createBodyWithParameters(parameters: param, filePathKey: "uploaded_file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        
        uploadPhotoRequestStart()
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            
            data, response, error in
            
            if error != nil {
                
                DispatchQueue.main.async() {
                    
                    self.uploadPhotoRequestEnd();
                }
                
                return
            }
            
            do {
                
                let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                let responseError = response["error"] as! Bool;
                
                print(response)
                
                if (responseError == false) {
                    
                    if (self.imgMode == 0) {
                        
                        if (Constants.SERVER_ENGINE_VERSION > 1) {
                        
                            iApp.sharedInstance.setPhotoUrl(photoUrl: response["photoUrl"] as! String)
                            
                        } else {
                            
                            iApp.sharedInstance.setPhotoUrl(photoUrl: response["lowPhotoUrl"] as! String)
                        }
                        
                    } else {
                        
                        if (Constants.SERVER_ENGINE_VERSION > 1) {
                            
                            iApp.sharedInstance.setCoverUrl(coverUrl: response["coverUrl"] as! String)
                            
                        } else {
                            
                            iApp.sharedInstance.setCoverUrl(coverUrl: response["normalCoverUrl"] as! String)
                        }
                    }
                }
                
                DispatchQueue.main.async() {
                    
                    self.uploadPhotoRequestEnd();
                }
                
            } catch {
                
                print(error)
                
                DispatchQueue.main.async() {
                    
                    self.uploadPhotoRequestEnd();
                }
            }
            
        }
        
        task.resume()
    }
    
    func serverRequestStart() {
        
        LoadingIndicatorView.show(NSLocalizedString("label_loading", comment: ""));
    }
    
    func serverRequestEnd() {
        
        LoadingIndicatorView.hide();
    }
    
    func uploadPhotoRequestStart() {
        
        self.actionButton.isEnabled = false;
        self.uploadIndicator.startAnimating();
        self.uploadIndicator.isHidden = false;
        
        self.photoView.isHidden = true;
        self.coverView.isHidden = true;
    }
    
    func uploadPhotoRequestEnd() {
        
        self.actionButton.isEnabled = true;
        self.uploadIndicator.stopAnimating();
        self.uploadIndicator.isHidden = true;
        
        self.photoView.isHidden = false;
        self.coverView.isHidden = false;
    }
    
    func saveSettings(accountId: Int, accessToken: String, fullname: String, location: String, facebookPage: String, instagramPage: String, sex: Int, age: Int, sex_orientation: Int, height: Int, weight: Int) {
        
        self.serverRequestStart()
        
        var request = URLRequest(url: URL(string: Constants.METHOD_ACCOUNT_SAVE_SETTINGS)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=\(accountId)" + "&accessToken=\(accessToken)&fullname=\(fullname)&location=\(location)&facebookPage=\(facebookPage)&instagramPage=\(instagramPage)&sex=\(String(sex))&iStatus=\(String(self.relationshipStatus))&politicalViews=\(String(self.politicalViews))&worldViews=\(String(self.worldViews))&personalPriority=\(String(self.personalPriority))&importantInOthers=\(String(self.importantInOthers))&smokingViews=\(String(self.smokingViews))&alcoholViews=\(String(self.alcoholViews))&lookingViews=\(String(self.lookingFor))&interestedViews=\(String(self.genderLike))&bio=\(self.bio)&year=\(String(self.year))&month=\(String(self.month))&day=\(String(self.day))&age=\(String(self.age))&sex_orientation=\(String(self.sex_orientation))&height=\(String(self.height))&weight=\(String(self.weight))";
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async() {
                    
                    self.serverRequestEnd()
                    self.modify(modified: true)
                }
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        iApp.sharedInstance.authorize(Response: response as AnyObject)
                        
                        DispatchQueue.global(qos: .background).async {
                            
                            DispatchQueue.main.async {
                                
                                self.modify(modified: false)
                            }
                        }
                    }
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd()
                    }
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd()
                        self.modify(modified: true)
                    }
                }
            }
            
        }).resume()
    }
}

extension NSMutableData {
    
    func appendString(string: String) {
        
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }

}

extension UIImage {
    
    enum JPEGQuality: CGFloat {
        
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    var png: Data? { return self.pngData() }
    
    func jpeg(_ quality: JPEGQuality) -> Data? {
        
        return self.jpegData(compressionQuality: quality.rawValue)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}

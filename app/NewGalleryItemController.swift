//
//  NewGalleryItemController.swift
//
//  Created by Demyanchuk Dmitry on 31.07.20.
//  Copyright © 2020 raccoonsquare@gmail.com All rights reserved.
//

import UIKit
import AVFoundation

class NewGalleryItemController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var choiceImage: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!

    @IBOutlet weak var frameHeight: NSLayoutConstraint!
    @IBOutlet weak var frameBottom: NSLayoutConstraint!
    
    var placeholderLabel : UILabel!
    
    
    var imageSelected = false;
    
    var videoPath: URL?
    
    var originalPhotoUrl: String = ""
    var normalPhotoUrl: String = ""
    var previewPhotoUrl: String = ""
    
    var videoUrl: String = ""
    
    var message: String = ""
    
    var itemType: Int = 0;
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        textView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = NSLocalizedString("placeholder_gallery_item_comment", comment: "")
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (textView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !textView.text.isEmpty

        modify()
        
        // listener to choice image
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTap(gesture:)) )
        
        // add it to the image view;
        self.choiceImage.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        self.choiceImage.isUserInteractionEnabled = true
        self.choiceImage.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            self.frameBottom.constant = keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        self.frameBottom.constant = 0
    }
    
    @IBAction func cancelTap(_ sender: Any) {
        
        self.dismiss(animated: true, completion: {})
    }
    
    @IBAction func saveTap(_ sender: Any) {
        
        self.message = self.textView.text
        
        if (self.itemType == Constants.ITEM_TYPE_IMAGE) {
            
            uploadImage()
            
        } else {
            
            uploadVideo()
        }
    }
    
    func modify() {
        
        if (self.imageSelected) {
            
            self.saveButton.isEnabled = true
            self.infoLabel.isHidden = true
            
        } else {
            
            self.saveButton.isEnabled = false
            self.infoLabel.isHidden = false
            
            self.choiceImage.image = UIImage(named: "ic_camera_30")
        }
    }
    
    @objc func imageTap(gesture: UIGestureRecognizer) {
        
        if let imageView = gesture.view as? UIImageView {
            
            if (imageSelected) {
                
                let alertController = UIAlertController(title: NSLocalizedString("label_choice_image", comment: ""), message: nil, preferredStyle: .actionSheet)
                
                let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
                    
                }
                
                alertController.addAction(cancelAction)
                
                let deletelAction = UIAlertAction(title: NSLocalizedString("action_delete", comment: ""), style: .default) { action in
                    
                    self.deleteImage()
                }
                
                alertController.addAction(deletelAction)
                
                if let popoverController = alertController.popoverPresentationController {
                    
                    popoverController.sourceView = imageView
                    popoverController.sourceRect = imageView.bounds
                }
                
                self.present(alertController, animated: true, completion: nil)
                
            } else {
                
                let alertController = UIAlertController(title: NSLocalizedString("label_choice_image", comment: ""), message: nil, preferredStyle: .actionSheet)
                
                let cancelAction = UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: .cancel) { action in
                    
                    
                }
                
                alertController.addAction(cancelAction)
                
                let librarylAction = UIAlertAction(title: NSLocalizedString("action_photo_from_library", comment: ""), style: .default) { action in
                    
                    self.photoFromLibrary()
                }
                
                alertController.addAction(librarylAction)
                
                
                let cameraAction = UIAlertAction(title: NSLocalizedString("action_photo_from_camera", comment: ""), style: .default) { action in
                    
                    self.photoFromCamera()
                }
                
                alertController.addAction(cameraAction)
                
                let videoFromLibrarylAction = UIAlertAction(title: NSLocalizedString("action_video_from_library", comment: ""), style: .default) { action in
                    
                    self.videoFromLibrary()
                }
                
                alertController.addAction(videoFromLibrarylAction)
                
                if let popoverController = alertController.popoverPresentationController {
                    
                    popoverController.sourceView = imageView
                    popoverController.sourceRect = imageView.bounds
                }
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func deleteImage() {
        
        self.imageSelected = false
        
        modify()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if info[UIImagePickerController.InfoKey.mediaType.rawValue] as? String == "public.image" {
         
            var chosenImage = UIImage()

            chosenImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage

            self.choiceImage.image = chosenImage
            
            self.itemType = Constants.ITEM_TYPE_IMAGE
            
        } else {
            
            videoPath = info[UIImagePickerController.InfoKey.mediaURL.rawValue] as? URL
            
            self.choiceImage.image = imagePreview(moviePath: videoPath! as URL, seconds: 0.1)
            
            self.itemType = Constants.ITEM_TYPE_VIDEO
        }

        self.imageSelected = true
        
        self.modify()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePreview(moviePath: URL, seconds: Double) -> UIImage? {
        
        let timestamp = CMTime(seconds: seconds, preferredTimescale: 60)
        let asset = AVURLAsset(url: moviePath)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true

        guard let imageRef = try? generator.copyCGImage(at: timestamp, actualTime: nil) else {
            return nil
        }
        return UIImage(cgImage: imageRef)
    }
    
    func videoFromLibrary() {
        
        let myPickerController = UIImagePickerController()
        
        myPickerController.sourceType = .photoLibrary

        myPickerController.delegate = self

        myPickerController.mediaTypes = ["public.movie"]
        
        self.present(myPickerController, animated: true, completion: nil)
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
    
    
    func send() {
        
        var request = URLRequest(url: URL(string: Constants.METHOD_GALLERY_NEW)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&itemType=" + String(self.itemType) + "&comment=" + self.message + "&imgUrl=" + self.normalPhotoUrl + "&originImgUrl=" + self.originalPhotoUrl + "&previewImgUrl=" + self.previewPhotoUrl + "&videoUrl=" + self.videoUrl;
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async(execute: {
                    
                    self.serverRequestEnd();
                })
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        // print(response)
                        
                    }
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.serverRequestEnd();
                        
                        self.dismiss(animated: true, completion: {})
                    })
                    
                } catch let error2 as NSError {
                    
                    print(error2.localizedDescription)
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.serverRequestEnd();
                    })
                }
            }
            
        }).resume();
    }
    
    func uploadImage() {
        
        let myUrl = NSURL(string: Constants.METHOD_GALLERY_UPLOAD_IMG);
        
        let imageData = Helper.rotateImage(image: self.choiceImage.image!).jpeg(.low)
        
        if (imageData == nil) {
            
            return;
        }
        
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        
        let param = ["accountId" : String(iApp.sharedInstance.getId()), "accessToken" : iApp.sharedInstance.getAccessToken()]
        
        let boundary = Helper.generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = Helper.createBodyWithParameters(parameters: param, filePathKey: "uploaded_file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        
        serverRequestStart()
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            
            data, response, error in
            
            if error != nil {
                
                DispatchQueue.main.async() {
                    
                    self.serverRequestEnd();
                }
                
                return
            }
            
            do {
                
                let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                let responseError = response["error"] as! Bool;
                
                if (responseError == false) {
                    
                    self.originalPhotoUrl = response["originPhotoUrl"] as! String
                    self.normalPhotoUrl = response["normalPhotoUrl"] as! String
                    self.previewPhotoUrl = response["previewPhotoUrl"] as! String
                }
                
                DispatchQueue.main.async() {
                    
                    self.send()
                }
                
            } catch {
                
                print(error)
                
                DispatchQueue.main.async() {
                    
                    self.serverRequestEnd();
                }
            }
            
        }
        
        task.resume()
    }
    
        func uploadVideo() {
            
            let myUrl = NSURL(string: Constants.METHOD_GALLERY_UPLOAD_VIDEO);
            
            var movieData: Data?
            
            do {
                
                movieData = try Data(contentsOf: videoPath!, options: Data.ReadingOptions.alwaysMapped)
                
            } catch _ {
                
                movieData = nil
                
                return
            }
            
            let request = NSMutableURLRequest(url:myUrl! as URL);
            request.httpMethod = "POST";
            
            let param = ["accountId" : String(iApp.sharedInstance.getId()), "accessToken" : iApp.sharedInstance.getAccessToken()]
            
            let boundary = Helper.generateBoundaryString()
            
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = Helper.createBodyWithParametersForVideo(parameters: param, filePathKey: "uploaded_video_file", imageDataKey: movieData! as NSData, boundary: boundary) as Data
            
            
            serverRequestStart()
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                
                data, response, error in
                
                if error != nil {
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                    }
                    
                    return
                }
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        self.videoUrl = response["videoFileUrl"] as! String
                    }
                    
                    DispatchQueue.main.async() {
                        
                        self.send()
                    }
                    
                } catch {
                    
                    print(error)
                    
                    DispatchQueue.main.async() {
                        
                        self.serverRequestEnd();
                    }
                }
                
            }
            
            task.resume()
        }
    
    func serverRequestStart() {
        
        self.view.endEditing(true)
        
        LoadingIndicatorView.show(NSLocalizedString("label_loading", comment: ""));
    }
    
    func serverRequestEnd() {
        
        LoadingIndicatorView.hide();
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
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

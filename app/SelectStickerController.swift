//
//  SelectStickerController.swift
//
//  Created by Demyanchuk Dmitry on 03.02.17.
//  Copyright © 2020 raccoonsquare@gmail.com All rights reserved.
//

import UIKit

class SelectStickerController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var textMessageView: UILabel!
    
    var stickerId: Int = 0
    var stickerImg = ""
    
    var items = [Sticker]()
    
    var itemId: Int = 0;
    var itemsLoaded: Int = 0;
    
    var loading = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // add tableview delegate
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // prepare for loading data
        
        self.showLoadingScreen()
        
        // start loading data
        
        getData()
    }
    
    func getData() {
        
        loading = true;
        
        var request = URLRequest(url: URL(string: Constants.METHOD_STICKERS_GET)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&ios_fcm_regId=" + iApp.sharedInstance.getFcmRegId() + "&itemId=" + String(self.itemId);
        
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async(execute: {
                    
                    self.loadingComplete()
                })
                
                return
            }
            
            do {
                
                //Get Response
                let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                
                //Get Error status
                let responseError = response["error"] as! Bool;
                
                //If error False - read data
                if (responseError == false) {
                    
                    //Get itemId
                    self.itemId = (response["itemId"] as AnyObject).integerValue
                    
                    //Get items array
                    let itemsArray = response["items"] as! [AnyObject]
                    
                    //Items in array
                    self.itemsLoaded = itemsArray.count
                    
                    //Read items from array
                    for itemObj in itemsArray {
                        
                        //add item to adapter(array). insert to start | append to end
                        self.items.append(Sticker(Response: itemObj))
                    }
                }
                
                DispatchQueue.main.async(execute: {
                    
                    self.loadingComplete()
                })
                
            } catch {
                
                DispatchQueue.main.async(execute: {
                    
                    self.loadingComplete()
                })
            }
            
        }).resume();
    }
    
    func loadingComplete() {
        
        self.collectionView.reloadData()
        self.loading = false
        
        if (self.items.count == 0) {
            
            self.showEmptyScreen()
            
        } else {
            
            self.showContentScreen()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectStickerCell", for: indexPath) as! SelectStickerCell
        
        var item: Sticker;
        
        item = items[indexPath.row];
        
        if (item.getImgUrl().count == 0) {
            
            cell.pictureView.image = UIImage(named: "app_logo")
            
            cell.pictureView.isHidden = false
            
        } else {
            
            if (iApp.sharedInstance.getCache().object(forKey: item.getImgUrl() as AnyObject) != nil) {
                
                cell.pictureView.image = iApp.sharedInstance.getCache().object(forKey: item.getImgUrl() as AnyObject) as? UIImage
                
                cell.pictureView.isHidden = false
                
            } else {
                
                if (!item.imgLoading) {
                    
                    item.imgLoading = true;
                    
                    let imageUrlString = item.getImgUrl()
                    let imageUrl:URL = URL(string: imageUrlString)!
                    
                    DispatchQueue.global().async {
                        
                        let data = try? Data(contentsOf: imageUrl)
                        
                        DispatchQueue.main.async {
                            
                            if data != nil {
                                
                                let img = UIImage(data: data!)
                                
                                cell.pictureView.image = img
                                
                                iApp.sharedInstance.getCache().setObject(img!, forKey: item.getImgUrl() as AnyObject)
                                
                                self.collectionView.reloadData()
                                
                                //self.collectionView.reloadItems(at: [indexPath])
                            }
                        }
                    }
                    
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var item: Sticker;
        
        item = items[indexPath.row];
        
        self.stickerId = item.getId()
        self.stickerImg = item.getImgUrl()
        
        self.performSegue(withIdentifier: "unwindToChat", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if  (segue.identifier == "unwindToChat") {
            
            let destinationVC = segue.destination as! ChatViewController
            destinationVC.stickerId = self.stickerId
            destinationVC.stickerImg = self.stickerImg
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellsAcross: CGFloat = 3
        let spaceBetweenCells: CGFloat = 1
        let dim = (collectionView.bounds.width - (cellsAcross - 1) * spaceBetweenCells) / cellsAcross
        
        return CGSize(width: dim, height: dim)
    }
    
    func serverRequestStart() {
        
        LoadingIndicatorView.show(NSLocalizedString("label_loading", comment: ""));
    }
    
    func serverRequestEnd() {
        
        LoadingIndicatorView.hide();
    }
    
    func showLoadingScreen() {
        
        self.textMessageView.isHidden = true
        
        self.loadingView.isHidden = false
        self.loadingView.startAnimating()
        
        self.collectionView.isHidden = true
    }
    
    func showContentScreen() {
        
        self.textMessageView.isHidden = true
        
        self.loadingView.isHidden = true
        self.loadingView.stopAnimating()
        
        self.collectionView.isHidden = false
    }
    
    func showEmptyScreen() {
        
        self.textMessageView.text = NSLocalizedString("label_empty", comment: "");
        self.textMessageView.isHidden = false
        
        self.loadingView.isHidden = true
        self.loadingView.stopAnimating()
        
        self.collectionView.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}


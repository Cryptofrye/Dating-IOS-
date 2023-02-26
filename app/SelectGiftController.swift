//
//  SelectGiftController.swift
//
//  Created by Demyanchuk Dmitry on 03.02.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//

import UIKit

class SelectGiftController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textMessageView: UILabel!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    
    var profileId: Int = 0
    
    var refreshControl = UIRefreshControl()
    
    var items = [GiftBase]()
    
    var itemId: Int = 0;
    var itemsLoaded: Int = 0;
    
    var loadMoreStatus = false
    var loading = false
    
    var message: String = ""
    var giftAnonymous: Int = 0

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
    
    @IBAction func cancelTap(_ sender: Any) {
        
        self.dismiss(animated: true, completion: {})
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if ((offsetY > contentHeight - scrollView.frame.size.height) && !loading && items.count >= Constants.LIST_ITEMS) {
            
            loadMore()
        }
    }
    
    func loadMore() {
        
        if (!loadMoreStatus) {
            
            self.loadMoreStatus = true
            
            loadMoreBegin(newtext: "Load more",
                          loadMoreEnd: {(x:Int) -> () in
                            self.collectionView.reloadData()
                            self.loadMoreStatus = false
            })
        }
    }
    
    func loadMoreBegin(newtext:String, loadMoreEnd:@escaping (Int) -> ()) {
        
        self.getData();
    }
    
    func getData() {
        
        loading = true;
        
        var request = URLRequest(url: URL(string: Constants.METHOD_GIFTS_SELECT)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
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
                        self.items.append(GiftBase(Response: itemObj))
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
        
        if (self.itemsLoaded >= Constants.LIST_ITEMS) {
            
            self.loadMoreStatus = false
            
        } else {
            
            self.loadMoreStatus = true
        }
        
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectGiftCell", for: indexPath) as! SelectGiftCell
        
        var item: GiftBase;
        
        item = items[indexPath.row];
        
        cell.costLabel.text = String(item.getCost()) + " " + NSLocalizedString("label_credits", comment: "")
        
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
        
        var item: GiftBase;
        
        item = items[indexPath.row];
        
        if (iApp.sharedInstance.getBalance() < item.getCost()) {
            
            let alert = UIAlertController(title: NSLocalizedString("label_balance", comment: ""), message: NSLocalizedString("label_you_balance_null", comment: ""), preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)

        } else {
            
            
            let alert = UIAlertController(title: NSLocalizedString("label_you_balance", comment: "") + " " + String(iApp.sharedInstance.getBalance()) + " " + NSLocalizedString("label_credits", comment: ""), message: NSLocalizedString("label_you_sure", comment: ""), preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("action_cancel", comment: ""), style: UIAlertAction.Style.default, handler: nil))
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("action_send", comment: ""), style: UIAlertAction.Style.default) { action in
                
                self.send(itemId: item.getId(), cost: item.getCost())
            })
            
            self.present(alert, animated: true, completion: nil)

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if  (segue.identifier == "showItem") {
            
            // Create a new variable to store the instance of PlayerTableViewController
            let destinationVC = segue.destination as! ViewGalleryItemController
            destinationVC.itemId = self.collectionView.tag
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellsAcross: CGFloat = 3
        let spaceBetweenCells: CGFloat = 1
        let dim = (collectionView.bounds.width - (cellsAcross - 1) * spaceBetweenCells) / cellsAcross
        
        return CGSize(width: dim, height: dim)
    }
    
    func send(itemId: Int, cost: Int) {
        
        self.serverRequestStart();
        
        var request = URLRequest(url: URL(string: Constants.METHOD_GIFTS_SEND)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&giftId=" + String(itemId) + "&giftTo=" + String(self.profileId) + "&giftAnonymous=" + String(self.giftAnonymous) + "&message=" + self.message;
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                DispatchQueue.main.async() {
                    
                    self.serverRequestEnd();
                }
                
            } else {
                
                do {
                    
                    let response = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, AnyObject>
                    let responseError = response["error"] as! Bool;
                    
                    if (responseError == false) {
                        
                        iApp.sharedInstance.setBalance(balance: iApp.sharedInstance.getBalance() - cost)
                    }
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.serverRequestEnd();
                        
                        self.dismiss(animated: true, completion: {})
                    })
                    
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

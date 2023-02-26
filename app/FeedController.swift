//
//  FeedController.swift
//  SocialApp
//
//  Created by Mac Book on 01.10.2018.
//  Copyright © 2018 raccoonsquare@gmail.com. All rights reserved.
//

import UIKit

class FeedController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    
    @IBOutlet weak var textMessageView: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var refreshControl = UIRefreshControl()
    
    var items = [Photo]()
    
    var itemId: Int = 0;
    var itemsLoaded: Int = 0;
    
    var loadMoreStatus = false
    var loading = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // add tableview delegate
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // add refresh control
        
        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        self.collectionView.addSubview(refreshControl)
        self.collectionView.alwaysBounceVertical = true
        
        // prepare for loading data
        
        self.showLoadingScreen()
        
        // start loading data
        
        getData()
    }
    
    @objc func refresh(sender:AnyObject) {
        
        refreshBegin(newtext: "Refresh",
                     refreshEnd: {(x:Int) -> () in
                        
                        print("refresh end")
                        
                        self.collectionView.reloadData()
                        self.refreshControl.endRefreshing()
        })
    }
    
    func refreshBegin(newtext:String, refreshEnd:@escaping (Int) -> ()) {
        
        DispatchQueue.global().async {
            
            if (!self.loading) {
                
                print("refresh start")
                
                self.items.removeAll()
                
                self.collectionView.reloadData()
                
                self.itemId = 0;
                
                self.getData()
            }
            
            DispatchQueue.global().async  {
                
                refreshEnd(0)
            }
        }
        
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
        
        var request = URLRequest(url: URL(string: Constants.METHOD_GALLERY_FEED)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&itemId=" + String(self.itemId);
        
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
                        self.items.append(Photo(Response: itemObj))
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
        
        //1
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as! GalleryCell
        
        var item: Photo;
        
        item = items[indexPath.row];
        
        cell.photoView.isHidden = true
        cell.loadingIndicator.isHidden = false
        cell.loadingIndicator.startAnimating()

        if (item.getItemType() == Constants.ITEM_TYPE_VIDEO) {
            
            cell.photoView.image = UIImage(named: "ic_video_preview")
            
            cell.photoView.isHidden = false
            cell.loadingIndicator.isHidden = true
            cell.loadingIndicator.stopAnimating()
            
            
        } else {
            
            if (item.getImgUrl().count == 0) {
                
                cell.photoView.image = UIImage(named: "ic_profile_default_photo")
                
                cell.photoView.isHidden = false
                cell.loadingIndicator.isHidden = true
                cell.loadingIndicator.stopAnimating()
                
            } else {
                
                if (iApp.sharedInstance.getCache().object(forKey: item.getImgUrl() as AnyObject) != nil) {
                    
                    cell.photoView.image = iApp.sharedInstance.getCache().object(forKey: item.getImgUrl() as AnyObject) as? UIImage
                    
                    cell.photoView.isHidden = false
                    cell.loadingIndicator.isHidden = true
                    cell.loadingIndicator.stopAnimating()
                    
                } else {
                    
                    if (!item.photoLoading) {
                        
                        item.photoLoading = true;
                        
                        let imageUrlString = item.getImgUrl()
                        let imageUrl:URL = URL(string: imageUrlString)!
                        
                        DispatchQueue.global().async {
                            
                            let data = try? Data(contentsOf: imageUrl)
                            
                            DispatchQueue.main.async {
                                
                                if data != nil {
                                    
                                    let img = UIImage(data: data!)
                                    
                                    cell.photoView.image = img
                                    
                                    iApp.sharedInstance.getCache().setObject(img!, forKey: item.getImgUrl() as AnyObject)
                                    
                                    self.collectionView.reloadData()
                                    
                                    //self.collectionView.reloadItems(at: [indexPath])
                                }
                            }
                        }
                        
                    }
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var item: Photo;
        
        item = items[indexPath.row];
        
        self.collectionView.tag = item.getId()
        
        
        self.performSegue(withIdentifier: "showItem", sender: self)
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
    
    func serverRequestStart() {
        
        LoadingIndicatorView.show(NSLocalizedString("label_loading", comment: ""));
    }
    
    func serverRequestEnd() {
        
        LoadingIndicatorView.hide();
    }
    
    func showLoadingScreen() {
        
        self.textMessageView.isHidden = true
        
        self.loadingIndicator.isHidden = false
        self.loadingIndicator.startAnimating()
        
        self.collectionView.isHidden = true
    }
    
    func showContentScreen() {
        
        self.textMessageView.isHidden = true
        
        self.loadingIndicator.isHidden = true
        self.loadingIndicator.stopAnimating()
        
        self.collectionView.isHidden = false
    }
    
    func showEmptyScreen() {
        
        self.textMessageView.text = NSLocalizedString("label_empty", comment: "");
        self.textMessageView.isHidden = false
        
        self.loadingIndicator.isHidden = true
        self.loadingIndicator.stopAnimating()
        
        self.collectionView.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}

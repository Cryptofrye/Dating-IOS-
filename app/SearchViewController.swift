//
//  SearchViewController.swift
//
//  Created by Demyanchuk Dmitry on 27.07.21.
//  Copyright © 2021 raccoonsquare@gmail.com All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var textMessageView: UILabel!
    
    var items = [Profile]()
    
    var searchBar = UISearchBar()
    
    var itemId: Int = 0;
    var itemsLoaded: Int = 0;
    
    var query: String = ""
    
    var loadMoreStatus = false
    var loading = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        searchBar.sizeToFit()
        searchBar.placeholder = NSLocalizedString("placeholder_search", comment: "")
        
        self.navigationItem.titleView = searchBar
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        //self.searchBar.showsBookmarkButton = true
        //self.searchBar.setImage(UIImage(named: "Sort"), for: .bookmark, state: .normal)
        
        self.tableView.tableFooterView = UIView()
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44.0
        
        // Start preload data to show default users
        
        self.showLoadingScreen()
        
        getData(searchText: query);
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
                            self.tableView.reloadData()
                            self.loadMoreStatus = false
            })
        }
    }
    
    func loadMoreBegin(newtext:String, loadMoreEnd:@escaping (Int) -> ()) {
        
        self.getData(searchText: self.query);
    }

    
    func getData(searchText: String) {
        
        loading = true;
        
        var request = URLRequest(url: URL(string: Constants.METHOD_SEARCH_PEOPLE)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = "POST"
        let postString = "clientId=" + String(Constants.CLIENT_ID) + "&accountId=" + String(iApp.sharedInstance.getId()) + "&accessToken=" + iApp.sharedInstance.getAccessToken() + "&query=" + searchText + "&itemId=" + String(self.itemId) + "&gender=" + String(3) + "&photo=" + String(0) + "&online=" + String(0);
        
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
                self.loadingComplete()
                
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
                        self.items.append(Profile(Response: itemObj))
                    }
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.loadingComplete()
                    })
                    
                } else {
                    
                    //Error status = true | Server return error in response
                    //Print response to console
                    
                    self.loadingComplete()
                }
                
                //Read data from response success | hide loadingindicator if need)
                
            } catch {
                
                self.loadingComplete()
            }
            
        }).resume();
    }
    
    func loadingComplete() {
        
        if (self.itemsLoaded >= Constants.LIST_ITEMS) {
            
            self.loadMoreStatus = false
            
        } else {
            
            self.loadMoreStatus = true
        }
        
        self.tableView.reloadData()
        self.loading = false
        
        if (items.count > 0) {
            
            showContentScreen();
            
        } else {
            
            showEmptyScreen();
        }
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        
        //showAlert, presentVC or whatever you want here
        
//        let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
        
        self.itemId = 0;
        
        self.items.removeAll();
        
        self.tableView.reloadData();
        
        showLoadingScreen();
        
        self.query = self.searchBar.text!
        
        getData(searchText: self.query)
        
        self.searchBar.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if  (segue.identifier == "showProfile") {
            
            // Create a new variable to store the instance of ProfileController
            let destinationVC = segue.destination as! ProfileController
            destinationVC.profileId = self.tableView.tag
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
//    func tableView(_ tableView : UITableView,  titleForHeaderInSection section: Int) -> String? {
//
//        if self.itemCount != 0 {
//
//            return NSLocalizedString("label_people_search_result", comment: "") + "(" + String(itemCount) + ")"
//
//        } else {
//
//            return ""
//        }
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//
//        if ((section == 1 && self.itemCount == 0) || (self.preload)) {
//
//            return 0
//
//        } else {
//
//            return UITableView.automaticDimension
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        
        var profile: Profile;
        
        profile = items[indexPath.row];
        
        cell.photoView.tag = indexPath.row
        cell.fullnameLabel.tag = indexPath.row
        cell.addonLabel.tag = indexPath.row
        
        
        cell.fullnameLabel.text = profile.getFullname()
        cell.addonLabel.text = profile.getUsername()
        
        cell.photoView.layer.borderWidth = 1
        cell.photoView.layer.masksToBounds = false
        cell.photoView.layer.borderColor = UIColor.lightGray.cgColor
        cell.photoView.layer.cornerRadius = cell.photoView.frame.height/2
        cell.photoView.clipsToBounds = true
        
        cell.photoView.image = UIImage(named: "ic_profile_default_photo")
        
        if (profile.getPhotoUrl().count == 0) {
            
            cell.photoView.image = UIImage(named: "ic_profile_default_photo")
            
        } else {
            
            if (iApp.sharedInstance.getCache().object(forKey: profile.getPhotoUrl() as AnyObject) != nil) {
                
                cell.photoView.image = iApp.sharedInstance.getCache().object(forKey: profile.getPhotoUrl() as AnyObject) as? UIImage
                
            } else {
                
                if (!profile.photoLoading) {
                    
                    profile.photoLoading = true;
                    
                    let imageUrlString = profile.getPhotoUrl()
                    let imageUrl:URL = URL(string: imageUrlString)!
                    
                    DispatchQueue.global().async {
                        
                        let data = try? Data(contentsOf: imageUrl)
                        
                        DispatchQueue.main.async {
                            
                            if data != nil {
                                
                                let img = UIImage(data: data!)
                                
                                cell.photoView.image = img
                                
                                iApp.sharedInstance.getCache().setObject(img!, forKey: profile.getPhotoUrl() as AnyObject)
                                
                                self.tableView.reloadData()
                            }
                        }
                    }
                    
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var profile: Profile;
        
        profile = items[indexPath.row];
        
        self.tableView.tag = profile.getId()
        
        self.performSegue(withIdentifier: "showProfile", sender: self)
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showLoadingScreen() {
        
        self.textMessageView.isHidden = true
        
        self.indicatorView.isHidden = false
        self.indicatorView.startAnimating()
        
        self.tableView.isHidden = true
    }
    
    func showContentScreen() {
        
        self.textMessageView.isHidden = true
        
        self.indicatorView.isHidden = true
        self.indicatorView.stopAnimating()
        
        self.tableView.isHidden = false
    }
    
    func showEmptyScreen() {
        
        self.textMessageView.text = NSLocalizedString("label_search_empty", comment: "");
        self.textMessageView.isHidden = false
        
        self.indicatorView.isHidden = true
        self.indicatorView.stopAnimating()
        
        self.tableView.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}

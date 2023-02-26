//
//  GiftBase.swift
//
//  Created by Demyanchuk Dmitry on 27.01.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//

import UIKit

class GiftBase {
    
    public var imgLoading = false
    
    private var id: Int = 0
    
    private var cost: Int = 0
    
    private var imgUrl: String?
    
    private var date: String?
    private var timeAgo: String?
    
    init(Response: AnyObject) {
        
        self.setId(id: Int((Response["id"] as? String)!)!)
        
        self.setCost(cost: Int((Response["cost"] as? String)!)!)
        
        self.setImgUrl(imgUrl: (Response["imgUrl"] as? String)!)
        
        self.setDate(date: (Response["date"] as? String)!)
        self.setTimeAgo(timeAgo: (Response["timeAgo"] as? String)!)
        
    }
    
    init() {
        
    }
    
    public func setId(id: Int) {
        
        self.id = id;
    }
    
    func getId() -> Int {
        
        return self.id;
    }
    
    public func setCost(cost: Int) {
        
        self.cost = cost;
    }
    
    func getCost() -> Int {
        
        return self.cost;
    }
    
    public func setImgUrl(imgUrl: String) {
        
        self.imgUrl = imgUrl.replacingOccurrences(of: "/../", with: "/")
    }
    
    public func getImgUrl()->String {
        
        return self.imgUrl!
    }
    
    public func setDate(date: String) {
        
        self.date = date
    }
    
    public func getDate()->String {
        
        return self.date!
    }
    
    public func setTimeAgo(timeAgo: String) {
        
        self.timeAgo = timeAgo
    }
    
    public func getTimeAgo()->String {
        
        return self.timeAgo!
    }
}

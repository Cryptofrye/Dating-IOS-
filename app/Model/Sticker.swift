//
//  Sticker.swift
//
//  Created by Demyanchuk Dmitry on 01.12.17.
//  Copyright © 2017 raccoonsquare@gmail.com All rights reserved.
//

import UIKit

class Sticker {
    
    public var imgLoading = false
    
    private var id: Int = 0
    
    private var cost: Int = 0
    
    private var category: Int = 0
    
    private var imgUrl: String?
    
    init(Response: AnyObject) {
        
        self.setId(id: Int((Response["id"] as? String)!)!)
        
        self.setCost(cost: Int((Response["cost"] as? String)!)!)
        
        self.setCategory(category: Int((Response["category"] as? String)!)!)
        
        self.setImgUrl(imgUrl: (Response["imgUrl"] as? String)!)
        
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
    
    public func setCategory(category: Int) {
        
        self.category = category;
    }
    
    func getCategory() -> Int {
        
        return self.category;
    }
    
    public func setImgUrl(imgUrl: String) {
        
        self.imgUrl = imgUrl.replacingOccurrences(of: "/../", with: "/")
    }
    
    public func getImgUrl()->String {
        
        return self.imgUrl!
    }
}


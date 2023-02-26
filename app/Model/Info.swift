//
//  Info.swift
//
//  Created by Demyanchuk Dmitry on 27.01.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//

import UIKit

class Info {
    
    public var image = UIImage()
    
    private var id: Int = 0
    
    private var title: String?
    private var detail: String?
    
    init(id: Int, title: String, detail: String, image: UIImage) {
        
        self.setId(id: id)
        self.setTitle(title: title)
        self.setDetail(detail: detail)
        self.setImage(image: image)
    }
    
    public func setId(id: Int) {
        
        self.id = id;
    }
    
    func getId() -> Int {
        
        return self.id;
    }
    
    public func setImage(image: UIImage) {
        
        self.image = image;
    }
    
    func getImage() -> UIImage {
        
        return self.image;
    }
    
    public func setTitle(title: String) {
        
        self.title = title;
    }
    
    func getTitle() -> String {
        
        return self.title!;
    }
    
    public func setDetail(detail: String) {
        
        self.detail = detail;
    }
    
    func getDetail() -> String {
        
        return self.detail!;
    }
}

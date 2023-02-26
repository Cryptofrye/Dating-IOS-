//
//  iSettings.swift
//  SocialApp
//
//  Created by Demyanchuk Dmitry on 20.12.2019.
//  Copyright © 2019 Ifsoft. All rights reserved.
//

import UIKit

class iSettings {
    
    private var defaultGhostModeCost: Int = 100;
    private var defaultVerifiedBadgeCost: Int = 150;
    private var defaultDisableAdsCost: Int = 200;
    private var defaultProModeCost: Int = 170;
    private var defaultSpotlightCost: Int = 30;
    private var defaultMessagePackageCost: Int = 20;
    
    init() {
        
    }
    
    public func setGhostModeCost(defaultGhostModeCost: Int) {
        
        self.defaultGhostModeCost = defaultGhostModeCost;
    }
    
    func getGhostModeCost() -> Int {
        
        return self.defaultGhostModeCost;
    }
    
    public func setVerifiedBadgeCost(defaultVerifiedBadgeCost: Int) {
        
        self.defaultVerifiedBadgeCost = defaultVerifiedBadgeCost;
    }
    
    func getVerifiedBadgeCost() -> Int {
        
        return self.defaultVerifiedBadgeCost;
    }
    
    public func setDisableAdsCost(defaultDisableAdsCost: Int) {
        
        self.defaultDisableAdsCost = defaultDisableAdsCost;
    }
    
    func getDisableAdsCost() -> Int {
        
        return self.defaultDisableAdsCost;
    }
    
    public func setProModeCost(defaultProModeCost: Int) {
        
        self.defaultProModeCost = defaultProModeCost;
    }
    
    func getProModeCost() -> Int {
        
        return self.defaultProModeCost;
    }

    public func setSpotlightCost(defaultSpotlightCost: Int) {
        
        self.defaultSpotlightCost = defaultSpotlightCost;
    }
    
    func getSpotlightCost() -> Int {
        
        return self.defaultSpotlightCost;
    }
    
    public func setMessagePackageCost(defaultMessagePackageCost: Int) {
        
        self.defaultMessagePackageCost = defaultMessagePackageCost;
    }
    
    func getMessagePackageCost() -> Int {
        
        return self.defaultMessagePackageCost;
    }
}

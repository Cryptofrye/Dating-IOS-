//
//  LoadingIndicatorView.swift
//  SwiftLoadingIndicator
//
//  Created by Vince Chan on 12/2/15.
//  Copyright © 2015 Vince Chan. All rights reserved.
//
import UIKit

class LoadingIndicatorView {
    
    static var currentOverlay : UIView?
    
    static func show() {
        
        guard let currentMainWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first else {
            
            print("No main window.")
            return
        }
        
        show(currentMainWindow)
    }
    
    static func show(_ loadingText: String) {
        guard let currentMainWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first else {
            
            print("No main window.")
            return
        }
        
        show(currentMainWindow, loadingText: loadingText)
    }
    
    static func show(_ overlayTarget : UIView) {
        show(overlayTarget, loadingText: nil)
    }
    
    static func show(_ overlayTarget : UIView, loadingText: String?) {
        // Clear it first in case it was already shown
        hide()
        
        // Create the overlay
        let overlay = UIView(frame: overlayTarget.frame)
        overlay.center = overlayTarget.center
        overlay.alpha = 0
        overlay.backgroundColor = UIColor.black
        overlayTarget.addSubview(overlay)
        overlayTarget.bringSubviewToFront(overlay)
        
        // Create and animate the activity indicator
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        indicator.center = overlay.center
        indicator.startAnimating()
        overlay.addSubview(indicator)
        
        // Create label
        if let textString = loadingText {
            let label = UILabel()
            label.text = textString
            label.textColor = UIColor.white
            label.sizeToFit()
            label.center = CGPoint(x: indicator.center.x, y: indicator.center.y + 30)
            overlay.addSubview(label)
        }
        
        // Animate the overlay to show
        UIView.animate(withDuration: 0.5, animations: {
            
            overlay.alpha = overlay.alpha > 0 ? 0 : 0.5
        })
        
        currentOverlay = overlay
    }
    
    static func hide() {
        if currentOverlay != nil {
            currentOverlay?.removeFromSuperview()
            currentOverlay =  nil
        }
    }
}

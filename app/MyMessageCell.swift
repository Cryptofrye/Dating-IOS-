//
//  MyMessageCell.swift
//  SocialApp
//
//  Created by Mac Book on 25.01.17.
//  Copyright © 2017 Ifsoft. All rights reserved.
//

import UIKit

class MyMessageCell: UITableViewCell {

    @IBOutlet weak var messageView: UILabel!
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var timeAgo: UILabel!
    
    @IBOutlet weak var pictureHeight: NSLayoutConstraint!
    @IBOutlet weak var pictureTop: NSLayoutConstraint!
    

    override func prepareForReuse() {
        
        // Reset the cell for new row's data
        
        self.pictureTop.constant = 8
        self.pictureHeight.constant = 128
        
        super.prepareForReuse()
    }
}

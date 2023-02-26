//
//  MessageCell.swift
//
//  Created by Demyanchuk Dmitry on 05.01.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var messageView: UILabel!
    @IBOutlet weak var timeAgo: UILabel!
    @IBOutlet weak var pictureView: UIImageView!
    
    
    @IBOutlet weak var pictureHeight: NSLayoutConstraint!
    @IBOutlet weak var pictureTop: NSLayoutConstraint!
    
    
    override func prepareForReuse() {
        
        // Reset the cell for new row's data
        
        self.pictureTop.constant = 8
        self.pictureHeight.constant = 128
        
        photoView.image = UIImage(named: "ic_profile_default_photo")
        
        super.prepareForReuse()
    }
}

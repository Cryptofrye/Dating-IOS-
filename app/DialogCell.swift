//
//  DialogCell.swift
//
//  Created by Demyanchuk Dmitry on 27.01.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//

import UIKit

class DialogCell: UITableViewCell {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var messagesCountLabel: UILabel!
    

    override func prepareForReuse() {
        
        // Reset the cell for new row's data
        
        photoView.image = UIImage(named: "ic_profile_default_photo")
        
        super.prepareForReuse()
    }
}

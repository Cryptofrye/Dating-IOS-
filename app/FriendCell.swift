//
//  FriendCell.swift
//
//  Created by Demaynchuk Dmitry on 26.01.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    override func prepareForReuse() {
        
        // Reset the cell for new row's data
        
        photoView.image = UIImage(named: "ic_profile_default_photo")
        
        super.prepareForReuse()
    }
}

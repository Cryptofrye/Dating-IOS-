//
//  GiftCell.swift
//
//  Created by Demyanchuk Dmitry on 03.02.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//

import UIKit

class GiftCell: UITableViewCell {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var actionView: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var pictureView: UIImageView!
    
    override func prepareForReuse() {
        
        // Reset the cell for new row's data
        
        photoView.image = UIImage(named: "ic_profile_default_photo")
        
        super.prepareForReuse()
    }

}

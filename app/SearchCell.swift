//
//  SearchCell.swift
//
//  Created by Demyanchuk Dmitry on 25.01.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var addonLabel: UILabel!
    
    
    override func prepareForReuse() {
        
        // Reset the cell for new row's data
        
        photoView.image = UIImage(named: "ic_profile_default_photo")
        
        photoView.layer.borderWidth = 1
        photoView.layer.masksToBounds = false
        photoView.layer.borderColor = UIColor.lightGray.cgColor
        photoView.layer.cornerRadius = photoView.frame.height/2
        photoView.clipsToBounds = true
        
        super.prepareForReuse()
    }
}

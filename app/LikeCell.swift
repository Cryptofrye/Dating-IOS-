//
//  LikeCell.swift
//
//  Created by Demyanchuk Dmitry on 27.01.17.
//  Copyright © 2017 Ifsoft. All rights reserved.
//

import UIKit

class LikeCell: UITableViewCell {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fullnameLabel: UILabel!
    
    override func prepareForReuse() {
        
        // Reset the cell for new row's data
        
        photoView.image = UIImage(named: "ic_profile_default_photo")
        
        super.prepareForReuse()
    }
}

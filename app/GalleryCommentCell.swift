//
//  GalleryCommentCell.swift
//
//  Created by Demyanchuk Dmitry on 29.01.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//

import UIKit

class GalleryCommentCell: UITableViewCell {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var fullnameView: UILabel!
    @IBOutlet weak var commentView: UILabel!
    @IBOutlet weak var timeAgoView: UILabel!
    
    

    override func prepareForReuse() {
        
        // Reset the cell for new row's data
        
        photoView.image = UIImage(named: "ic_profile_default_photo")
        
        super.prepareForReuse()
    }
}

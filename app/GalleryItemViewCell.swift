//
//  GalleryItemViewCell.swift
//
//  Created by Demyanchuk Dmitry on 30.01.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//

import UIKit

class GalleryItemViewCell: UITableViewCell {

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var commentButton: UIImageView!
    @IBOutlet weak var commentsCountLabel: UILabel!
    @IBOutlet weak var likeButton: UIImageView!
    @IBOutlet weak var likesCount: UILabel!

    override func prepareForReuse() {
        
        // Reset the cell for new row's data
        
        photoView.image = UIImage(named: "ic_profile_default_photo")
        
        super.prepareForReuse()
    }
}

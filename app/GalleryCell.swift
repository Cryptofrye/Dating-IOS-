//
//  GalleryCell.swift
//
//  Created by Demyanchuk Dmitry on 27.01.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//

import UIKit

class GalleryCell: UICollectionViewCell {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        self.photoView.image = UIImage()
    }
}

//
//  SelectStickerCell.swift
//
//  Created by Demyanchuk Dmitry on 03.02.17.
//  Copyright © 2020 raccoonsquare@gmail.com All rights reserved.
//

import UIKit

class SelectStickerCell: UICollectionViewCell {
    
    @IBOutlet weak var pictureView: UIImageView!
    
    override func prepareForReuse() {
        
        // Reset the cell for new row's data
        
        pictureView.image = UIImage(named: "app_logo")
        
        super.prepareForReuse()
    }
}


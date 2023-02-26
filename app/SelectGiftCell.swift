//
//  SelectGiftCell.swift
//
//  Created by Demyanchuk Dmitry on 03.02.17.
//  Copyright © 2017 qascript@mail.ru All rights reserved.
//

import UIKit

class SelectGiftCell: UICollectionViewCell {
    
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var costLabel: UILabel!
    
    
    override func prepareForReuse() {
        
        // Reset the cell for new row's data
        
        pictureView.image = UIImage(named: "app_logo")
        
        super.prepareForReuse()
    }
}

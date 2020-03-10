//
//  MediaTableViewCell.swift
//  MediaList
//
//  Created by  on 04/03/2020.
//  Copyright © 2020 Da Costa Paolo. All rights reserved.
//

import UIKit

class MediaTableViewCell: UITableViewCell {

    
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

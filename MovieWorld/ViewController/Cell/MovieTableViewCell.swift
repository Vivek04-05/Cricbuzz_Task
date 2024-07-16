//
//  MovieTableViewCell.swift
//  MovieWorld
//
//  Created by Vivek Patel on 15/07/24.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet var imgView: UIImageView!
    
    @IBOutlet var textLbl1: UILabel!
    
    @IBOutlet var textLbl2: UILabel!
    
    @IBOutlet var textLbl3: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

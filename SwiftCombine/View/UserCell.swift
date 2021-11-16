//
//  UserCell.swift
//  SwiftCombine
//
//  Created by Rex Lin on 2021/10/8.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        userImage.layer.cornerRadius = userImage.frame.size.width/2
    }
    
    func setData(randomUser:RandomUser) {
        
        let title = randomUser.name.title
        let first = randomUser.name.first
        let last = randomUser.name.last
        let picture = randomUser.picture.medium
        
        
        label.text = "\(title). \(first) \(last)"
        setImage(imageView: userImage, urlSting: picture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

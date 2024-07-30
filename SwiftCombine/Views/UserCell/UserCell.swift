//
//  UserCell.swift
//  SwiftCombine
//
//  Created by Rex Lin on 2021/10/8.
//

import Combine
import UIKit

class UserCell: UITableViewCell {
    @IBOutlet var locationButton: UIButton!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var label: UILabel!
    var subscribers = [AnyCancellable]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        userImage.layer.cornerRadius = userImage.frame.size.width / 2
    }

    func setData(randomUser: RandomUser) {
        let title = randomUser.name?.title ?? ""
        let first = randomUser.name?.first ?? ""
        let last = randomUser.name?.last ?? ""
        label.text = "\(title). \(first) \(last)"

        if let picture = randomUser.picture?.medium {
            userImage.setImage(urlString: picture)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        userImage.image = nil
    }
}

//
//  UserDetailView.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2024/7/14.
//

import UIKit

// MARK: - UserDetailView

class UserDetailView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var containerView: UIView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    func setData(userData: RandomUser) {
        userImage.image = nil

        if let largePicture = userData.picture?.large {
            userImage.setImage(urlString: largePicture)
        }

        let title = userData.name?.title ?? ""
        let first = userData.name?.first ?? ""
        let last = userData.name?.last ?? ""
        nameLabel.text = "\(title). \(first) \(last)"

        let gender = userData.gender ?? ""
        genderLabel.text = "Gender: \(gender)"

        let phone = userData.phone ?? ""
        phoneLabel.text = "Phone: \(phone)"

        let email = userData.email ?? ""
        emailLabel.text = "Email: \(email)"

        let city = userData.location?.city ?? ""
        let country = userData.location?.country ?? ""
        locationLabel.text = "Location: \(city) \(country)"
    }

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
         // Drawing code
     }
     */
}

// MARK: - Private Methods

private extension UserDetailView {
    func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        Bundle(for: UserDetailView.self).loadNibNamed("\(UserDetailView.self)",
                                                      owner: self,
                                                      options: nil)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)

        userImage.layer.cornerRadius = userImage.frame.size.height / 2
        userImage.layer.borderWidth = 2.0
        userImage.layer.borderColor = UIColor.systemMint.cgColor
        containerView.layer.cornerRadius = 10.0
    }
}

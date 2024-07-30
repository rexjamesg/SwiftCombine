//
//  RandomUserListView.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2024/7/15.
//

import UIKit

// MARK: - RandomUserListView

class RandomUserListView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var tableView: UITableView! {
        didSet {
            let nib = UINib(nibName: "\(UserCell.self)", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "\(UserCell.self)")
            tableView.refreshControl = refreshControl
        }
    }
    
    let refreshControl = UIRefreshControl()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
         // Drawing code
     }
     */
}

// MARK: - Private Properties

// MARK: - Private Methods

private extension RandomUserListView {
    func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        Bundle(for: RandomUserListView.self).loadNibNamed("\(RandomUserListView.self)",
                                                          owner: self,
                                                          options: nil)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
    }
}

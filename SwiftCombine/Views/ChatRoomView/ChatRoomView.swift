//
//  ChatRoomView.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2025/2/5.
//

import UIKit

class ChatRoomView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        }
    }
    
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

//MARK: - Private Methods
private extension ChatRoomView {
    func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        Bundle(for: ChatRoomView.self).loadNibNamed("\(ChatRoomView.self)",
                                                 owner: self,
                                                 options: nil)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
    }
}

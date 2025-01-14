//
//  SideMenuView.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2025/1/14.
//

import UIKit

class RandomUserSideMenuView: UIView {

    @IBOutlet var sideMenuHideConstraint: NSLayoutConstraint!
    @IBOutlet var sideMenuTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var menuBaseView: UIView!
    @IBOutlet var tableView: UITableView!
    
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
    
    func setMenu(display: Bool) {
        
        UIView.animate(withDuration: 0.3) {
             [weak self] in
            guard let self = self else { return }
            self.sideMenuHideConstraint.isActive = !display
            self.sideMenuTrailingConstraint.isActive = display
            self.layoutIfNeeded()
        }
    }
}


//MARK: - Private Methods
private extension RandomUserSideMenuView {
    func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        Bundle(for: RandomUserSideMenuView.self).loadNibNamed("\(RandomUserSideMenuView.self)",
                                                 owner: self,
                                                 options: nil)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
    }
}

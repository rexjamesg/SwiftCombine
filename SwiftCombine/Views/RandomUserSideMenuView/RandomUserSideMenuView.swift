//
//  SideMenuView.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2025/1/14.
//

import UIKit

// MARK: - RandomUserSideMenuView

class RandomUserSideMenuView: UIView {
    // MARK: - Public Properties

    @IBOutlet var contentView: UIView!
    @IBOutlet var menuBaseView: UIView!
    @IBOutlet var baseCoverView: UIView!
    @IBOutlet var tableView: UITableView!{
        didSet {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        }
    }
    
    var didEndDragView: (()->Void)?
    var onAutoHideView: (()->Void)?

    // MARK: - Private Properties

    @IBOutlet private var sideMenuTrailingConstraint: NSLayoutConstraint!
    private var dragleadingConstraint: NSLayoutConstraint!
    private var menuBaseTrailing = 79.0

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
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            if display {
                self.sideMenuTrailingConstraint.constant = self.menuBaseTrailing
            } else {
                self.sideMenuTrailingConstraint.constant = self.bounds.width
            }
            self.layoutIfNeeded()
        }) { [weak self] _ in
            guard let self = self else { return }
            if !display {
                self.onAutoHideView?()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first?.location(in: baseCoverView) {
            setMenu(display: false)
        }
    }
}

// MARK: - Private Methods

private extension RandomUserSideMenuView {
    func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        Bundle(for: RandomUserSideMenuView.self).loadNibNamed("\(RandomUserSideMenuView.self)",
                                                              owner: self,
                                                              options: nil)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
        setGesture()
    }

    func setGesture() {
        menuBaseView.translatesAutoresizingMaskIntoConstraints = false

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        menuBaseView.addGestureRecognizer(panGesture)
    }

    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)

        switch gesture.state {
        case .changed:

            let finalX = sideMenuTrailingConstraint.constant - translation.x
            if finalX >= menuBaseTrailing, finalX <= bounds.width {
                sideMenuTrailingConstraint.constant -= translation.x
            }

            // 讓 Auto Layout 立即更新畫面
            layoutIfNeeded()

            // 重置 translation，避免累計位移
            gesture.setTranslation(.zero, in: self)

        case .ended, .cancelled:
            let finalX = sideMenuTrailingConstraint.constant - translation.x
            var constant = menuBaseTrailing
            var shouldHideView = false
            if finalX > bounds.width / 2 {
                // 自動滑出
                shouldHideView = true
                constant = bounds.width
            }

            // 加入回彈效果
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, animations: { [weak self] in
                guard let self = self else { return }
                self.sideMenuTrailingConstraint.constant = constant
                self.layoutIfNeeded()
            }) { [weak self] finished in
                guard let self = self else { return }
                if shouldHideView {
                    self.didEndDragView?()
                }
            }

            print("end cancelled")
        default:
            break
        }
    }
}

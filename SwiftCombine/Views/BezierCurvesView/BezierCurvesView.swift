//
//  BezierCurvesView.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2025/2/14.
//

import UIKit

class BezierCurvesView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var curvesView: UIView!
    @IBOutlet var xValueLabel: UILabel!
    @IBOutlet var yValueLabel: UILabel!
    
    @IBOutlet var yUpButton: UIButton!
    @IBOutlet var yDownButton: UIButton!
    
    
    @IBOutlet var xLeftButton: UIButton!
    @IBOutlet var xRightButton: UIButton!
    
    
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
private extension BezierCurvesView {
    func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        Bundle(for: BezierCurvesView.self).loadNibNamed("\(BezierCurvesView.self)",
                                                 owner: self,
                                                 options: nil)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
    }
}

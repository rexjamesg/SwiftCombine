//
//  UIViewExtension.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2024/7/18.
//

import Foundation
import UIKit

extension UIView {
    func tapScaleAnmation(finished: (()->Void)?=nil) {
        UIView.animate(withDuration: 0.15) { [weak self] in
            guard let self = self else { return }
            self.transform = CGAffineTransformMakeScale(1.2, 1.2)
        } completion: { _ in
            UIView.animate(withDuration: 0.15) { [weak self] in
                guard let self = self else { return }
                self.transform = CGAffineTransformMakeScale(1.0, 1.0)
            } completion: { _ in
                finished?()
            }
        }
    }
}

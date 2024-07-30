//
//  UIViewExtension.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2024/7/18.
//

import Foundation
import UIKit

extension UIView {
    func tapScaleAnimation(duration: TimeInterval = 0.15, scale: CGFloat = 1.2, completion: (() -> Void)? = nil) {
        animateScale(to: scale, duration: duration) { [weak self] in
            guard let self = self else { return }
            self.animateScale(to: 1.0, duration: duration, completion: completion)
        }
    }

    private func animateScale(to scale: CGFloat, duration: TimeInterval, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: { [weak self] in
            guard let self = self else { return }
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: { _ in
            completion?()
        })
    }
}

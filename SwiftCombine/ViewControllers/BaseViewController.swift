//
//  BaseViewController.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2024/7/18.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func setNavigationBarstyle(title: String? = nil, titleColor: UIColor = .black, backButtonColor _: UIColor = .systemBlue, backButtonTitleColor _: UIColor = .systemBlue, shadowColor: UIColor = .clear, backgroundColor: UIColor? = .clear) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = backgroundColor
        appearance.shadowColor = shadowColor

        // navigationItem title 樣式
        let attrs = [
            NSAttributedString.Key.foregroundColor: titleColor,
            NSAttributedString.Key.font: UIFont(name: "Georgia-Bold", size: 24)!,
        ]

        appearance.titleTextAttributes = attrs
        appearance.largeTitleTextAttributes = [.foregroundColor: titleColor]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.title = title
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}

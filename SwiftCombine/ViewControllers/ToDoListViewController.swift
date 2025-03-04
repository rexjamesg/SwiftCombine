//
//  ToDoListViewController.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2025/2/17.
//

import UIKit
import SwiftUI

class ToDoListViewController: UIViewController {

    //MARK: - Private Properties
    private var contentView:ToDoListView?
    private var viewModel = TodoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupViews()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
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

//MARK: - Private Methods
private extension ToDoListViewController {
    func setupViews() {
        contentView = ToDoListView(popAction: { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }, viewModel: viewModel)
        let vc = UIHostingController(rootView: contentView)
        addChild(vc)
        view.addSubview(vc.view)
        
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vc.view.topAnchor.constraint(equalTo: view.topAnchor),
            vc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            vc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        vc.didMove(toParent: self)
    }
}

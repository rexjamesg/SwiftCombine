//
//  RandomUserSwiftUIVersionViewController.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2025/2/17.
//

import UIKit
import SwiftUI

class RandomUserSwiftUIVersionViewController: UIViewController {

    //MARK: - Private Properties
    private var contentView:RandomUserSwiftUIView?
    private var viewModel = SwiftUIRandomUserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupViews()
        
        viewModel.loadUsers()
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
private extension RandomUserSwiftUIVersionViewController {
    func setupViews() {
        contentView = RandomUserSwiftUIView(popAction: { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }, viewModel: viewModel)
        
        contentView?.loadNextPage = { [weak self] in
            guard let self = self else { return }
            self.viewModel.loadUsers()
        }
        
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

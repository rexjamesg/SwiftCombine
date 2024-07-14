//
//  RandomUserListViewController.swift
//  SwiftCombine
//
//  Created by Rex Lin on 2021/10/8.
//

import UIKit
import Combine
import SwiftUI

class RandomUserListViewController: UIViewController {

    private var subscribers:[AnyCancellable] = []
    private var viewModel = RandomUserViewModel()
    private var circleIndicator:UIHostingController<CircleIndicator>?
    private var dataTableView:UITableView = {
        let tableView = UITableView()
        let nib = UINib.init(nibName: "\(UserCell.self)", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "\(UserCell.self)")
        return tableView
    }()
    private var detailView:UserDetailView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        setupViews()
        bind()
        loadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let detailView = self.detailView {
            detailView.removeFromSuperview()
        }
    }
}

//MARK: - Private Methods
private extension RandomUserListViewController {
    func setupViews() {
        view.addSubview(dataTableView)
        dataTableView.frame = view.bounds
        dataTableView.delegate = self
    }
    
    func showIndicator() {
        circleIndicator = UIHostingController(rootView: CircleIndicator())
        if let vc = circleIndicator {
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            addChild(vc)
            view.addSubview(vc.view)
            //要在addSubview之後做，否則找不到view的constraint，會crash
            NSLayoutConstraint.activate([
                vc.view.widthAnchor.constraint(equalToConstant: 50),
                vc.view.widthAnchor.constraint(equalToConstant: 50),
                vc.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                vc.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            vc.view.backgroundColor = .clear
            vc.didMove(toParent: self)
        }
    }
    
    func hideIndecator() {
        circleIndicator?.willMove(toParent: nil)
        circleIndicator?.view.removeFromSuperview()
        circleIndicator?.removeFromParent()
    }
    
    func presentUserDetailView(userData: RandomUser) {
        detailView = UserDetailView()
        guard let detailView = self.detailView else { return }
        view.addSubview(detailView)
        detailView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.topAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        detailView.userImage.setImage(urlSting: userData.picture.large)
        let title = userData.name.title
        let first = userData.name.first
        let last = userData.name.last
        detailView.nameLabel.text = "\(title). \(first) \(last)"
        detailView.genderLabel.text = "Gender: \(userData.gender)"
        detailView.phoneLabel.text = "Phone: \(userData.phone)"
        detailView.emailLabel.text = "Email: \(userData.email)"
        detailView.locationLabel.text = "Location: \(userData.location.city) \(userData.location.country)"
    }
    
    func loadData() {
        viewModel.input.load.send(viewModel.currentPage)
        showIndicator()
    }
    
    func updateSnapShot(items:[RandomUser]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, RandomUser>()
        snapshot.appendSections([0])
        
        items.forEach {
            snapshot.appendItems([$0], toSection: 0)
        }
        
        viewModel.tableViewDiffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}

//MARK: - Bind
private extension RandomUserListViewController {
    func bind() {
        viewModel.tableViewDiffableDataSource = UITableViewDiffableDataSource(tableView: dataTableView, cellProvider: {  tableView, indexPath, item in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(UserCell.self)", for: indexPath)
            
            if let cell = cell as? UserCell {
                cell.setData(randomUser: item)
            }
                               
            return cell
        })
        
        viewModel.output.didReceiveList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] list in
                guard let self = self else { return }
                self.updateSnapShot(items: list)
                self.hideIndecator()
        }.store(in: &subscribers)
    }
}

extension RandomUserListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !viewModel.isLoading && indexPath.row >= viewModel.randomUsers.count-3 {
            loadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let data = viewModel.randomUsers[safe: indexPath.row] {
            if let cell = tableView.cellForRow(at: indexPath) {
                UIView.animate(withDuration: 0.15) {
                    cell.transform = CGAffineTransformMakeScale(1.2, 1.2)
                } completion: { _ in
                    UIView.animate(withDuration: 0.15) {
                        cell.transform = CGAffineTransformMakeScale(1.0, 1.0)
                    } completion: { [weak self] _ in
                        guard let self = self else { return }
                        self.presentUserDetailView(userData: data)
                    }
                }
            }
        }
    }
}


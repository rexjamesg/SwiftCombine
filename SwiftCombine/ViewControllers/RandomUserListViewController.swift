//
//  RandomUserListViewController.swift
//  SwiftCombine
//
//  Created by Rex Lin on 2021/10/8.
//

import UIKit
import Combine
import SwiftUI

class RandomUserListViewController: BaseViewController {

    //MARK: - Private Properties
    private let contentView = RandomUserListView()
    private var viewModel = RandomUserViewModel()
    private var detailView:UserDetailView?
    private var subscribers:[AnyCancellable] = []
    private let footerHeight = 50.0

    //MARK: - SwiftUI
    private var circleIndicator:UIHostingController<CircleIndicator>?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        setupViews()
        setDetailView()
        bind()
        loadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let detailView = self.detailView {
            detailView.isHidden = true
        }
    }
}

//MARK: - Private Methods
private extension RandomUserListViewController {
    func setupViews() {

        setNavigationBarstyle(title: "Random User", titleColor: .white, backgroundColor: UIColor(named: "#0088CC"))

        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        setIndicator()
        contentView.tableView.delegate = self
        contentView.refreshControl.addTarget(self, action: #selector(refreshAction(sender:)), for: .valueChanged)
    }

    func setDetailView() {
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

        detailView.isHidden = true
    }

    func setIndicator() {
        circleIndicator = UIHostingController(rootView: CircleIndicator())
        if let vc = circleIndicator {
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            addChild(vc)
            //要在addSubview之後做，否則找不到view的constraint，會crash
            vc.view.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            vc.view.backgroundColor = .clear
            vc.didMove(toParent: self)
        }
    }

    func presentUserDetailView(userData: RandomUser) {
        detailView?.isHidden = false
        detailView?.setData(userData: userData)
    }
    
    func loadData() {
        viewModel.input.load.send(viewModel.currentPage)
    }
    
    func updateSnapShot(items:[RandomUser]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, RandomUser>()
        snapshot.appendSections([0])
        
        items.forEach {
            snapshot.appendItems([$0], toSection: 0)
        }
        
        viewModel.tableViewDiffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    @objc func refreshAction(sender: UIRefreshControl) {
        sender.beginRefreshing()
        viewModel.input.refteshData.send(())
    }
}

//MARK: - Bind
private extension RandomUserListViewController {
    func bind() {
        viewModel.tableViewDiffableDataSource = UITableViewDiffableDataSource(tableView: contentView.tableView, cellProvider: {  tableView, indexPath, item in

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
                self.circleIndicator?.view.isHidden = true
                if self.contentView.refreshControl.isRefreshing {
                    self.contentView.refreshControl.endRefreshing()
                }
        }.store(in: &subscribers)
    }
}

extension RandomUserListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !viewModel.isLoading && indexPath.row == viewModel.randomUsers.count-1 {
            loadData()
            circleIndicator?.view.isHidden = false
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerHeight
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerSize = CGSize(width: tableView.frame.width, height: footerHeight)
        let footerView = UIView(frame: CGRect(origin: tableView.bounds.origin, size: footerSize))

        if let indicator = circleIndicator?.view {
            footerView.addSubview(indicator)
            indicator.center.x = footerView.center.x
            indicator.frame.origin.y = footerView.frame.height/2-indicator.frame.height/2
        }
        return footerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let data = viewModel.randomUsers[safe: indexPath.row] {
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.tapScaleAnmation { [weak self] in
                    guard let self = self else { return }
                    self.presentUserDetailView(userData: data)
                }
            }
        }
    }
}


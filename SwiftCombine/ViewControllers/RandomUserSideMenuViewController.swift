//
//  RandomUserSideMenuViewController.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2025/1/14.
//

import Combine
import UIKit

// MARK: - RandomUserSideMenuViewController

class RandomUserSideMenuViewController: UIViewController {
    //MARK: - Public Properties
    var selectedMenuItem: ((SideMenuModel)->Void)?
    // MARK: - Private Properties
    private let contentView = RandomUserSideMenuView()
    private let viewModel = RandomUserSideMenuViewModel()
    private var subscribers = [AnyCancellable]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        setupViews()
        bind()
    }
    
    func setMenuList(_ list:[SideMenuModel]) {
        viewModel.setMenu(menuList: list)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.load.send(())
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.input.sideMenuDisplayControl.send(true)
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

// MARK: - Bind

private extension RandomUserSideMenuViewController {
    func bind() {
        viewModel.output.didReveiveMenuDisplayControl.sink { [weak self] in
            guard let self = self else { return }
            self.contentView.setMenu(display: true)
        }.store(in: &subscribers)

        viewModel.output.didDismissSideMenu.sink { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: false)
        }.store(in: &subscribers)
        
        viewModel.output.didReceiveMenuList.sink { [weak self] list in
            guard let self = self else { return }
            self.updateSnapShot(items: list)
        }.store(in: &subscribers)
        
        viewModel.output.didSelectItem.sink { [weak self] item in
            guard let self = self else { return }
            self.selectedMenuItem?(item)
            self.viewModel.input.sideMenuDisplayControl.send(false)
        }.store(in: &subscribers)
    }
}

// MARK: - Private Methods

private extension RandomUserSideMenuViewController {
    func setupViews() {
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        contentView.tableView.delegate = self
        
        contentView.didEndDragView = { [weak self] in
            guard let self = self else { return }
            self.viewModel.input.sideMenuDisplayControl.send(false)
        }
        
        contentView.onAutoHideView = { [weak self] in
            guard let self = self else { return }
            self.viewModel.input.sideMenuDisplayControl.send(false)
        }
    
        viewModel.tableViewDiffableDataSource = UITableViewDiffableDataSource(tableView: contentView.tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = itemIdentifier.title
            cell.contentConfiguration = content
            return cell
        })
    }
    
    func updateSnapShot(items: [SideMenuModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, SideMenuModel>()
        snapshot.appendSections([0])

        items.forEach {
            snapshot.appendItems([$0], toSection: 0)
        }
        
        viewModel.tableViewDiffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension RandomUserSideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.input.selectedItem.send(indexPath.row)
    }
}

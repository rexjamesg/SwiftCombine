//
//  ChatRoomViewController.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2025/2/5.
//

import UIKit
import Combine

class ChatRoomViewController: BaseViewController {

    //MARK: - Private Properties
    private let contentView = ChatRoomView()
    private let viewModel = ChatRoomViewModel()
    private var subscribers = [AnyCancellable]()
    
    var timer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
            self.viewModel.input.load.send(())
        }
        timer?.fire()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
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

//MARK: - Bind
private extension ChatRoomViewController {
    func bind() {
        viewModel.tableViewDiffableDataSource = UITableViewDiffableDataSource(tableView: contentView.tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.transform = CGAffineTransform(scaleX: 1, y: -1)
            var content = cell.defaultContentConfiguration()
            content.text = itemIdentifier.name
            content.secondaryText = itemIdentifier.content
            cell.contentConfiguration = content
            return cell
        })
        
        viewModel.output.didReceivedChatItem.sink { [weak self] items in
            guard let self = self else { return }
            self.updateSnapShot(items: items)
        }.store(in: &subscribers)
    }
}

//MARK: - Private Methods
private extension ChatRoomViewController {
    func setupViews() {
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        setNavigationBarstyle(title: "Chat Room", titleColor: .white, backgroundColor: UIColor(named: "#0088CC"))
    }
    
    func updateSnapShot(items: [ChatItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ChatItem>()
        snapshot.appendSections([0])

        items.forEach {
            snapshot.appendItems([$0], toSection: 0)
        }
        
        viewModel.tableViewDiffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}

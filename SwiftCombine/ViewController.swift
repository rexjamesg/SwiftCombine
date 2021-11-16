//
//  ViewController.swift
//  SwiftCombine
//
//  Created by Rex Lin on 2021/10/8.
//

import UIKit
import Combine

struct Repositery: Codable {
    var id: Int
    var node_id: String
    var name: String
    var full_name: String
}

class ViewController: UIViewController {

    private var subscribers:[AnyCancellable] = []
    
    @Published
    private var list = [RandomUser]()
    
    private var tableView:UITableView = {
        let tableView = UITableView()
        let nib = UINib.init(nibName: "UserCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "UserCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        
        initBinding()
    }
    
    private func initBinding() {
        $list.receive(on: DispatchQueue.main)
            .sink { value in
                self.tableView.reloadData()
        }.store(in: &subscribers)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        DataHandler.shared.getAPI(apiDataModel: .randomUserList(page: 1, result: 100), dataType: RandmoUserList.self) { result in
            switch result {
            case .success(let data):
                self.list += data.results
                break
            case .failure(let error):
                print("error",error)
                break
            }
        }
    }
    
    func presentAlart(error:String) {
        
        let alertVC = UIAlertController.init(title: "Error", message: error, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "Confirm", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserCell else {
            fatalError()
        }
                        
        if list.count > indexPath.row {
            let randomUser = list[indexPath.row]
            cell.setData(randomUser: randomUser)
        }
        
        return cell
    }
    
}

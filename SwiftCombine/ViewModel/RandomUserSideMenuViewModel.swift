//
//  RandomUserSideMenuViewModel.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2025/2/3.
//

import Foundation
import Combine
import UIKit

class RandomUserSideMenuViewModel {
    //MARK: - Public Properties
    let input = Input()
    let output = Output()
    var tableViewDiffableDataSource: UITableViewDiffableDataSource<Int, SideMenuModel>?
    
    //MARK: - Private Properties
    private var subscribers = [AnyCancellable]()
    private(set) var menuList:[SideMenuModel] = []
    
    init() {
        bind()
    }
    
    func setMenu(menuList: [SideMenuModel]) {
        self.menuList = menuList
    }
}

//MARK: - Bind
private extension RandomUserSideMenuViewModel {
    func bind() {
        input.sideMenuDisplayControl.sink { [weak self] display in
            guard let self = self else { return }
            if display {
                self.output.didReveiveMenuDisplayControl.send(())
            } else {
                self.output.didDismissSideMenu.send(())
            }
        }.store(in: &subscribers)
        
        input.load.sink { [weak self] in
            guard let self = self else { return }
            self.output.didReceiveMenuList.send(self.menuList)
            
        }.store(in: &subscribers)
        
        input.selectedItem.sink { [weak self] index in
            guard let self = self else { return }
            let item = self.menuList[index]
            self.output.didSelectItem.send(item)
        }.store(in: &subscribers)
    }
}

extension RandomUserSideMenuViewModel {
    struct Input {
        let load: PassthroughSubject<Void, Never> = .init()
        let sideMenuDisplayControl: PassthroughSubject<Bool, Never> = .init()
        let selectedItem: PassthroughSubject<Int, Never> = .init()
    }
    
    struct Output {
        let didReveiveMenuDisplayControl: PassthroughSubject<Void, Never> = .init()
        let didDismissSideMenu: PassthroughSubject<Void, Never> = .init()
        let didReceiveMenuList: PassthroughSubject<[SideMenuModel], Never> = .init()
        let didSelectItem: PassthroughSubject<SideMenuModel, Never> = .init()
    }
}

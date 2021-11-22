//
//  RandomUserViewModel.swift
//  SwiftCombine
//
//  Created by Rex Lin on 2021/11/22.
//

import UIKit

class RandomUserViewModel: NSObject {

    @Published var list = [RandomUser]()
    
    override init() {
        super.init()
    }
    
    func getUserList(completeHandler:@escaping (_ error:String?)->Void) {
    
        DataHandler.shared.getAPI(apiDataModel: .randomUserList(page: 1, result: 100), dataType: RandmoUserList.self) { result in
            switch result {
            case .success(let data):
                self.list += data.results
                completeHandler(nil)
                break
            case .failure(let error):
                completeHandler(error.localizedDescription)
                break
            }
        }
    }
    
    func getRandomUser(index:Int) -> RandomUser? {
        if list.count > index {
            return list[index]
        }
        
        return nil
    }
}

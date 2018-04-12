//
//  TransactionRepo.swift
//  ledge
//
//  Created by robert on 3/28/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import Foundation
import PromiseKit

class TransactionRepo{
    let url = "http://10.10.111.121:8080"
    
    func postTransaction(transaction: Transaction) -> Promise<Int64>{
        return Promise{ seal in
            Alamofire
            .request("\(url)/transaction", method: .post, parameters: transaction.encodeToParameters(), encoding: JSONEncoding.default)
            .responseJSON()
            .done{ rsp in
                guard let json = rsp.json as? Int64 else{
                    return
                }
                seal.fulfill(json)
                debugPrint("Worked on server here is the id: \(json)." )
            }.catch{ error in
                seal.reject(error)
            }
        }
    }
}

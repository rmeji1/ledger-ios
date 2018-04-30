//
//  C8HLedgerRepository.swift
//  ledge
//
//  Created by robert on 4/11/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import Foundation
import PromiseKit
class C8HLedgerRepository{
  let url = "http://10.10.111.121:8080"

  func convertToLedger(_ json: Data)->Ledger?{
    do {
//      debugPrint(json)
      let jsonDecoder = JSONDecoder()
      let ledger = try jsonDecoder.decode(Ledger.self, from: json)
      debugPrint(ledger)
      return ledger
    }
    catch {
      debugPrint(error)
    }
    return nil
  }
  
  func createLedger(ledger: Ledger) -> Promise<Ledger?>?{
    let encoder = JSONEncoder()
    guard
      let jsonData = try? encoder.encode(ledger),
      let ledgerURL = URL(string:"\(url)/ledger") else{
      return nil
    }
    
    var request = URLRequest(url: ledgerURL)
    request.httpMethod = HTTPMethod.post.rawValue
    request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData
    
    return Alamofire.request(request).responseData().map{data, rsp in
        self.convertToLedger(data)
    }
//    this method below works.
//    return Alamofire
//      .request("\(url)/ledger", method: .post,
//               parameters: ledger.encodeToParameters(), encoding: JSONEncoding.default)
//      .responseData()
//      .map{ data, rsp in
//        self.convertToLedger(data)
//      }
  }
}

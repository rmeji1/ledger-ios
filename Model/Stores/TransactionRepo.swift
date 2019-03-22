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
//    let url = "http://192.168.0.17:8080"
  
  enum LedgerInfoPlistError : Error {
    case invalidURL
  }
  
  func getInfoDictionary() -> [String: AnyObject]? {
    guard let infoDictPath = Bundle.main.path(forResource: "Info", ofType: "plist") else { return nil }
    return NSDictionary(contentsOfFile: infoDictPath) as? [String : AnyObject]
  }
  
  
    func postTransaction(transaction: Transaction) -> Promise<Ledger?>{
      guard let serverURL = getInfoDictionary()?["MainServer"] else { return Promise(error: LedgerInfoPlistError.invalidURL) }

      let urlString = "\(serverURL)/transaction/"
      let jsonData = try? JSONEncoder().encode(transaction)
      let url = URL(string: urlString)!
//      //    let jsonData = json.data(using: .utf8, allowLossyConversion: false)
//
      var request = URLRequest(url: url)
      request.httpMethod = HTTPMethod.post.rawValue
      request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
      request.httpBody = jsonData
      return Alamofire.request(request).responseData().compactMap{ data, resp in
        return try JSONDecoder().decode(Ledger.self, from: data)
      }
  }
}

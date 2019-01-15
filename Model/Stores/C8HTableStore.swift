//
//  C8HTableStore.swift
//  ledge
//
//  Created by robert on 5/1/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import Foundation
import PromiseKit
import OktaAuth


class C8HTableDetailStore: DataStoreProtocol{
  typealias T = TableNew
  
  func findAllBy(casinoId: UInt) -> Promise<[TableNew]?>{
    guard let address = address else { return  Promise(error: DataStoreProtocolError.invalidURL) }
    guard let accessToken = accessToken else { return  Promise(error: DataStoreProtocolError.invalidAccessToken) }
    
    let headers: HTTPHeaders = [ "Authorization": "Bearer \(accessToken)"]
    return Alamofire
            .request("\(address)/tables/\(casinoId)", method : .get, headers: headers)
            .responseData().compactMap{ data, rsp in
              try JSONDecoder().decode([TableNew].self, from: data)
          }
  }
  
  func save(_ entity: TableNew) -> Promise<UInt64?> {
    guard let address = address else { return  Promise(error: DataStoreProtocolError.invalidURL) }
    guard let accessToken = accessToken else { return  Promise(error: DataStoreProtocolError.invalidAccessToken) }
  
    let jsonData = try? JSONEncoder().encode(entity)
    let url = URL(string: address)!
    
    var request = URLRequest(url: url)
    request.httpMethod = HTTPMethod.put.rawValue
    request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData
    
    return Alamofire.request(request).responseString().compactMap{ data, resp in
      return UInt64(data)
    }
  }
}


//enum TableStoreError : Error{
//  case UpdateTableError
//}

//class C8HTableDetailStore{
//  enum C8HTableDetailStoreError : Error {
//    case invalidURL
//  }
//
//  func getInfoDictionary() -> [String: AnyObject]? {
//    guard let infoDictPath = Bundle.main.path(forResource: "Info", ofType: "plist") else { return nil }
//    return NSDictionary(contentsOfFile: infoDictPath) as? [String : AnyObject]
//  }
//
//  func findTables(forCasino casinoId: Int64)->Promise<[TableNew]?>{
//    let casinoIdNew  = 1
//    guard let urlNew = getInfoDictionary()?["MainServer"] else { return Promise(error: C8HTableDetailStoreError.invalidURL) }
//    guard let accessToken = OktaAuth.tokens?.accessToken else {return Promise(error: OktaAuth.OktaError.NoBearerToken)}
//
//    let headers: HTTPHeaders = [ "Authorization": "Bearer \(accessToken)"]
//
//    return Alamofire
//      .request("\(urlNew)/tables/\(casinoIdNew)", method : .get, headers: headers)
//      .responseData()
//      .compactMap{ data, rsp in
//        try JSONDecoder().decode([TableNew].self, from: data)
//    }
//  }
//
//  //_  = self.tableStore.save(table: &self.tableDetails!)
//  /// Saves the table details when they are edited.
//  func save(table :  TableNew) -> Promise<Int64?>{
//    guard let urlNew = getInfoDictionary()?["MainServer"] else { return Promise(error: C8HTableDetailStoreError.invalidURL) }
//    let urlString = "\(urlNew)/tables/\(table.id)"
//    debugPrint(urlString)
//    let jsonData = try? JSONEncoder().encode(table)
//
//    let url = URL(string: urlString)!
////    let jsonData = json.data(using: .utf8, allowLossyConversion: false)
//
//    var request = URLRequest(url: url)
//    request.httpMethod = HTTPMethod.put.rawValue
//    request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
//    request.httpBody = jsonData
//    return Alamofire.request(request).responseString().compactMap{ data, resp in
//      return Int64(data)
//    }
//  }
//}

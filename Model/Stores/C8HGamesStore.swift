//
//  C8HGamesStore.swift
//  ledge
//
//  Created by robert on 4/27/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import Foundation
import PromiseKit
import OktaAuth

class C8HGameStore{
  enum LedgerInfoPlistError : Error {
    case invalidURL
  }
  
  func getInfoDictionary() -> [String: AnyObject]? {
    guard let infoDictPath = Bundle.main.path(forResource: "Info", ofType: "plist") else { return nil }
    return NSDictionary(contentsOfFile: infoDictPath) as? [String : AnyObject]
  }
  
  func save(game : Game) -> Promise<Int64>{
    guard let serverURL = getInfoDictionary()?["MainServer"] else { return Promise(error: LedgerInfoPlistError.invalidURL) }
    guard let accessToken = OktaAuth.tokens?.accessToken else {return Promise(error: OktaAuth.OktaError.NoBearerToken)}
    

    let jsonData = try? JSONEncoder().encode(game)
    
    let urlString = "\(serverURL)/games/"
    let url = URL(string: urlString)!
    
    var request = URLRequest(url: url)
    request.httpMethod = HTTPMethod.post.rawValue
    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData
    
    return Alamofire.request(request).responseString().compactMap{ data, rsp in Int64(data) }
  }
  
  func findGames(forCasino casino: Int64) -> Promise<[Game]>{
    guard let url = getInfoDictionary()?["MainServer"] else { return Promise(error: LedgerInfoPlistError.invalidURL) }
    guard let accessToken = OktaAuth.tokens?.accessToken else {return Promise(error: OktaAuth.OktaError.NoBearerToken)}
    
    let headers: HTTPHeaders = [ "Authorization": "Bearer \(accessToken)"]
    
    return Alamofire
      .request("\(url)/games/\(casino)", method: .get, headers: headers)
      .responseData()
      .compactMap{ data, rsp in
       try JSONDecoder().decode([Game].self, from: data)
    }
  }
}

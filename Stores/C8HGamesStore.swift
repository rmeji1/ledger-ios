//
//  C8HGamesStore.swift
//  ledge
//
//  Created by robert on 4/27/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import Foundation
import PromiseKit

class C8HGameStore{
  enum LedgerInfoPlistError : Error {
    case invalidURL
  }
  
  func getInfoDictionary() -> [String: AnyObject]? {
    guard let infoDictPath = Bundle.main.path(forResource: "Info", ofType: "plist") else { return nil }
    return NSDictionary(contentsOfFile: infoDictPath) as? [String : AnyObject]
  }
  
  func findGames(forCasino casino: Int64) -> Promise<[Game]>{
    guard let url = getInfoDictionary()?["MainServer"] else { return Promise(error: LedgerInfoPlistError.invalidURL) }

    return Alamofire
      .request("\(url)/games/\(casino)", method: .get)
      .responseData()
      .compactMap{ data, rsp in
       try JSONDecoder().decode([Game].self, from: data)
    }
  }
}

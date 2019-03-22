//
//  C8HLedgerStore.swift
//  ledge
//
//  Created by robert on 5/1/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import Foundation
import PromiseKit
import OktaAuth

class C8HLedgerStore{
  let title = "C8HLedgerStore"
  enum LedgerInfoPlistError : Error {
    case invalidURL
  }
  
  enum LedgerStore : Error {
    case invalidImage
  }
  
  func getInfoDictionary() -> [String: AnyObject]? {
    guard let infoDictPath = Bundle.main.path(forResource: "Info", ofType: "plist") else { return nil }
    return NSDictionary(contentsOfFile: infoDictPath) as? [String : AnyObject]
  }
  
  func save(ledger: Ledger) -> Promise<Int64>{
    guard let serverURL = getInfoDictionary()?["MainServer"] else { return Promise(error: LedgerInfoPlistError.invalidURL) }
    guard let accessToken = OktaAuth.tokens?.accessToken else {return Promise(error: OktaAuth.OktaError.NoBearerToken)}
    
    let jsonData = try? JSONEncoder().encode(ledger)
    
    let urlString = "\(serverURL)/ledger/"
    let url = URL(string: urlString)!
    
    var request = URLRequest(url: url)
    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    request.httpMethod = HTTPMethod.post.rawValue
    request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData
    
    return Alamofire.request(request).responseString().compactMap{ data, rsp in Int64(data) }
  }
  
  func saveEmployeeSignature(image: UIImage, ledgerId : Int64, isManager: Bool) -> Promise<Bool>{
    guard let serverURL = getInfoDictionary()?["MainServer"] else { return Promise(error: LedgerInfoPlistError.invalidURL) }
    guard let accessToken = OktaAuth.tokens?.accessToken else {return Promise(error: OktaAuth.OktaError.NoBearerToken)}
    
    let headers: HTTPHeaders = [ "Authorization": "Bearer \(accessToken)"]
    let urlString : String
    
    if isManager {
      urlString = "\(serverURL)/ledger/man/\(ledgerId)"
    }else{
      urlString = "\(serverURL)/ledger/emp/\(ledgerId)"
    }
    
    return Promise{ seal in
      guard let imageData = image.pngData() else {
        throw LedgerStore.invalidImage
      }
      
      Alamofire.upload( multipartFormData: { multipartFormData in
          multipartFormData.append(imageData, withName: "file", fileName: "file",
                                   mimeType: "image/png")
      }, to: urlString, method: .put, headers: headers, encodingCompletion: {
          encodingResult in
          switch encodingResult {
          case .success(let upload, _, _):
            upload.responseJSON { debugPrint($0) }
            seal.fulfill(true)
          case .failure(let encodingError):
            debugPrint(encodingError)
            seal.reject(encodingError)
          }
      })
    }
  }
  
  func pushLedger(ledger: Ledger) -> Promise<Ledger?>{
    guard let serverURL = getInfoDictionary()?["MainServer"] else { return Promise(error: LedgerInfoPlistError.invalidURL) }
    guard let accessToken = OktaAuth.tokens?.accessToken else {return Promise(error: OktaAuth.OktaError.NoBearerToken)}
    
    let headers: HTTPHeaders = [ "Authorization": "Bearer \(accessToken)"]
    let urlString = "\(serverURL)/ledger/\(ledger.id!)"
    
    return Alamofire
      .request(urlString, method: .put, parameters: ["endingBalance":"100.23"], headers: headers).responseData().compactMap{ data, rsp in
        return try JSONDecoder().decode(Ledger.self, from: data)
    }
  }
  
  func getActiveLedgers(for casino: Int64) -> Promise<[Ledger]>{
    guard let serverURL = getInfoDictionary()?["MainServer"] else { return Promise(error: LedgerInfoPlistError.invalidURL) }
    guard let accessToken = OktaAuth.tokens?.accessToken else {return Promise(error: OktaAuth.OktaError.NoBearerToken)}
    
    let headers: HTTPHeaders = [ "Authorization": "Bearer \(accessToken)"]
    let urlString = "\(serverURL)/ledger/active/\(casino)"
    
    return Alamofire
      .request(urlString, method: .get, headers: headers).responseData().compactMap{ data, rsp in
        return try! JSONDecoder().decode([Ledger].self, from: data)
    }
  }
  
  /// FIXME:- Don't know what this does.
  func updateTransaction(ledger: Ledger) -> Promise<Void>{
    return Promise{ _ in
      
    }
  }
}

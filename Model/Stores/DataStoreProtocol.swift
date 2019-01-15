//
//  DataStoreProtocol.swift
//  ledger
//
//  Created by robert on 10/18/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import Foundation
import PromiseKit
import OktaAuth

enum DataStoreProtocolError:Error {
  case invalidURL
  case invalidAccessToken
  case methodNotImplemented
  case unableToSave
}

protocol DataStoreProtocol{
  associatedtype T
  var address : String? { get }
  var accessToken : String? { get }
  
  func findAll() -> Promise<[T]?>
  func findById() -> Promise<T>
  func count() -> Promise<UInt64>
  func save(_ entity: T) -> Promise<UInt64?>
  func getInfoDictionary() -> [String: AnyObject]?
  
}

extension DataStoreProtocol{
  var address : String?{
    get{ return getInfoDictionary()?["MainServer"] as? String }
  }
  
  var accessToken : String?{
    get{ return OktaAuth.tokens?.accessToken }
  }
  
  func getInfoDictionary() -> [String: AnyObject]? {
    guard let infoDictPath = Bundle.main.path(forResource: "Info", ofType: "plist") else { return nil }
    return NSDictionary(contentsOfFile: infoDictPath) as? [String : AnyObject]
  }
  
  func findAll() -> Promise<[T]?> {
    return Promise<[T]?>{
      $0.reject(DataStoreProtocolError.methodNotImplemented)
    }
  }
  
  func findById() -> Promise<T>{
    return Promise<T> {
      $0.reject(DataStoreProtocolError.methodNotImplemented)
    }
  }
  
  func count() -> Promise<UInt64> {
    return Promise<UInt64> {
      $0.reject(DataStoreProtocolError.methodNotImplemented)
    }
  }
  
  func save(_ entity: T) -> Promise<UInt64>{
    return Promise<UInt64>{
      $0.reject(DataStoreProtocolError.methodNotImplemented)
    }
  }
}

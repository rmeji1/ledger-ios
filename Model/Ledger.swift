//
//  Ledger.swift
//  ledge
//
//  Created by robert on 2/9/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import Foundation
import Alamofire

struct CasinoDetails: Codable{
  let casinoName : String
}
struct EmpDetails: Codable{
  let badgeNumber : String
  let name : String
}
struct TableDetails: Codable{
  var gega: String
  var gameTable: String
  var beginningBalance: Decimal?
  var endingBalance: Decimal?
  var additionsTotal: Decimal?
  var subtractionTotals: Decimal?
  
  init(gega: String, gameTable: String, beginningBalance: Decimal){
    self.gega = gega
    self.gameTable = gameTable
    self.beginningBalance = beginningBalance
  }
}

struct LedgerDate: Codable{
  var startDateTime : [String:String?]
  var endDateTime : [String:String?]?
}
struct Ledger: Codable{
  var casinoDetails : CasinoDetails
  var empDetails : EmpDetails
  var tableDetails: TableDetails
  var ledgerDate : LedgerDate
  var active : Bool
//  var additions: [Double]
  
  init(){
    casinoDetails = CasinoDetails(casinoName: "")
    empDetails = EmpDetails(badgeNumber:"", name: "")
    tableDetails = TableDetails(gega:"",gameTable:"", beginningBalance: 0)
    ledgerDate = LedgerDate(startDateTime:[:], endDateTime: nil)
    active = true
//    additions = [0]
  }
  func encodeToParameters()->Parameters{
//    FIXME: - Need to change this.
    let parameters : Parameters = [
      "casinoDetails" : [ "casinoName" : casinoDetails.casinoName],
      "empDetails" : empDetails,
      "tableDetails" : tableDetails,
      "active" : active
    ]
    return parameters
  }
}

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
  let casinoId: Int64
  let casinoName : String
  let casinoImageURL : String
}
struct EmpDetails: Codable{
  let badgeNumber : String
  let name : String
}
struct TableDetails: Codable{
  var gega: GegaDetails
  var table: Int
  var game: GameDetails
  var beginningBalance: Decimal?
  var endingBalance: Decimal?
  var additionsTotal: Decimal?
  var subtractionTotals: Decimal?
  
  init(gega: GegaDetails, game: GameDetails, beginningBalance: Decimal, table: Int){
    self.gega = gega
    self.game = game
    self.beginningBalance = beginningBalance
    self.table = table
  }
}

struct GameDetails: Codable{
  var id : Int
  var description: String
}

struct GegaDetails: Codable{
  var id : Int
  var description: String
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
    casinoDetails = CasinoDetails(casinoId: 0, casinoName: "", casinoImageURL: "")
    empDetails = EmpDetails(badgeNumber:"", name: "")
    
    let gegaDetails = GegaDetails(id: 0, description: "GEGA1234")
    let gameDetails = GameDetails(id: 0, description: "Black Jack")
    tableDetails = TableDetails(gega:gegaDetails,game: gameDetails, beginningBalance: 0, table: 0)
    
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

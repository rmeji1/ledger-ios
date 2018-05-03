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
  var id: Int64
  var game: GameDetails
  var beginningBalance: Decimal?
  var endingBalance: Decimal?
  var additionsTotal: Decimal?
  var subtractionTotals: Decimal?
  
  init(gega: GegaDetails, game: GameDetails, beginningBalance: Decimal, id: Int64){
    self.gega = gega
    self.game = game
    self.beginningBalance = beginningBalance
    self.id = id
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



struct Transaction: Codable{
  enum Transaction_Type : String,Codable {
    case ADDITION
    case SUBTRACTION
  }
  
  var type : Transaction_Type
  var managerInitals : String
  var employeeInitals : String
  var amount : Decimal
}

class Ledger: Codable{
  var casinoDetails : CasinoDetails
  var empDetails : EmpDetails?
  var tableDetails: TableDetails?
  var ledgerDate : LedgerDate?
  var active : Bool
  var transactions: [Transaction]?
  
  init(casinoDetails: CasinoDetails, empDetails: EmpDetails?,tableDetails: TableDetails?,
      ledgerDate: LedgerDate?, active: Bool, transactions: [Transaction]?){
    
    self.casinoDetails = casinoDetails
    self.empDetails = empDetails
    self.tableDetails = tableDetails
    self.ledgerDate = ledgerDate
    self.active = active
    self.transactions = transactions
  }
  
  func append(_ trans : Transaction){
    if transactions == nil{
      transactions = []
    }
    
    transactions?.append(trans)
    switch trans.type {
    case .ADDITION:
      if tableDetails?.additionsTotal == nil {
        tableDetails?.additionsTotal = trans.amount
      }else{
        tableDetails?.additionsTotal! += trans.amount
        print("Amount\(tableDetails?.additionsTotal!)")
      }
    case .SUBTRACTION:
      if tableDetails?.subtractionTotals == nil {
        tableDetails?.subtractionTotals = trans.amount
      }else{
        tableDetails?.subtractionTotals! += trans.amount
        print("Amount\(tableDetails?.subtractionTotals!)")

      }
    }
    
  }
  
//  init(){
//    casinoDetails = CasinoDetails(casinoId: 0, casinoName: "", casinoImageURL: "")
//    empDetails = EmpDetails(badgeNumber:"", name: "")
//    
//    let gegaDetails = GegaDetails(id: 0, description: "GEGA1234")
//    let gameDetails = GameDetails(id: 0, description: "Black Jack")
//    tableDetails = TableDetails(gega:gegaDetails,game: gameDetails, beginningBalance: 0, id: 0)
//    
//    ledgerDate = LedgerDate(startDateTime:[:], endDateTime: nil)
//    active = true
////    additions = [0]
//  }

}

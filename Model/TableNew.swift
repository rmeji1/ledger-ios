//
//  TableNew.swift
//  ledge
//
//  Created by robert on 5/18/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import Foundation

struct Balance : Codable{
  var forGame : String
  var balance : Decimal
}

enum TableError:Error {
  case invalidId
}
struct TableNew : Codable{
  var id : Int64
  var number : Int
  var games : [Game]
  var balance : Decimal
  var open : Bool
  var activeGames : Int
  
  var balances : [String : Decimal]{
    didSet {
      print("The value of myProperty changed from \(oldValue) to \(balances)")
    }
  }
  
//  var newBalances : [Balance]
}

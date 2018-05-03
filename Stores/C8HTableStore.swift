//
//  C8HTableStore.swift
//  ledge
//
//  Created by robert on 5/1/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import Foundation
import PromiseKit

class C8HTableDetailStore{
  
  func find(forCasino casinoId: Int64)->Promise<[TableDetails]>{
    return Promise{seal in
      var tables : [TableDetails] = []
      for number in 1...100{
        let gegaDetails = GegaDetails(id: number, description: "GEGA1234")
        let gameDetails = GameDetails(id: 3, description: "Roulette")
        
        tables.append(TableDetails(gega:gegaDetails, game: gameDetails, beginningBalance: 0, id: Int64(number)))
      }
      seal.fulfill(tables)
    }
  }
  
  //_  = self.tableStore.save(table: &self.tableDetails!)
  /// Saves the table details when they are edited.
  func save(table : inout TableDetails) -> Promise<Int64>{
    return Promise{
      seal in
      debugPrint("Table is being saved.")
      table.id = Int64(200)
      seal.fulfill(table.id)
    }
  }
}

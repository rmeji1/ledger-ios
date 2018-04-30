//
//  File.swift
//  ledge
//
//  Created by robert on 3/5/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import CoreData

struct C8HTableRepository{
  let url = "http://10.10.111.121:8080"
  let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  func findTables(forCasino casinoId: Int64)->Promise<[TableDetails]>{
    return Promise{seal in
      var tables : [TableDetails] = []
      for number in 1...100{
        let gegaDetails = GegaDetails(id: number, description: "GEGA1234")
        let gameDetails = GameDetails(id: 3, description: "Roulette")

        tables.append(TableDetails(gega:gegaDetails, game: gameDetails, beginningBalance: 0, table: number))
      }
    seal.fulfill(tables)
    }
  }

  
  func findTablesWithCasinoId(casinoId: Int64) -> Promise<[C8HTable]>{
    return Promise{ seal in
      Alamofire.request("\(url)/tables/\(casinoId)").validate().responseJSON()
        .done{ response in
          var tables : [C8HTable] = []
          debugPrint(response.json)
          guard let json = response.json as? [Any] else{
            throw TableRepositoryError.UnableToParseJsonFromServerToDict
          }
          for item in json{
            guard let dict = item as? [String:Any] else{
              throw TableRepositoryError.UnableToParseJsonFromServerToDict
            }
            let table = try C8HTable(dict:dict, context:self.managedObjectContext)
            tables.append(table)
          }
          seal.fulfill(tables)
        }.catch{error in
          seal.reject(error)
      }
    }
  }
}

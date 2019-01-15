//
//  GegaStore.swift
//  ledge
//
//  Created by robert on 4/25/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import Foundation
import PromiseKit

class C8HGegaStore{
  
  func findGegas(forCasino: Int64) -> Promise<[GegaDetails]>{
    return Promise{seal in
      var gegas: [GegaDetails] = []
      for id in 1...100{
        gegas.append(GegaDetails(id: id, description: "GEGA000\(id)"))
      }
      seal.fulfill(gegas)
    }
  }
}

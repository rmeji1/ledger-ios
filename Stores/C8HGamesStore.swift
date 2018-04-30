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
  func findGames(forCasino: Int64) -> Promise<[GameDetails]>{
    return Promise{seal in
      var games: [GameDetails] = []
      for id in 1...10{
        if id != 3{
          games.append(GameDetails(id: id, description: "Black Jack"))
        }
        else{
          games.append(GameDetails(id: id, description: "Roulette"))

        }
      }
      seal.fulfill(games)
    }
  }
}

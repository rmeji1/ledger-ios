//
//  Game.swift
//  ledge
//
//  Created by robert on 5/18/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import Foundation

struct Game : Codable {
  var id : UInt64?
  var description : String
  var gega : String
  
  // Need to see if this will cause an error.
  var casinoId : Int64
}

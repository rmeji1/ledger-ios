//
//  Ledger.swift
//  ledge
//
//  Created by robert on 2/9/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import Foundation

struct Ledger: Encodable{
    var gega: String
    var gtNumber: Int
    var beginningBalance: Double
    var endingBalance: Double
    var additions: [Double]
}

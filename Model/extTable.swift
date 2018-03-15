//
//  extTable.swift
//  ledge
//
//  Created by robert on 3/7/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import Foundation
import CoreData

enum TableRepositoryError : Error{
    case UnableToParseJsonFromServerToDict
    case UnableToParseJson
}
extension C8HTable{
    convenience init(dict: [String: Any], context: NSManagedObjectContext) throws{
        self.init(context: context)
        guard let casinoId = dict["casinoId"] as? Int64,
            let gameDesc = dict["gameDesc"] as? String?,
            let gega = dict["gega"] as? String,
            let id = dict["id"] as? Int64,
            let tableNumber = dict["tableNumber"] as? Int32,
            let podium = dict["podium"] as? Float
            else{
                throw TableRepositoryError.UnableToParseJson
        }
        self.casinoId = casinoId
        self.gameDesc = gameDesc
        self.gega = gega
        self.id = id
        self.tableNumber = tableNumber
        self.podium = NSDecimalNumber(value: podium)
    }
}

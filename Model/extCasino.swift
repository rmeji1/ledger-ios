////
////  extCasino.swift
////  ledge
////
////  Created by robert on 3/24/18.
////  Copyright © 2018 com.cre8ivehouse. All rights reserved.
////
//
//import Foundation
//import CoreData
//
//extension C8HCasino : Encodable{
//    enum CodingKeys: String, CodingKey {
//        //        case id = "id"
//        case identifer = "name"
//        case longitude = "longitude"
//        case latitude = "latitude"
//        case balance = "podium"
//    }
//
//    convenience init(dict: [String: Any], context: NSManagedObjectContext) throws{
//        self.init(context: context)
//        
//        guard
//            let id = dict["id"] as? Int64,
//            let identifer = dict["name"] as? String,
//            let latitude = dict["latitude"] as? Float,
//            let longitude = dict["longitude"] as? Float
//            else{
//                throw C8HCasinoRepositoryError.ParsingJson
//        }
//        
//        self.id = id
//        self.identifer = identifer
//        self.longitude = longitude
//        self.latitude = latitude
//    }
//    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(latitude, forKey: .latitude)
//        try container.encode(longitude, forKey: .longitude)
//        try container.encode(identifer, forKey: .identifer)
//        try container.encode(balance! as Decimal, forKey: .balance)
////        try container.encode(pod)
////        var additionalInfo = container.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .additionalInfo)
////        try additionalInfo.encode(elevation, forKey: .elevation)
//    }
//}

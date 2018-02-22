//
//  Casino.swift
//  ledge
//
//  Created by robert on 1/15/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//
import CoreLocation

struct C8HCasino: Codable{
    enum CodingKeys : String, CodingKey {
        case id = "id"
        case identifer = "name"
        case longitude = "longitude"
        case latitude = "latitude"
    }
    
    var id: Int
    var latitude: Float
    var longitude: Float
    var identifer: String
}


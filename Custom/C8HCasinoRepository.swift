//
//  C8HCasinoRepository.swift
//  ledge
//
//  Created by robert on 2/20/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import Foundation
import Alamofire

struct C8HCasinoRepository{
    let url = "http://10.10.110.8:8080"
    weak var delegate: C8HLoginVC?

//    ==========================================================================
//    Initializer
    init(){}
    
    func getAllCasinos() -> [C8HCasino]{
        var casino: [C8HCasino] = []
        Alamofire.request(url + "/casinos")
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                    print(utf8Text)
                    let jsonData = utf8Text.data(using: .utf8)
                    do {
                        let decoder = JSONDecoder()
                        casino = try decoder.decode([C8HCasino].self, from: jsonData!)
                    }catch let error{
                        print("Printing Error: \(error)")
                    }
                    
                }
                print("Casinos \(casino)")
        }
        print("Casinos \(casino)")
        return casino
    }
}

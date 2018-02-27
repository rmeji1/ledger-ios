//
//  C8HCasinoRepository.swift
//  ledge
//
//  Created by robert on 2/20/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

struct C8HCasinoRepository{
    let url = "http://10.10.111.121:8080"
    weak var delegate: C8HGeoRegionManager?
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    ==========================================================================
//    Initializer
    init(){}
    
    func getAllCasinos(){
        Alamofire.request(url + "/casinos")
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                if let casinos = response.result.value as? [Any] {
                    print("JSON: \(casinos)")
                    for casino in casinos{
                        do{
                            try self.insertCasinoIntoCoreData(serverCasino: casino as! [String: Any])
                            debugPrint((casino as! [String: Any]))
                        }catch{
                            fatalError("Error getting casinos from server")
                        }
                    }
                }
        }
    }
    
//  Insert into core data
    func insertCasinoIntoCoreData(serverCasino: [String: Any]) throws{
        let casino = NSEntityDescription.insertNewObject(forEntityName: "Casino", into: managedObjectContext) as! C8HCasino
        casino.id = serverCasino["id"] as! Int64
        casino.identifer = serverCasino["name"] as! String
        casino.latitude = serverCasino["latitude"] as! Float
        casino.longitude = serverCasino["longitude"] as! Float
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func getCasinos(){
        getCasinosCount { (serverCount, error) -> () in
            let casinoFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Casino")
            do{
                let casinoCount = try self.managedObjectContext.count(for: casinoFetch)
                switch casinoCount {
                case 0:
                    // Get casinos from server and insert into core data
                    debugPrint("Casino count is 0. Calling server to get Casinos")
                    self.getAllCasinos()
                case serverCount!:
                    debugPrint("Casinos in server and in coredata match")
                    self.delegate?.setRegions()
                default:
                    break
                }
            }catch{
                fatalError("Failed trying to see how many casinos saved: \(error)")
            }
        }
    }
    
    func deleteAllCasinos() throws{
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Casino")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        try managedObjectContext.execute(request)
    }
    
    func getCasinosCount(completionHandler: @escaping (Int?, Error?) -> () ){
        Alamofire.request(url+"/casinos/count")
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    completionHandler(value as? Int, nil)
                case .failure(let error):
                    completionHandler(nil, error)
                }
        }
    }
}

// Find in which casino the person is in
//

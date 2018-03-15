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
import PromiseKit

enum C8HCasinoError : Error{
    case errorFromCD // Error from coredata
    case errorDataSync
}

struct C8HCasinoRepository{
    let url = "http://192.168.1.17:8080"
    weak var delegate: C8HGeoRegionManager?
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//  ============================================================================
//    Initializer
    init(){}
    
//  ============================================================================
//    Param: User current location
//    Return: tries to return a casino object.
    func findInWhichCasino(loc: CLLocation)->Promise<C8HCasino>{
        try! self.deleteAllCasinos()
        return Promise{ seal in
            let find = self.findInWhichCasinoFromCoreData
//            var request = URLRequest(url: NSURL.init(string: "\(url)/casinos/count") as! URL)
//            request.httpMethod = "GET"
////            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.timeoutInterval = 5 // 5 secs
            Alamofire.request("\(url)/casinos/count").validate().responseJSON()
                .done{ response in
                    // ServerCount == localCount
                    if (response.json as? Int)! != self.fetchLocalCount() {
                       try self.deleteAllCasinos()
                      self.getAllCasinosAndSave(seal, loc: loc)
                    }else{
                        try seal.fulfill(find(loc))
                    }
                }.recover{ error in
                    if error is URLError  {
                        seal.fulfill(try find(loc))
                    }
                    throw error
                }.catch{error in
                    seal.reject(error)
            }
            
        }
    }
    
    private func findInWhichCasinoFromCoreData(loc: CLLocation) throws -> C8HCasino{
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let casinoFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Casino")
        do {
            let fetchedCasinos = try moc.fetch(casinoFetch) as! [C8HCasino]
            for casino in fetchedCasinos {
                let center = CLLocationCoordinate2D(latitude: CLLocationDegrees(casino.latitude),
                                                    longitude: CLLocationDegrees(casino.longitude))
                let region = CLCircularRegion(center: center, radius: 100.5, identifier: casino.identifer!)
                if region.contains(loc.coordinate){
                    return casino
                }
            }
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        throw C8HCasinoError.errorFromCD
    }
    
//  ============================================================================
//    Fetch the coint of entity:casino from core data.
    func fetchLocalCount() -> Int{
        let casinoFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Casino")
        do{
            return try self.managedObjectContext.count(for: casinoFetch)
        }catch{
            debugPrint("Failed trying to see how many casinos saved: \(error)")
            return 0
        }
    }

    func getAllCasinosAndSave(_ seal: Resolver<C8HCasino>, loc: CLLocation){
        Alamofire.request("\(url)/casinos").validate().responseJSON()
            .done{ response in
                if let casinos = response.json as? [Any] {
                    print("JSON: \(casinos)")
                    for casino in casinos{
                        do{
                            try self.insertCasinoIntoCoreData(serverCasino: casino as! [String: Any])
                            debugPrint((casino as! [String: Any]))
                        }catch{
                            fatalError("Error getting casinos from server")
                        }
                    }
                    seal.fulfill(try self.findInWhichCasinoFromCoreData(loc: loc))
                }
                }.catch{ error in
                    debugPrint(error)
                    seal.reject(error)
                }
    }
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
        // need to use guard statement for this.
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
    
    func deleteAllCasinos() throws{
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Casino")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        try managedObjectContext.execute(request)
    }
    
// no longer using this
//    func getCasinos(){
//        getCasinosCount { (serverCount, error) -> () in
//            let casinoFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Casino")
//            do{
//                let casinoCount = try self.managedObjectContext.count(for: casinoFetch)
//                switch casinoCount {
//                case 0:
//                    // Get casinos from server and insert into core data
//                    debugPrint("Casino count is 0. Calling server to get Casinos")
//                    self.getAllCasinos()
//                case serverCount!:
//                    debugPrint("Casinos in server and in coredata match")
//                    self.delegate?.setRegions()
//                default:
//                    break
//                }
//            }catch{
//                fatalError("Failed trying to see how many casinos saved: \(error)")
//            }
//        }
//    }
    
    // No longer using
//    func getCasinosCount(completionHandler: @escaping (Int?, Error?) -> () ){
//        Alamofire.request("\(url)/casinos/count")
//            .validate(contentType: ["application/json"])
//            .responseJSON { response in
//                switch response.result {
//                case .success(let value):
//                    completionHandler(value as? Int, nil)
//                case .failure(let error):
//                    completionHandler(nil, error)
//                }
//        }
//    }
}

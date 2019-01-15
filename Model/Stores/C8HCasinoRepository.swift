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
import OktaAuth

enum C8HCasinoRepositoryError : Error {
  case invalidURL
  case casinoNotValid
  case UnableToParseJsonFromServerToDict
  case ParsingJson
  case errorFromCD // Error from coredata
  case errorDataSync
}

class C8HCasinoRepository{
  weak var delegate: C8HGeoRegionManager?
  var casinosCache: [Casino]?
  
  func getInfoDictionary() -> [String: AnyObject]? {
    guard let infoDictPath = Bundle.main.path(forResource: "Info", ofType: "plist") else { return nil }
    return NSDictionary(contentsOfFile: infoDictPath) as? [String : AnyObject]
  }
  
  /**
    Retrieves a list of casinos from resource server.
   
   - parameter loc: users current location
   
   - returns: A promise of the casino user is within region of.
   */
  func getAllCasinosAndFind( loc: CLLocationCoordinate2D ) -> Promise<Casino?>{
    guard let urlNew = getInfoDictionary()?["MainServer"] else
      { return Promise(error: C8HCasinoRepositoryError.invalidURL) }
    guard let accessToken = OktaAuth.tokens?.accessToken else
      {return Promise(error: OktaAuth.OktaError.NoBearerToken)}
    
    let headers: HTTPHeaders = [ "Authorization": "Bearer \(accessToken)" ]
    
    return Alamofire
      .request("\(urlNew)/casinos", method : .get, headers: headers)
      .validate(statusCode: 200...200).responseData()
      .compactMap{ try JSONDecoder().decode([Casino].self, from: $0.data) }
      .compactMap{ casinos in
        var returnValue : Casino? = nil
        
        // Scan casinos regions to see if user location is within region.
        for casino in casinos {
          let center = CLLocationCoordinate2D(
            latitude: Double(casino.latitude),
            longitude: CLLocationDegrees(casino.longitude))
          let region = CLCircularRegion(
            center: center,
            radius: 1000.0,
            identifier: casino.casinoName)
          if region.contains(loc){
            debugPrint("found region")
            returnValue = casino
            break
          }
        }
        
        // Sets cache so call to server isn't necessary again.
        if returnValue == nil {
          self.casinosCache = casinos
        }
        
        return returnValue
    }
  }
  
  
//  let url = "http://10.10.111.121:8080"
//  let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

//  ///
//  init(){
//
//  }
//
  /**
   Call server to find which casino the user is in
   
   - parameters:
   - CLLocationCoordinate2D
   - returns:
   String containing casino name or casino object.
   */
  // FIXME:- Decide if you want a casino object or string
  // Need casino object who will have url: image associated with the casino.
//  func findCasino(in: CLLocationCoordinate2D) -> Promise<Casino Fake>{
//    return Promise{
//      seal in
//      let casino = Casino Fake(
//        casinoId: 1,
//        casinoCode: "CH",
//        casinoName: "Cre8ive House",
//        casinoImageURL: "http://arctecinc.com/wp-content/uploads/2015/08/Casino-M8trix-1-MAIN-PHOTO.jpg")
//      seal.fulfill(casino)
//    }
//  }
  
  /**
   Encode casino to json and save to online server. Deprecated.
   
   - Throws: `C8HCasinoRepositoryError.ParsingJson`
              If unable to process json recived from server.
   
   - parameters:
      - casino: An instance of C8HCasino used to encode and send to server.
   */
//  func save(casino: C8HCasino?) throws {
//    guard let casino = casino else { return }
//
//    let encoder = JSONEncoder()
//    let serialize: (Data, JSONSerialization.ReadingOptions) throws -> Any = JSONSerialization.jsonObject
//
//    let data = try encoder.encode(casino)
//    guard
//      let dictionary =  try serialize(data, .mutableLeaves) as? [String:Any] else {
//        throw C8HCasinoRepositoryError.ParsingJson
//    }
//
//    Alamofire.request("http://10.10.111.128:8080/casino", method: .post, parameters: dictionary, encoding: JSONEncoding.default).responseJSON().done{ rsp in
//      let json = rsp.json as! Int64
//      casino.id = json
//      do{
//        try self.managedObjectContext.save()
//      }catch{
//        debugPrint(error)
//      }
//      }.catch{ error in
//        debugPrint(error)
//    }
//  }
  
  /**
   Tries to return a casino object.
   
   No longer using. Good to have.
   
   - parameters:
      - loc: CLLocation that represents user's current location.
   
   - returns: Casino object that matches user's current location.
   */
//  func findInWhichCasino(loc: CLLocation)->Promise<C8HCasino>{
//    //try! self.deleteAllCasinos()
//    return Promise{ seal in
//      let find = self.findInWhichCasinoFromCoreData
//
//      // Create request so I can add time interval.
//      var request = URLRequest(url: URL(string: "\(url)/casinos/count")!)
//      request.timeoutInterval = 5 // 5 secs
//
//      Alamofire.request(request).validate().responseJSON()
//        .done{ response in
//          if (response.json as? Int)! != self.fetchLocalCount() {
//            //try self.deleteAllCasinos()
//            self.getAllCasinosAndSave(seal, loc: loc)
//          }else{
//            try seal.fulfill(find(loc))
//          }
//        }.recover{ error in
//          guard error is URLError else{ throw error }
//          seal.fulfill(try find(loc))
//        }.catch{error in
//          seal.reject(error)
//      }
//
//    }
//  }
  
  /**
   Retrieve the casinos in CoreData and scan to find if user is near any casino. 
   
   - parameters:
      - loc: CLLocation that represents user's current location.
   */
//  private func findInWhichCasinoFromCoreData(loc: CLLocation) throws -> C8HCasino{
//    let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    let casinoFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Casino")
//
//    do {
//      let fetchedCasinos = try moc.fetch(casinoFetch) as! [C8HCasino]
//      for casino in fetchedCasinos {
//        let center = CLLocationCoordinate2D(
//          latitude: CLLocationDegrees(casino.latitude),
//          longitude: CLLocationDegrees(casino.longitude))
//        let region = CLCircularRegion(
//          center: center,
//          radius: 100.5,
//          identifier: casino.identifer!)
//        if region.contains(loc.coordinate){
//          return casino
//        }
//      }
//    } catch {
//      fatalError("Failed to fetch employees: \(error)")
//    }
//    throw C8HCasinoRepositoryError.errorFromCD
//  }
  
  //  ============================================================================
  //    Fetch the coint of entity:casino from core data.
//  func fetchLocalCount() -> Int{
//    let casinoFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Casino")
//
//    do{
//      return try self.managedObjectContext.count(for: casinoFetch)
//    }catch{
//      debugPrint("Failed trying to see how many casinos saved: \(error)")
//      return 0
//    }
//  }
  
//  func getAllCasinosAndSave(_ seal: Resolver<C8HCasino>, loc: CLLocation){
//    Alamofire.request("\(url)/casinos").validate().responseJSON()
//      .done{ response in
//        if let casinos = response.json as? [Any] {
//          print("JSON: \(casinos)")
//
//          for casino in casinos{
//            do{
//              try self.insertCasinoIntoCoreData(serverCasino: casino as! [String: Any])
//              debugPrint((casino as! [String: Any]))
//            }catch{
//              fatalError("Error getting casinos from server")
//            }
//          }
//
//          seal.fulfill(try self.findInWhichCasinoFromCoreData(loc: loc))
//        }
//      }.catch{ error in
//        debugPrint(error)
//        seal.reject(error)
//    }
//  }
  
//  func getAllCasinos(){
//    Alamofire.request(url + "/casinos")
//      .validate(statusCode: 200..<300)
//      .validate(contentType: ["application/json"])
//      .responseJSON { response in
//        if let casinos = response.result.value as? [Any] {
//          print("JSON: \(casinos)")
//
//          for casino in casinos{
//            do{
//              try self.insertCasinoIntoCoreData(serverCasino: casino as! [String: Any])
//              debugPrint((casino as! [String: Any]))
//            }catch{
//              fatalError("Error getting casinos from server")
//            }
//          }
//
//        }
//    }
//  }
  
  //  Insert into core data
//  func insertCasinoIntoCoreData(serverCasino: [String: Any]) throws{
//    do {
//      _ = try C8HCasino(dict: serverCasino, context: self.managedObjectContext)
//      try managedObjectContext.save()
//    } catch {
//      fatalError("Failure to save context: \(error)")
//    }
//  }
  
//  func deleteAllCasinos() throws{
//    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Casino")
//    let request = NSBatchDeleteRequest(fetchRequest: fetch)
//    try managedObjectContext.execute(request)
//  }
  
}

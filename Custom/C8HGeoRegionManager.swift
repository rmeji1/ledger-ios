//
//  C8HGeoRegionManager.swift
//  ledge
//
//  Created by robert on 1/14/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import UIKit
import CoreLocation

protocol C8HGeoRegionDelegate : class {
    func onlyAuthorizedWhenInUse()
    func successfullyRetrievedUserLocation()
}
// For now need delegate to alert user for location settings
class C8HGeoRegionManager: NSObject, CLLocationManagerDelegate{
    let locationManager = CLLocationManager()
    var location: CLLocationCoordinate2D? = nil
    
    var casinos: [C8HCasino] = []
    
    //var regions: Set<CLRegion>
    var inRegion: CLCircularRegion?
    weak var delegate: C8HGeoRegionDelegate?
    
    // ========================================================================
    override init(){
        super.init()
    }
    convenience init(_ delegate: C8HGeoRegionDelegate){
        self.init()
        self.delegate = delegate
        applicationWillEnterForegroundNotificaiton(enable: true)
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        checkAndRequestAuthorizationStatus()
        locationManager.requestLocation()
    }
    deinit {
        applicationWillEnterForegroundNotificaiton(enable: false)
    }
//  ============================================================================
//    Used to always check the location settings of the application
    func applicationWillEnterForegroundNotificaiton(enable: Bool){
        let notificationCenter = NotificationCenter.default
        if enable{
            notificationCenter.addObserver(self, selector: #selector(applicationWillEnterForeground), name:
                NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        }else{
            notificationCenter.removeObserver(NSNotification.Name.UIApplicationWillEnterForeground)
        }
    }
    
    private func checkAndRequestAuthorizationStatus() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted, .denied, .authorizedWhenInUse:
            guard let delegate = delegate else{
                break
            }
            delegate.onlyAuthorizedWhenInUse()
        case .authorizedAlways:
            break
        }
    }
    
    @objc private func applicationWillEnterForeground(){
        checkAndRequestAuthorizationStatus()
    }

    func requestLocation(){
        locationManager.requestLocation()
        //setRegions()
        //locationManager.requestLocation()
    }
    
    // =========================================================================
    // MARK: Location Monitor delegate
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        //print("Called this to get region")
        //locationManager.stopUpdatingLocation()
        guard let loc = manager.location?.coordinate else{
            print("Unable to determine user location")
            return
        }
        location = loc
        debugPrint(location!)
        //findInWhichRegion(coordinate: loc)
        //delegate?.successfullyRetrievedUserLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Error for location services:\n " + error.localizedDescription)
        
    }
    
    // =========================================================================
    // MARK: Region monitoring
    // For now we can use this but eventually need to call the server to get
    // all of the regions
    // Change to use Casino
    func setRegions(){
        print("Monitored Regions count =  \(locationManager.monitoredRegions.count)")
        if locationManager.monitoredRegions.count == 0 {
            let homeCenter = CLLocationCoordinate2D(latitude: 40.712207 , longitude:  -73.961812)
            let noBullCenter = CLLocationCoordinate2D(latitude: 40.704440 , longitude:  -73.930006)
            let crea8iveCenter = CLLocationCoordinate2D(latitude: 40.697485 , longitude:  -73.910931)
            
            monitorRegionAtLocation(center: homeCenter, identifier: "Flex Casino")
            monitorRegionAtLocation(center: noBullCenter, identifier: "No Bull Casino")
            monitorRegionAtLocation(center: crea8iveCenter, identifier: "Crea8ive House Casino")
        }
    }
    
    func stopMonitoringRegions(){
        for region in locationManager.monitoredRegions{
            locationManager.stopMonitoring(for: region)
        }
    }
    
    func findInWhichRegion(coordinate: CLLocationCoordinate2D){
        if inRegion == nil{
            for region in locationManager.monitoredRegions {
                if let circularRegion = region as? CLCircularRegion{
                    //                    circularRegion
                    print(circularRegion.description)
                    if circularRegion.contains(coordinate){
                        print("Found region user is in " + circularRegion.identifier)
                        self.inRegion = circularRegion
                    }
                    
                }
            }
        }
    }
    
    // Call this to monitor if the user leaves a region
    func monitorRegionAtLocation(center: CLLocationCoordinate2D, identifier: String ) {
        // Make sure the app is authorized.
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            // Make sure region monitoring is supported.
            if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
                // Register the region.
                let maxDistance = 100.5//locationManager.maximumRegionMonitoringDistance
                let region = CLCircularRegion(center: center,
                                              radius: maxDistance, identifier: identifier)
                region.notifyOnEntry = true
                region.notifyOnExit = true
                
                locationManager.startMonitoring(for: region)
                print("Started monitoring region " + identifier)
            }
        }
    }
    
    func checkRegion() -> Bool {
        var status = false
        if self.inRegion != nil {
            status = true
        }
        return status
    }
}

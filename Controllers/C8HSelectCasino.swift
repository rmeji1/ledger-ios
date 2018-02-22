//
//  C8HSelectCasino.swift
//  ledge
//
//  Created by robert on 1/11/18.
//  Copyright © 2018 com.cre8ivehouse. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class C8HSelectCasino: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    //MARK: Properties
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var mapOverlay: UIView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        indicator.hidesWhenStopped = true
        //mapOverlay.isHidden = false
        alertUserIfRegionFound()
//        mapView.
        
    }
    
    func alertUserIfRegionFound(){
        // Need function that checks if a region is not null
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //if appDelegate.manager.checkRegion(){
            // Display you are in region alert and save casino it is in
          //  displayAlert((appDelegate.manager.inRegion?.identifier)!)
        //} else {
            // Try to find region
            // if can't find alert user they are not near any casino
            // displayAlert("Cannot find your location.")
//            UIApplication.shared.beginIgnoringInteractionEvents()
//            mapOverlay.isHidden = false
//            indicator.startAnimating()
//            appDelegate.manager.findInWhichRegion(coordinate: mapView.userLocation.coordinate)
//            indicator.stopAnimating()
//            mapOverlay.isHidden = true
            //displayAlert((appDelegate.manager.inRegion?.identifier)!)

//            Next should try to find the users current locations.
//            If unsucessful then note the user is
//            indicator.stopAnimating()
//        }
    }
    
    func displayAlert(_ casino: String){
//        // Create alert
//        let alert = UIAlertController(title: "Found location", message: "We have determined you are at \(casino). If correct, please continue", preferredStyle: .actionSheet)
//        // Create actions
//        let continueAction = UIAlertAction(title: NSLocalizedString("Continue", comment: "Default action"), style: .`default`, handler: { _ in
//            self.performSegue(withIdentifier: "proceedToEnterInformation", sender: nil)
//        })
//        // Add actions
//        alert.addAction(continueAction)
//        self.present(alert, animated: true, completion: nil)
//        // Display alert
    }
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error){
        print(error.localizedDescription + "\n\n\n\n")
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation)
    {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
////        mapView.showsUserLocation = false
//        
//        self.mapView.setUserTrackingMode(MKUserTrackingMode.none, animated: true)
//
//        print("Updating location\n\n\n\n")
//        UIApplication.shared.beginIgnoringInteractionEvents()
//        mapOverlay.isHidden = false
//        indicator.startAnimating()
//        appDelegate.manager.findInWhichRegion(coordinate: mapView.userLocation.coordinate)
//        indicator.stopAnimating()
//        mapOverlay.isHidden = true
//        displayAlert((appDelegate.manager.inRegion?.identifier)!)
        
        
//        mapView.setUserTrackingMode(MKUserTrackingMode.none, animated: true)
//        mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        // Find where the user is depending on the
//        indicator.stopAnimating()
//        UIApplication.shared.endIgnoringInteractionEvents()
//
//        let location = CLLocation(latitude: 40.697299, longitude: -73.910849) //get geo house coordinate
//        let distance = userLocation.location?.distance(from: location)// distance from current distance to geo house
//        let message = "Distance from Cre8ive house is \(String(describing: distance))"
//        let alert = UIAlertController(title: "Alert" , message: message, preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//
//
//        locationManager.stopUpdatingLocation()
//
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool){
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //        mapView.showsUserLocation = false
        self.mapView.setUserTrackingMode(MKUserTrackingMode.none, animated: true)
        print("Updating location\n\n\n\n")
        UIApplication.shared.beginIgnoringInteractionEvents()
        mapOverlay.isHidden = false
        indicator.startAnimating()
        //appDelegate.manager.findInWhichRegion(coordinate: mapView.userLocation.coordinate)
        indicator.stopAnimating()
        mapOverlay.isHidden = true
        UIApplication.shared.endIgnoringInteractionEvents()
        //displayAlert((appDelegate.manager.inRegion?.identifier)!)
    }
}


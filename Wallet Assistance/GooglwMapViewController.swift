//
//  GooglwMapViewController.swift
//  WalletAssistance
//
//  Created by Radadiya on 10/09/18.
//  Copyright © 2018 Radadiya. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import MapKit
import Alamofire
import SwiftyJSON
import UserNotifications



struct MyPlace {
    var name: String
    var lat: Double
    var long: Double
}

class GooglwMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate,MKMapViewDelegate,GMSAutocompleteViewControllerDelegate {
  
   // static let geoCoder = CLGeocoder()

    var expenseList = [Expense].self
    var locationManger = CLLocationManager()
    var LocationManager = CLLocationManager()
    var currentLocation = CLLocationCoordinate2D()
    var searchlocation = CLLocation()
    @IBOutlet weak var googleMapsView: GMSMapView!
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // for Google Map
        LocationManager = CLLocationManager()
        LocationManager.delegate = self
        LocationManager.requestWhenInUseAuthorization()
        LocationManager.startUpdatingLocation()
        LocationManager.desiredAccuracy = kCLLocationAccuracyBest
        LocationManager.startMonitoringSignificantLocationChanges()
        // Create a GMSCameraPosition that tells the map to display the
        let camera = GMSCameraPosition.camera(withLatitude: 21.195941, longitude: 72.808300, zoom: 16.0)
        self.googleMapsView.camera = camera
        
        /* googleMapsView.settings.myLocationButton = true
         googleMapsView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 50)*/
        self.googleMapsView.delegate = self
        self.googleMapsView?.isMyLocationEnabled = true
        self.googleMapsView.settings.myLocationButton = true
        self.googleMapsView.settings.compassButton = true
        self.googleMapsView.settings.zoomGestures = true
        locationManger.startUpdatingLocation()
       
    
    }
    
    func nearbyATM(latitude : CLLocationDegrees,longitude : CLLocationDegrees)
    {
        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=500&type=atm&key=AIzaSyC4_041lIqzm_BHqIZDWBqmB9fVicZwuQw"
        //API Key=AIzaSyAcGeiAMxgfsxqSH3Tf1nvdCTWYIFd8BbY
        Alamofire.request(url).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                 let swiftyJsonVar = JSON(responseData.result.value!)
                 let results = swiftyJsonVar["results"].arrayValue
                for result in results{
                    let routeOverviewPloyLine = result["geometry"].dictionaryValue
                    let name = result["name"].stringValue
                    let point = routeOverviewPloyLine["location"]!
                    let lati = point["lat"].doubleValue
                    let long = point["lng"].doubleValue
                    self.createMarker(titleMarker: name, latitude: lati, longitude: long)
                }
            }
        }
    }
 
    @IBAction func searchwithAddress(_ sender: AnyObject) {
        // MARK: for Search Bar
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self as? GMSAutocompleteViewControllerDelegate
        UISearchBar.appearance().setTextColor(color: UIColor.black)
        self.locationManger.stopUpdatingLocation()
        self.present(autoCompleteController,animated: true,completion: nil)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error to get Location...\(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            googleMapsView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
   
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            createMarker(titleMarker: "Current Location ", latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            print(location)
            
            nearbyATM(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        googleMapsView?.isMyLocationEnabled = true
    }
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        googleMapsView?.isMyLocationEnabled = true
        
        if(gesture)
        {
            mapView.selectedMarker = nil
        }
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        googleMapsView?.isMyLocationEnabled = true
        googleMapsView?.selectedMarker = nil
        return false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func createMarker(titleMarker: String , latitude: CLLocationDegrees , longitude: CLLocationDegrees)
    {
        //MARK: FOR MARKER
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = titleMarker
        marker.map = googleMapsView
       
    }
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // MARK: Goes There Where You Selected
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15)
        
        //Seleceted Location Marker Generated
        searchlocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        createMarker(titleMarker: "\(place.name)", latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        
        
        googleMapsView?.camera = camera
        self.dismiss(animated: true, completion: nil)
    }
   
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("error \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
   
}


//public extension UISearchBar
//{
//    public func setTextColor(color: UIColor)
//    {
//        // MARK: Suggest Places
//        let svs = subviews.flatMap { $0.subviews }
//        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField    else {
//            return
//        }
//        tf.textColor = color
//    }
//}

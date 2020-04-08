//
//  ExpenseLocationViewController.swift
//  WalletAssistance
//
//  Created by Radadiya on 26/09/18.
//  Copyright © 2018 Radadiya. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import MapKit
import Alamofire
import SwiftyJSON
import SQLite3
class ExpenseLocationViewController: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var expenseList = [Expense]()
    var locationManger = CLLocationManager()
    var LocationManager = CLLocationManager()
    var currentLocation = CLLocationCoordinate2D()
    var totalSports = 0.0
    var totalHealth = 0.0
    var totalFamily = 0.0
    var totalFood = 0.0
    var totalBills = 0.0
    var totalEntertainment = 0.0
    var totalFuel = 0.0
    var totalHome = 0.0
    var totalOther = 0.0
    var totalShoping = 0.0
    var totalTransport = 0.0
    var totalTravel = 0.0
    var CategeryTotal = [String]()
    var db : OpaquePointer?
    var Location = [String]()
    var Latitude = [String]()
    var Longitude = [String]()
    //var categery = ["Sports","Health","Family","Food","Bills","Entertainment","Fuel","Home","Other","Shopping","Transport","Travel"]
    @IBOutlet weak var googleMapsView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.locationManger.startUpdatingLocation()
        fetchData()
        //            1. totalSports
        //            2. totalHealth
        //            3. totalFamily
        //            4. totalFood
        //            5. totalBills
        //            6. totalEntertainment
        //            7. totalFuel
        //            8. totalHome
        //            9. totalOther
        //            10.totalShoping
        //            11.totalTransport
        //            12.totalTravel
        
       
        for i in 0..<CategeryTotal.count
        {
            var title : String
            title = (Location[i]) + " : "+(CategeryTotal[i])+" ₹ "
            createMarker(titleMarker: title, latitude: Double(Latitude[i])!, longitude: Double(Longitude[i])!)
          
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchData()  {
        DatabaseConnection()
        var stmt : OpaquePointer?
        let selectquery = "select Sum(Amount),Place,Latitude,Longitude from Expense group by Place "
        
        if sqlite3_prepare(db, selectquery, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        var Amount : String
        var location : String
        var latitude : String
        var longitude : String
        
//        var ExpenseDate: String?
//        var Ammount: String?
//        var Catagory: String?
//        var Place : String?
//        var Latitude: String?
//        var Longitude: String?
//        var Repeat: String?
//        var Remind: String?
//        var Note: String?
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
           
           
            Amount = String(cString: sqlite3_column_text(stmt, 0))
            location = String(cString: sqlite3_column_text(stmt, 1))
            latitude = String(cString: sqlite3_column_text(stmt, 2))
            longitude = String(cString: sqlite3_column_text(stmt, 3))

            //adding values to list


                CategeryTotal.append(Amount)
                Location.append(location)
                Latitude.append(latitude)
                Longitude.append(longitude)
            
            
//            let Data_id = sqlite3_column_int(stmt, 0)
//            ExpenseDate = String(cString: sqlite3_column_text(stmt, 1))
//            Ammount = String(cString: sqlite3_column_text(stmt, 2))
//            Catagory = String(cString: sqlite3_column_text(stmt, 3))
//            Place = String(cString: sqlite3_column_text(stmt, 4))
//            Latitude = String(cString: sqlite3_column_text(stmt, 5))
//            Longitude = String(cString: sqlite3_column_text(stmt, 6))
//            Repeat = String(cString: sqlite3_column_text(stmt, 7))
//            Remind = String(cString: sqlite3_column_text(stmt, 8))
//            Note = String(cString: sqlite3_column_text(stmt, 9))
//
//                //adding values to list
//
//                guard let data = Expense(id: String(Data_id), date: ExpenseDate, expense: Ammount, catagory: Catagory, place: Place, latitude: Latitude,longitude: Longitude,Repeat: Repeat,remind: Remind, note: Note) else {
//                    fatalError("Unable to instantiate Expense")
//                }
//                expenseList += [data]
//
//
      }
       
        
    }
    func DatabaseConnection()  {
        let fileUrl = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil ,create: false).appendingPathComponent("WalletAssistance.sqlite")
        print(fileUrl)
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{
            print("Error Opening database")
            return
        }
        
    }
    func createMarker(titleMarker: String , latitude: CLLocationDegrees , longitude: CLLocationDegrees)
    {
        //MARK: FOR MARKER
        let marker = GMSMarker()
       
            marker.position = CLLocationCoordinate2DMake(latitude,longitude)
                marker.title = titleMarker
                marker.map = googleMapsView
        
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first{
            createMarker(titleMarker: "Current Location ", latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            print(location)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

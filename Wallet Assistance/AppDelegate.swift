
import UIKit
import CoreData
import GoogleSignIn
import Firebase
import GooglePlaces
import GoogleMaps
import Alamofire
import SwiftyJSON
import CoreLocation
import UserNotifications
import SQLite3

var userLogin : Bool = false
var userName : String?
var userImage : URL?
let googleButton = GIDSignInButton()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , GIDSignInDelegate{
    
    var window: UIWindow?
    var locationManager: CLLocationManager?
    var notificationCenter: UNUserNotificationCenter?
    let center = UNUserNotificationCenter.current()
    var db : OpaquePointer?
    var expenseList = [Expense]()
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error{
            print("Faild to Login with Google ", err)
            return
        }
        print("Sucessfully login into Google ", user)
        
        guard let idToken = user.authentication.idToken else{ return }
        guard let accessToken = user.authentication.accessToken else{ return }
        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        Auth.auth().signInAndRetrieveData(with: credentials) { (user, err) in
            if err != nil{
                print("somthing wrong with Google", err as Any)
                return
            }
            print("Sucess with Google", user as Any)
            userLogin = true
            userName = user?.user.displayName
            userImage = GIDSignIn.sharedInstance().currentUser.profile.imageURL(withDimension: 100)
        
            print(userImage)
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        
//        AIzaSyAR0lhY62jbF0JQvGLTS9ituWLITyO6xkA
//        AIzaSyCC1uD3cudMfEON6vVuPLxI6xMAIIRIUJA
        // AIzaSyCC1uD3cudMfEON6vVuPLxI6xMAIIRIUJA
        GMSServices.provideAPIKey("AIzaSyC4_041lIqzm_BHqIZDWBqmB9fVicZwuQw")
        GMSPlacesClient.provideAPIKey("AIzaSyC4_041lIqzm_BHqIZDWBqmB9fVicZwuQw")
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert , .sound, .badge], completionHandler: { didAllow, error in
            
        })
        self.fetchData()
       // nearbyLocation(latitude: 19.0176147, longitude: 72.8561644)
       // CheckTodaysTranscation()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        
        // app becomes active
        // this method is called on first launch when app was closed / killed and every time app is reopened or change status from background to foreground (ex. mobile call)
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
         // nearbyLocation(latitude: 19.0176147, longitude: 72.8561644)
        CheckTodaysTranscation()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//        if(userLogin == true)
//        {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil);
//
//            // Then push that view controller onto the navigation stack
//            let rootViewController = self.window!.rootViewController as! UIViewController;
//            rootViewController.performSegue(withIdentifier: "Auth", sender: AnyObject.self)
//
//        }
         // nearbyLocation(latitude: 19.0176147, longitude: 72.8561644)
        CheckTodaysTranscation()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Wallet_Assistance")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    func nearbyLocation(latitude : CLLocationDegrees,longitude : CLLocationDegrees)
    {
        
        
        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=1500&key=AIzaSyC4_041lIqzm_BHqIZDWBqmB9fVicZwuQw"
        //API Key=AIzaSyAcGeiAMxgfsxqSH3Tf1nvdCTWYIFd8BbY
        Alamofire.request(url).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                let results = swiftyJsonVar["results"].arrayValue
                for result in results{
                    let routeOverviewPloyLine = result["geometry"].dictionaryValue
                    //  let name = result["name"].stringValue
                    let point = routeOverviewPloyLine["location"]!
                    let lati = point["lat"].doubleValue
                    let long = point["lng"].doubleValue
                    
                    self.fetchData()
                    for expense in self.expenseList
                    {
                        if (lati == (Double(expense.latitude!)) && long == (Double(expense.longitude!)))
                        {
                            self.LocalNotification(title: "Wallet Assistance", subtitle: "Alert For You", body: "Now you are near by your Danger Zone")
                        }
                    }
                }
            }
        }
    }
    func LocalNotification(title:String,subtitle:String,body:String)
    {
        //MARK: Notification
        
        let content = UNMutableNotificationContent()
        
        //adding title, subtitle, body and badge
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.badge = 1
        
        //getting the notification trigger
        //it will be called after 5 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        //getting the notification request
        let request = UNNotificationRequest(identifier: "SimplifiedIOSNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
    func fetchData()  {
        DatabaseConnection()
        var stmt : OpaquePointer?
        let selectquery = "SELECT * FROM expense "
        
        if sqlite3_prepare(db, selectquery, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        var max = 0.0
        var Date: String?
        var Ammount: String?
        var Catagory: String?
        var Place : String?
        var Latitude: String?
        var Longitude: String?
        var Repeat: String?
        var Remind: String?
        var Note: String?
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let Data_id = sqlite3_column_int(stmt, 0)
            Date = String(cString: sqlite3_column_text(stmt, 1))
            Ammount = String(cString: sqlite3_column_text(stmt, 2))
            Catagory = String(cString: sqlite3_column_text(stmt, 3))
            Place = String(cString: sqlite3_column_text(stmt, 4))
            Latitude = String(cString: sqlite3_column_text(stmt, 5))
            Longitude = String(cString: sqlite3_column_text(stmt, 6))
            Repeat = String(cString: sqlite3_column_text(stmt, 7))
            Remind = String(cString: sqlite3_column_text(stmt, 8))
            Note = String(cString: sqlite3_column_text(stmt, 9))
            
            //adding values to list
            if (max < (Double(Ammount!)!))
            {
                max = (Double(Ammount!)!)
                expenseList.removeAll()
                guard let data = Expense(id: String(Data_id), date: Date, expense: Ammount, catagory: Catagory, place: Place, latitude: Latitude,longitude: Longitude,Repeat: Repeat,remind: Remind, note: Note) else {
                    fatalError("Unable to instantiate Expense")
                }
                expenseList += [data]
            }
        }
        // print(expenseList.count)
        
    }
    func DatabaseConnection()  {
        let fileUrl = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil ,create: false).appendingPathComponent("WalletAssistance.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{
            print("Error Opening database")
            return
        }
        
    }
    func CheckTodaysTranscation()  {
        let currentdate = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: currentdate)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yy"
        let d = formatter.string(from: currentdate)
        let hour = components.hour
        
        DatabaseConnection()
        var stmt : OpaquePointer?
        let selectquery = "SELECT * FROM Expense order by Date DESC"
        
        
        if sqlite3_prepare(db, selectquery, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        var DatabaseDate: String?
        var Ammount: String?
        var Catagory: String?
        var Place : String?
        var Latitude: String?
        var Longitude: String?
        var Repeat: String?
        var Remind: String?
        var Note: String?
        expenseList.removeAll()
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            
            let Data_id = sqlite3_column_int(stmt, 0)
            DatabaseDate = String(cString: sqlite3_column_text(stmt, 1))
            Ammount = String(cString: sqlite3_column_text(stmt, 2))
            Catagory = String(cString: sqlite3_column_text(stmt, 3))
            Place = String(cString: sqlite3_column_text(stmt, 4))
            Latitude = String(cString: sqlite3_column_text(stmt, 5))
            Longitude = String(cString: sqlite3_column_text(stmt, 6))
            Repeat = String(cString: sqlite3_column_text(stmt, 7))
            Remind = String(cString: sqlite3_column_text(stmt, 8))
            Note = String(cString: sqlite3_column_text(stmt, 9))
            
            //adding values to list
            
            guard let data = Expense(id: String(Data_id), date: DatabaseDate, expense: Ammount, catagory: Catagory, place: Place, latitude: Latitude,longitude: Longitude,Repeat: Repeat,remind: Remind, note: Note) else {
                fatalError("Unable to instantiate Expense")
            }
            expenseList += [data]
        }
        if(expenseList[0].date != d)
        {
            if(hour == 9)
            {
                self.LocalNotification(title: "Wallet Assistance", subtitle: "Reminder For you", body: "Don't Forget Today's Transcation")
            }
        }
        // print(expenseList.count)
        
    }
}



import UIKit
import GoogleSignIn
import SQLite3



class ViewController: UIViewController {
    
    var db : OpaquePointer?
    var stmt : OpaquePointer?
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    var datas = [ReadData]()
    var data: ReadData?
    
    var incomeDatas = [ReadIncomeData]()
    var incomeData: ReadIncomeData?
    
    var totalExpense : Int = 0
    var totalIncome : Int = 0
    
    var HomePercentage: Int = 0
    var FoodPercentage: Int = 0
    var ShopingPercentage: Int = 0
    var EntertainmentPercentage: Int = 0
    var SportsPercentage: Int = 0
    var BillsPercentage: Int = 0
    var TravelingPercentage: Int = 0
    var TransportPercentage: Int = 0
    var OtherPercentage: Int = 0
    var HealthPercentage: Int = 0
    var FamilyPercentage: Int = 0
    var FuelPercentage: Int = 0
    //var s : String = "Arpit"
    
    var HomeTotal: Int = 0
    var FoodTotal: Int = 0
    var ShopingTotal: Int = 0
    var EntertainmentTotal: Int = 0
    var SportsTotal: Int = 0
    var BillsTotal: Int = 0
    var TravelingTotal: Int = 0
    var TransportTotal: Int = 0
    var OtherTotal: Int = 0
    var HealthTotal: Int = 0
    var FamilyTotal: Int = 0
    var FuelTotal: Int = 0
    
    let FullMonth: [String] = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    let Month: [String] = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]

    //Views
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var TopView: UIView!
    @IBOutlet weak var BottomView: UIView!
    //Labels
    @IBOutlet weak var IncomeLabel: UILabel!
    @IBOutlet weak var ExpenseLabel: UILabel!
    @IBOutlet weak var MonthLabel: UILabel!
    @IBOutlet weak var BalanceLabel: UILabel!
    //Small Labels
    
    @IBOutlet weak var SportsLabel: UILabel!
    @IBOutlet weak var HealthLabel: UILabel!
    @IBOutlet weak var FamilyLabel: UILabel!
    @IBOutlet weak var OtherLabel: UILabel!
    @IBOutlet weak var FoodLabel: UILabel!
    @IBOutlet weak var BillsLabel: UILabel!
    @IBOutlet weak var FuelLabel: UILabel!
    @IBOutlet weak var HomeLabel: UILabel!
    @IBOutlet weak var TransportLabel: UILabel!
    @IBOutlet weak var EntertainmentLabel: UILabel!
    @IBOutlet weak var ShopingLabel: UILabel!
    @IBOutlet weak var TravelingLabel: UILabel!
    //Buttons
    @IBOutlet weak var AddButton: UIButton!
    //ImageViews
    @IBOutlet weak var SportsImage: UIImageView!
    @IBOutlet weak var CallImage: UIImageView!
    @IBOutlet weak var TravellingImage: UIImageView!
    @IBOutlet weak var EntertainmentImage: UIImageView!
    @IBOutlet weak var CosmaticsImage: UIImageView!
    @IBOutlet weak var FoodImage: UIImageView!
    @IBOutlet weak var FuelImage: UIImageView!
    @IBOutlet weak var ShoppingImage: UIImageView!
    @IBOutlet weak var HealthImage: UIImageView!
    @IBOutlet weak var TransportImage: UIImageView!
    @IBOutlet weak var DrinksImage: UIImageView!
    @IBOutlet weak var ClothesImage: UIImageView!
    
    //Indicator Labels
    
    //@IBOutlet weak var HealthLabel: UILabel!
    
    var TopViewWidth : CGFloat?
    var TopViewHeight : CGFloat?
    var Balance: String?
    var CatagoryImageTag : Int = 1
    var m = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        let Green = UIColor.green
        let Red = UIColor.red
        let Blue = UIColor.blue
        //let gcolor = UIColor(displayP3Red: 0.74, green: 2, blue: 0.40, alpha: 1)
        let gcolor = UIColor(red: 0.74, green: 1.03, blue: 0.40, alpha: 1)
        IncomeLabel.layer.borderWidth = 2
        IncomeLabel.layer.borderColor = gcolor.cgColor
        IncomeLabel.layer.cornerRadius = 5
        ExpenseLabel.layer.borderWidth = 2
        ExpenseLabel.layer.borderColor = Red.cgColor
        ExpenseLabel.layer.cornerRadius = 5
        MonthLabel.font = UIFont.boldSystemFont(ofSize: 25)
        BalanceLabel.layer.borderWidth = 2
        BalanceLabel.layer.borderColor = Blue.cgColor
        BalanceLabel.layer.cornerRadius = 5
        AddButton.layer.cornerRadius = 10
        AddButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 50)
        
        
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: now)
        
        MonthLabel.text = nameOfMonth
        let MonthLabelGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.monthTapped(_:)))
        MonthLabel.addGestureRecognizer(MonthLabelGesture)
        MonthLabel.isUserInteractionEnabled = true
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(ViewController.imageTapped(_:)))
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(ViewController.imageTapped(_:)))
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(ViewController.imageTapped(_:)))
        let tapGesture4 = UITapGestureRecognizer(target: self, action: #selector(ViewController.imageTapped(_:)))
        let tapGesture5 = UITapGestureRecognizer(target: self, action: #selector(ViewController.imageTapped(_:)))
        let tapGesture6 = UITapGestureRecognizer(target: self, action: #selector(ViewController.imageTapped(_:)))
        let tapGesture7 = UITapGestureRecognizer(target: self, action: #selector(ViewController.imageTapped(_:)))
        let tapGesture8 = UITapGestureRecognizer(target: self, action: #selector(ViewController.imageTapped(_:)))
        let tapGesture9 = UITapGestureRecognizer(target: self, action: #selector(ViewController.imageTapped(_:)))
        let tapGesture10 = UITapGestureRecognizer(target: self, action: #selector(ViewController.imageTapped(_:)))
        let tapGesture11 = UITapGestureRecognizer(target: self, action: #selector(ViewController.imageTapped(_:)))
        let tapGesture12 = UITapGestureRecognizer(target: self, action: #selector(ViewController.imageTapped(_:)))
        
        SportsImage.addGestureRecognizer(tapGesture1)
        SportsImage.isUserInteractionEnabled = true
        CallImage.addGestureRecognizer(tapGesture2)
        CallImage.isUserInteractionEnabled = true
        TravellingImage.addGestureRecognizer(tapGesture3)
        TravellingImage.isUserInteractionEnabled = true
        EntertainmentImage.addGestureRecognizer(tapGesture4)
        EntertainmentImage.isUserInteractionEnabled = true
        CosmaticsImage.addGestureRecognizer(tapGesture5)
        CosmaticsImage.isUserInteractionEnabled = true
        FoodImage.addGestureRecognizer(tapGesture6)
        FoodImage.isUserInteractionEnabled = true
        FuelImage.addGestureRecognizer(tapGesture7)
        FuelImage.isUserInteractionEnabled = true
        ShoppingImage.addGestureRecognizer(tapGesture8)
        ShoppingImage.isUserInteractionEnabled = true
        HealthImage.addGestureRecognizer(tapGesture9)
        HealthImage.isUserInteractionEnabled = true
        TransportImage.addGestureRecognizer(tapGesture10)
        TransportImage.isUserInteractionEnabled = true
        DrinksImage.addGestureRecognizer(tapGesture11)
        DrinksImage.isUserInteractionEnabled = true
        ClothesImage.addGestureRecognizer(tapGesture12)
        ClothesImage.isUserInteractionEnabled = true
        
        
        let LongtapGesture1 = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.ImageLongTapped(_:)))
        let LongtapGesture2 = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.ImageLongTapped(_:)))
        let LongtapGesture3 = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.ImageLongTapped(_:)))
        let LongtapGesture4 = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.ImageLongTapped(_:)))
        let LongtapGesture5 = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.ImageLongTapped(_:)))
        let LongtapGesture6 = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.ImageLongTapped(_:)))
        let LongtapGesture7 = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.ImageLongTapped(_:)))
        let LongtapGesture8 = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.ImageLongTapped(_:)))
        let LongtapGesture9 = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.ImageLongTapped(_:)))
        let LongtapGesture10 = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.ImageLongTapped(_:)))
        let LongtapGesture11 = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.ImageLongTapped(_:)))
        let LongtapGesture12 = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.ImageLongTapped(_:)))
        SportsImage.addGestureRecognizer(LongtapGesture1)
        SportsImage.isUserInteractionEnabled = true
        CallImage.addGestureRecognizer(LongtapGesture2)
        CallImage.isUserInteractionEnabled = true
        TravellingImage.addGestureRecognizer(LongtapGesture3)
        TravellingImage.isUserInteractionEnabled = true
        EntertainmentImage.addGestureRecognizer(LongtapGesture4)
        EntertainmentImage.isUserInteractionEnabled = true
        CosmaticsImage.addGestureRecognizer(LongtapGesture5)
        CosmaticsImage.isUserInteractionEnabled = true
        FoodImage.addGestureRecognizer(LongtapGesture6)
        FoodImage.isUserInteractionEnabled = true
        FuelImage.addGestureRecognizer(LongtapGesture7)
        FuelImage.isUserInteractionEnabled = true
        ShoppingImage.addGestureRecognizer(LongtapGesture8)
        ShoppingImage.isUserInteractionEnabled = true
        HealthImage.addGestureRecognizer(LongtapGesture9)
        HealthImage.isUserInteractionEnabled = true
        TransportImage.addGestureRecognizer(LongtapGesture10)
        TransportImage.isUserInteractionEnabled = true
        DrinksImage.addGestureRecognizer(LongtapGesture11)
        DrinksImage.isUserInteractionEnabled = true
        ClothesImage.addGestureRecognizer(LongtapGesture12)
        ClothesImage.isUserInteractionEnabled = true
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapSignOut(_:)))
        self.navigationItem.setHidesBackButton(true, animated:true);
        createTable()
        monthTaped()
   
    }
    
    func createTable(){
        
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("WalletAssistance.sqlite")
        print(fileUrl)
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{
            
            print("Error opening database")
        }
        
        let createTable = "CREATE TABLE IF NOT EXISTS Expense (Expense_Id INTEGER PRIMARY KEY AUTOINCREMENT, Date TEXT, Amount TEXT, Category TEXT,Place TEXT, Latitude TEXT, Longitude TEXT, Repeat TEXT, Remind TEXT, Note TEXT)"
        
        
        if sqlite3_exec(db, createTable, nil, nil, nil) != SQLITE_OK{
            print("Error crearing table")
            return
        }
        else
        {
            print(fileUrl.path)
            print("Expense Table Created")
        }
    }
    
    @IBAction func AddIncome(_ sender: Any) {
        performSegue(withIdentifier: "AddStoryBoard", sender: nil)
    }
    
    @IBAction func AddExpense(_ sender: Any) {
    }
    func readExpenseData(){
        datas.removeAll()
        let queryString = "SELECT * FROM Expense"
        print(queryString)
        
        let currentdate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        //let d = formatter.string(from: currentdate)
        let d = Month[m]
        print(d)
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) == SQLITE_OK{
            
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
                
                if (Date?.contains(d))!
                {
                    guard let data = ReadData(id: String(Data_id), date: Date, expense: Ammount, catagory: Catagory, place: Place, latitude: Latitude,longitude: Longitude,Repeat: Repeat,remind: Remind, note: Note) else {
                        fatalError("Unable to instantiate Expense")
                    }
                    datas += [data]
                    print(data.date)
                }
                else{
                    totalExpense = 0
                }
            }
        }
        else{
            let errmsg = String(cString: sqlite3_errmsg(db))
            print(errmsg)
            
        }
        
        
    }
    
    func readIncomeData(){
        incomeDatas.removeAll()
        //IncomeLabel.text = "0"
        let queryString = "SELECT * FROM Income"
        print(queryString)
        
        let currentdate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        //let d = formatter.string(from: currentdate)
        var d = ""
        if m < 11 && m > 0{
            print(m)
        d = Month[m-1]
        }
        if m == 0{
            print(m)
            d = Month[0]
        }
        if m == 11 {
            d = Month[0]
        }
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) == SQLITE_OK{
            
            var Date: String?
            var Ammount: String?
            var Catagory: String?
            var Note: String?
            
            while(sqlite3_step(stmt) == SQLITE_ROW){
                let Data_id = sqlite3_column_int(stmt, 0)
                Date = String(cString: sqlite3_column_text(stmt, 1))
                Ammount = String(cString: sqlite3_column_text(stmt, 2))
                Catagory = String(cString: sqlite3_column_text(stmt, 3))
                Note = String(cString: sqlite3_column_text(stmt, 4))
                
                if (Date?.contains(d))!
                {
                    guard let incomeData = ReadIncomeData(id: String(Data_id), date: Date, expense: Ammount, catagory: Catagory, note: Note) else {
                        fatalError("Unable to instantiate Income")
                    }
                    incomeDatas += [incomeData]
                }
                else{
                    totalIncome = 0
                }
            }
        }
        else{
            let errmsg = String(cString: sqlite3_errmsg(db))
            print(errmsg)
            
        }
    }
    
    func smallLabelSetup(){
        
        HomePercentage = 0
        FoodPercentage = 0
        ShopingPercentage = 0
        EntertainmentPercentage = 0
        SportsPercentage = 0
        BillsPercentage = 0
        TravelingPercentage = 0
        TransportPercentage = 0
        OtherPercentage = 0
        HealthPercentage = 0
        FamilyPercentage = 0
        FuelPercentage = 0
        
//        HomeLabel.text="0%"
//        FoodLabel.text="0%"
//        ShopingLabel.text="0%"
//        EntertainmentLabel.text="0%"
//        SportsLabel.text="0%"
//        BillsLabel.text="0%"
//        TravelingLabel.text="0%"
//        TransportLabel.text="0%"
//        OtherLabel.text="0%"
//        HealthLabel.text="0%"
//        FamilyLabel.text="0%"
//        FuelLabel.text="0%"
        
        if(datas.count>0){
        for i in 0...datas.count-1{
            data = datas[i]
            //print(data?.catagory)
            let index = data?.catagory
            //print(index)
            if(totalIncome != 0){
            switch index {
            case "Sports"  :
                SportsPercentage = SportsPercentage + Int((data?.expense)!)!
                SportsLabel.text = String((SportsPercentage*100)/totalIncome)
                SportsLabel.text?.append("%")
                break

            case "Health"  :
                HealthPercentage = HealthPercentage + Int((data?.expense)!)!
                HealthLabel.text = String((HealthPercentage*100)/totalIncome)
                HealthLabel.text?.append("%")
                break

            case "Family"  :
                FamilyPercentage = FamilyPercentage + Int((data?.expense)!)!
                FamilyLabel.text = String((FamilyPercentage*100)/totalIncome)
                FamilyLabel.text?.append("%")
                break
                
            case "Food"  :
                FoodPercentage = FoodPercentage + Int((data?.expense)!)!
                FoodLabel.text = String((FoodPercentage*100)/totalIncome)
                FoodLabel.text?.append("%")
                break
                
            case "Bills"  :
                BillsPercentage = BillsPercentage + Int((data?.expense)!)!
                BillsLabel.text = String((BillsPercentage*100)/totalIncome)
                BillsLabel.text?.append("%")
                break
                
            case "Entertainment"  :
                EntertainmentPercentage = EntertainmentPercentage + Int((data?.expense)!)!
                EntertainmentLabel.text = String((EntertainmentPercentage*100)/totalIncome)
                EntertainmentLabel.text?.append("%")
                break
                
            case "Fuel"  :
                FuelPercentage = FuelPercentage + Int((data?.expense)!)!
                FuelLabel.text = String((FuelPercentage*100)/totalIncome)
                FuelLabel.text?.append("%")
                break
                
            case "Home"  :
                HomePercentage = HomePercentage + Int((data?.expense)!)!
                HomeLabel.text = String((HomePercentage*100)/totalIncome)
                HomeLabel.text?.append("%")
                break
                
            case "Other"  :
                OtherPercentage = OtherPercentage + Int((data?.expense)!)!
                OtherLabel.text = String((OtherPercentage*100)/totalIncome)
                OtherLabel.text?.append("%")
                break
                
            case "Shoping"  :
                ShopingPercentage = ShopingPercentage + Int((data?.expense)!)!
                ShopingLabel.text = String((ShopingPercentage*100)/totalIncome)
                ShopingLabel.text?.append("%")
                break
                
            case "Transport"  :
                TransportPercentage = TransportPercentage + Int((data?.expense)!)!
                TransportLabel.text = String((TransportPercentage*100)/totalIncome)
                TransportLabel.text?.append("%")
                break
                
            case "Travel"  :
                TravelingPercentage = TravelingPercentage + Int((data?.expense)!)!
                TravelingLabel.text = String((TravelingPercentage*100)/totalIncome)
                TravelingLabel.text?.append("%")
                break

            default :

                break

            }
            }else{}
        }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readExpenseData()
        readIncomeData()
        smallLabelSetup()
        print(Month[m])
        if(datas.count>0){
        totalExpense = 0
        for i in 0...datas.count-1{
            data = datas[i]
            print(data?.expense)
            totalExpense = totalExpense + Int((data?.expense)!)!
            print(totalExpense)
        }
        }else{
            print("EmptyData")
        }
        ExpenseLabel.text = "₹"
        ExpenseLabel.text?.append(String(totalExpense))
        
        if(incomeDatas.count>0){
            totalIncome = 0
            for i in 0...incomeDatas.count-1{
                incomeData = incomeDatas[i]
                print(incomeData?.expense)
                totalIncome = totalIncome + Int((incomeData?.expense)!)!
                print(totalIncome)
            }
        }else{
            print("EmptyData")
        }
        //totalIncome = 0
        IncomeLabel.text = "₹"
        IncomeLabel.text?.append(String(totalIncome))
        BalanceLabel.text = "Balance: ₹"
        BalanceLabel.text?.append(String(totalIncome - totalExpense))
        //IncomeLabel.text = "0"
    }
    
    @IBAction func monthTapped(_ sender: UITapGestureRecognizer) {
        let x = MonthLabel.text
        print(x as! String)
        for i in 0..<FullMonth.count{
            if FullMonth[i] == x{
                print(FullMonth[i])
                m = i+1
                if i == 11{
                    m = 0
                }
                break
            }
        }
        MonthLabel.text = FullMonth[m]
        smallLabelSetup()
        self.viewWillAppear(true)
        


    }
    
    func monthTaped() {
        let x = MonthLabel.text
        //print(x as! String)
        for i in 0..<FullMonth.count{
            if FullMonth[i] == x{
                print(FullMonth[i])
                m = i
                if i == 11{
                    m = 0
                }
                break
            }
        }
        
        HomeLabel.text="0%"
        FoodLabel.text="0%"
        ShopingLabel.text="0%"
        EntertainmentLabel.text="0%"
        SportsLabel.text="0%"
        BillsLabel.text="0%"
        TravelingLabel.text="0%"
        TransportLabel.text="0%"
        OtherLabel.text="0%"
        HealthLabel.text="0%"
        FamilyLabel.text="0%"
        FuelLabel.text="0%"
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        CatagoryImageTag = (sender.view?.tag)!
        print(CatagoryImageTag)
        performSegue(withIdentifier: "AddStoryBoard", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddStoryBoard"{
            let CategoryIden = segue.destination as! AddViewController
            CategoryIden.CategoryTag = self.CatagoryImageTag
        }
    }
    @IBAction func ImageLongTapped(_ sender: UILongPressGestureRecognizer){
        
        SportsTotal = 0
        HealthTotal = 0
        FamilyTotal = 0
        FoodTotal = 0
        BillsTotal = 0
        EntertainmentTotal = 0
        FuelTotal = 0
        HomeTotal = 0
        OtherTotal = 0
        ShopingTotal = 0
        TransportTotal = 0
        TravelingTotal = 0
        
        if(datas.count>0){
            if sender.state == .began{
            for i in 0...datas.count-1{
                data = datas[i]
                //print(data?.catagory)
                let index = data?.catagory
                //print(index)
                
                if(totalIncome != 0){
                    switch index {
                    case "Sports"  :
                        SportsTotal = SportsTotal + Int((data?.expense)!)!
                        BalanceLabel.text = String(SportsTotal)
                        break
                        
                    case "Health"  :
                        HealthTotal = HealthTotal + Int((data?.expense)!)!
                        BalanceLabel.text = String(HealthTotal)
                        break
                        
                    case "Family"  :
                        FamilyTotal = FamilyTotal + Int((data?.expense)!)!
                        BalanceLabel.text = String(FamilyTotal)
                        break
                        
                    case "Food"  :
                        FoodTotal = FoodTotal + Int((data?.expense)!)!
                        BalanceLabel.text = String(FoodTotal)
                        break
                        
                    case "Bills"  :
                        BillsTotal = BillsTotal + Int((data?.expense)!)!
                        BalanceLabel.text = String(BillsTotal)
                        break
                        
                    case "Entertainment"  :
                        EntertainmentTotal = EntertainmentTotal + Int((data?.expense)!)!
                        BalanceLabel.text = String(EntertainmentTotal)
                        break
                        
                    case "Fuel"  :
                        FuelTotal = FuelTotal + Int((data?.expense)!)!
                        BalanceLabel.text = String(FuelTotal)
                        break
                        
                    case "Home"  :
                        HomeTotal = HomeTotal + Int((data?.expense)!)!
                        BalanceLabel.text = String(HomeTotal)
                        break
                        
                    case "Other"  :
                        OtherTotal = OtherTotal + Int((data?.expense)!)!
                        BalanceLabel.text = String(OtherTotal)
                        break
                        
                    case "Shoping"  :
                        ShopingTotal = ShopingTotal + Int((data?.expense)!)!
                        BalanceLabel.text = String(ShopingTotal)
                        break
                        
                    case "Transport"  :
                        TransportTotal = TransportTotal + Int((data?.expense)!)!
                        BalanceLabel.text = String(TransportTotal)
                        break
                        
                    case "Travel"  :
                        TravelingTotal = TravelingTotal + Int((data?.expense)!)!
                        BalanceLabel.text = String(TravelingTotal)
                        break
                        
                    default :
                        
                        break
                        
                    }
                }else{}
                }
                }
            if sender.state == .ended{
                BalanceLabel.text = "Balance: ₹"
                BalanceLabel.text?.append(String(totalIncome - totalExpense))
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    }

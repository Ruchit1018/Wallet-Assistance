//
//  TransactionViewController.swift
//  tableView
//
//  Created by Smit Patel on 25/09/18.
//  Copyright © 2018 Smit Patel. All rights reserved.
//

import UIKit
import SQLite3

class TransactionViewController: UIViewController , UITableViewDelegate ,UITableViewDataSource{
    
    
    
    
    
    @IBOutlet weak var viewAmount: UILabel!
    
    @IBOutlet weak var viewCategary: UILabel!
    @IBOutlet weak var viewPlace: UILabel!
    @IBOutlet weak var viewDate: UILabel!
    @IBOutlet weak var upView: UIView!
    @IBOutlet weak var downView: UIView!
    @IBOutlet weak var viewType: UILabel!
    @IBOutlet weak var totalIncomeLabel: UILabel!
    
    @IBOutlet weak var totalExpenseLabel: UILabel!
    var datas = [Entry]()
    var data: Entry?
    //var convertedArray: [Date] = []
    var da: String?
    
    // let dateFormatter = DateFormatter()
    
    var datas1 = [ReadData]()
    var data1: ReadData?
    
    var incomeDatas = [ReadIncomeData]()
    var incomeData: ReadIncomeData?
    
    var totalExpense : Int = 0
    var totalIncome : Int = 0
    
    
    
    var db : OpaquePointer?
    var stmt : OpaquePointer?
    let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("WalletAssistance.sqlite")
    let Expenseicon: [UIImage] = [
        UIImage(named: "Sports")!,
        UIImage(named: "Transport")!,
        UIImage(named: "Health")!,
        UIImage(named: "Entertainment")!,
        UIImage(named: "Family")!,
        UIImage(named: "Food")!,
        UIImage(named: "Fuel")!,
        UIImage(named: "Shopping")!,
        UIImage(named: "Other")!,
        UIImage(named: "Bills")!,
        UIImage(named: "Home")!,
        UIImage(named: "Travel")!
        
    ]
    let Expenseiconlabel: [String] = ["Sports","Transport","Health","Entertainment","Family","Food","Fuel","Shopping","Other","Bills","Home","Travel"]
    
    let Incomeicon: [UIImage] = [
        UIImage(named: "business")!,
        UIImage(named: "extra income")!,
        UIImage(named: "gift")!,
        UIImage(named: "loan")!,
        UIImage(named: "salary")!
    ]
    let Incomeiconlabel: [String] = ["business","extra income","gift","loan","salary"]

    func readExpenseData(){
        datas.removeAll()
        let queryString = "SELECT * FROM Expense"
        print(queryString)
        
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
                
                guard let data1 = ReadData(id: String(Data_id), date: Date, expense: Ammount, catagory: Catagory, place: Place, latitude: Latitude,longitude: Longitude,Repeat: Repeat,remind: Remind, note: Note) else {
                    fatalError("Unable to instantiate Expense")
                }
                datas1 += [data1]
            }
        }
        else{
            let errmsg = String(cString: sqlite3_errmsg(db))
            print(errmsg)
            
        }
        
        
    }
    
    func readIncomeData(){
        incomeDatas.removeAll()
        
        let queryString = "SELECT * FROM Income"
        print(queryString)
        
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
                
                guard let incomeData = ReadIncomeData(id: String(Data_id), date: Date, expense: Ammount, catagory: Catagory, note: Note) else {
                    fatalError("Unable to instantiate Income")
                }
                incomeDatas += [incomeData]
            }
        }
        else{
            let errmsg = String(cString: sqlite3_errmsg(db))
            print(errmsg)
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        upView.layer.cornerRadius = 14
        downView.layer.cornerRadius = 14
        readValues()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        //readIncomeData()
        //readExpenseData()
        if(datas.count>0){
            totalExpense = 0
            for i in 0...datas.count-1{
                data = datas[i]
                print(data?.Amount)
                if(data?.Type1 == "Expense"){
                    totalExpense = totalExpense + Int((data?.Amount)!)!
                }
                if(data?.Type1 == "Income"){
                    totalIncome = totalIncome + Int((data?.Amount)!)!
                }
                print(totalExpense)
            }
        }else{
            print("EmptyData")
        }

//        if(incomeDatas.count>0){
//            totalIncome = 0
//            for i in 0...incomeDatas.count-1{
//                incomeData = incomeDatas[i]
//                print(incomeData?.expense)
//                totalIncome = totalIncome + Int((incomeData?.expense)!)!
//                print(totalIncome)
//            }
//        }else{
//            print("EmptyData")
//        }
        totalIncomeLabel.text = String(totalIncome)
        totalExpenseLabel.text = String(totalExpense)
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
//     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return datas.count
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EntryTableViewCell
        
        let entry = datas[indexPath.row]
        //da = dateFormatter.string(from: convertedArray[indexPath.row])
        
        //yourLabel.layer.cornerRadius = 5
        
        
        
        cell.imgIcon.image = UIImage(named: entry.Categary!)
        print(entry.Categary)
        cell.Date.text = entry.Date
        cell.Amount.text = entry.Amount
        cell.Place.text = entry.Place
        cell.Tp.text = entry.Type1
        cell.categary.text = entry.Categary
        
        if entry.Type1 == "Expense"
        {
            //cell.backgroundColor = UIColor.red // EXPENSE
            cell.Amount.text = "  -"
            cell.Amount.text?.append(entry.Amount!)
            cell.Amount.textColor = UIColor.red
        }
        else
        {
            //cell.backgroundColor = UIColor.green // INCOME
            cell.Amount.text = "  +"
            cell.Amount.text?.append(entry.Amount!)
            cell.Amount.textColor = UIColor.green
        }
        return cell
    }
    
    func readValues()
    {
        
        
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("WalletAssistance.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{
            
            print("Error opening database")
        }
        
        datas.removeAll()
        let queryString = "SELECT Date as \"date\",Amount as \"amount\",Place as \"place\",Category as \"Categary\",\"Expense\" as \"Type\" FROM Expense UNION SELECT Date as \"date\", Amount as \"amount\", \"\" as \"place\",Category as \"Category\",\"Income\" as \"Type\" from Income  order by Date DESC"
        print(queryString)
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) == SQLITE_OK{
            
            var Date: String?
            var Ammount: String?
            var Catagory: String?
            var Place : String?
            var Type: String?
            //traversing through all the records
            while(sqlite3_step(stmt) == SQLITE_ROW){
                
                Date = String(cString: sqlite3_column_text(stmt, 0))
                Ammount = String(cString: sqlite3_column_text(stmt, 1))
                Place = String(cString: sqlite3_column_text(stmt, 2))
                Catagory = String(cString: sqlite3_column_text(stmt, 3))
                Type = String(cString: sqlite3_column_text(stmt, 4))
                
                
                //adding values to list
                
                guard let data = Entry(Date: Date!, Amount: Ammount, Place: Place, Categary: Catagory, Type: Type)
                    else{
                        fatalError("Unable to Instantiate Expense")
                }
                
                //                guard let data = ReadData(id: String(Data_id), date: Date, expense: Ammount, catagory: Catagory, place: Place, latitude: Latitude,longitude: Longitude,Repeat: Repeat,remind: Remind, note: Note) else {
                //                    fatalError("Unable to instantiate Expense")
                //                }
                datas += [data]
                //print(datas)
            }
            
            
        }
        else{
            let errmsg = String(cString: sqlite3_errmsg(db))
            print(errmsg)
            
        }
        
        
        //let ready = convertedArray.sorted(by: { $0.compare($1) == .orderedDescending })
        //print(ready)
        /*
         let testArray = ["25 Jun, 2016", "30 Jun, 2016", "28 Jun, 2016", "2 Jul, 2016"]
         var convertedArray: [Date] = []
         
         var dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "dd MM, yyyy"// yyyy-MM-dd"
         
         for dat in testArray {
         let date = dateFormatter.date(from: dat)
         if let date = date {
         convertedArray.append(date)
         }
         }
         
         var ready = convertedArray.sorted(by: { $0.compare($1) == .orderedDescending })
         
         print(ready)
         */
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

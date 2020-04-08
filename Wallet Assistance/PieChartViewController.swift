//
//  PieChartViewController.swift
//  WalletAssistance
//
//  Created by Radadiya on 09/09/18.
//  Copyright © 2018 Radadiya. All rights reserved.
//

import UIKit
import Charts
import SQLite3

class PieChartViewController: UIViewController {

    
    @IBOutlet weak var PieChartView: PieChartView!
    var db : OpaquePointer?
    
    var totalIncome = 0.0
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
    
    var expenseList = [Expense]()
    var incomeList = [Income]()
    var CategeryTotal = [Double]()
    var numbersOfItems = [PieChartDataEntry]()
  //  var item = [PieChartDataEntry]()
    
    var itemvalues = PieChartDataEntry(value: 0)
    var itemvalues1 = PieChartDataEntry(value: 0)
    var itemvalues2 = PieChartDataEntry(value: 0)
    var itemvalues3 = PieChartDataEntry(value: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        var mainobj = ViewController()
        fetchIncomeData()
        fetchExpenseData()
        //PieChartView.chartDescription?.text = ""
     
        numbersOfItems.removeAll()

        for i in 0..<CategeryTotal.count {
            
            let categery = CategeryTotal[i]
            
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
            
            if (categery != 0.0)
            {
                print(totalIncome)
                itemvalues = PieChartDataEntry(value: 0)
                itemvalues.value = categery * 100 / 3400  //totalIncome
                switch i {
                case  0 :
                    itemvalues.label = "Sports"
                    break
                    
                case 1  :
                    itemvalues.label = "Health"
                    
                    break
                    
                case 2  :
                   itemvalues.label = "Family"
                    
                    break
                    
                case 3  :
                   itemvalues.label = "Food"
                    
                    break
                    
                case 4  :
                    itemvalues.label = "Bills"
                    break
                    
                case 5  :
                    itemvalues.label = "Entertainment"
                    
                    break
                    
                case 6  :
                    itemvalues.label = "Fuel"
                    
                    break
                    
                case 7  :
                    
                   itemvalues.label = "Home"
                    break
                    
                case 8  :
                    
                    itemvalues.label = "Other"
                    break
                    
                case 9  :
                    itemvalues.label = "Shoping"
                    break
                    
                case 10  :
                    itemvalues.label = "Transport"
                    
                    break
                    
                case 11  :
                   itemvalues.label = "Travel"
                    break
                    
                default :
                    
                    break
                }
                numbersOfItems.append(itemvalues)
                print(numbersOfItems)
            }
            
        }
        updateChartData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func updateChartData() {
        let chartDataSet = PieChartDataSet(values: numbersOfItems, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        print(chartData)
        let colors = [UIColor(named: "c1"),UIColor(named: "c2"),UIColor(named: "c3"),UIColor(named: "c4"),UIColor(named: "c5"),UIColor(named: "c6"),UIColor(named: "c7"),UIColor(named: "c8"),UIColor(named: "c9"),UIColor(named: "c10"),UIColor(named: "c11"),UIColor(named: "c12")]
        chartDataSet.colors = colors as! [NSUIColor]
        
        PieChartView.data = chartData
        
    }
    func DatabaseConnection()  {
        let fileUrl = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil ,create: false).appendingPathComponent("WalletAssistance.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{
            print("Error Opening database")
            return
        }
        
    }
    
    func fetchExpenseData()  {
        expenseList.removeAll()
        DatabaseConnection()
        var stmt : OpaquePointer?
        let selectquery = "SELECT Expense_Id,Date,Amount,Category,Place,Latitude,Longitude,Repeat,Remind,Note FROM Expense"
        
        if sqlite3_prepare(db, selectquery, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        var ExpenseDate: String?
        var Ammount: String?
        var Catagory: String?
        var Place : String?
        var Latitude: String?
        var Longitude: String?
        var Repeat: String?
        var Remind: String?
        var Note: String?
        
        let currentdate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        let d = formatter.string(from: currentdate)
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            let Data_id = sqlite3_column_int(stmt, 0)
            ExpenseDate = String(cString: sqlite3_column_text(stmt, 1))
            Ammount = String(cString: sqlite3_column_text(stmt, 2))
            Catagory = String(cString: sqlite3_column_text(stmt, 3))
            Place = String(cString: sqlite3_column_text(stmt, 4))
            Latitude = String(cString: sqlite3_column_text(stmt, 5))
            Longitude = String(cString: sqlite3_column_text(stmt, 6))
            Repeat = String(cString: sqlite3_column_text(stmt, 7))
            Remind = String(cString: sqlite3_column_text(stmt, 8))
            Note = String(cString: sqlite3_column_text(stmt, 9))
            if (ExpenseDate?.contains(d))!
            {
            //adding values to list
            
            guard let data = Expense(id: String(Data_id), date: ExpenseDate, expense: Ammount, catagory: Catagory, place: Place, latitude: Latitude,longitude: Longitude,Repeat: Repeat,remind: Remind, note: Note) else {
                fatalError("Unable to instantiate Expense")
            }
            expenseList += [data]
            }
        }
        print(expenseList.count)
        for i in 0...expenseList.count-1{
            let data = expenseList[i]
            
            let index = data.catagory
           
            if(totalIncome != 1000){
                switch index {
                case "Sports"  :
                    totalSports = totalSports + Double(data.expense!)!
                break
                
                case "Health"  :
                    totalHealth = totalHealth + Double(data.expense!)!
                
                break
                
                case "Family"  :
                    totalFamily = totalFamily + Double(data.expense!)!
               
                break
                
                case "Food"  :
                    totalFood = totalFood + Double(data.expense!)!
              
                break
                
                case "Bills"  :
                    totalBills = totalBills + Double(data.expense!)!
                    
                break
                
                case "Entertainment"  :
                    totalEntertainment = totalEntertainment + Double(data.expense!)!
                
                break
                
                case "Fuel"  :
                     totalFuel = totalFuel + Double(data.expense!)!
               
                break
                
                case "Home"  :
              
                     totalHome = totalHome + Double(data.expense!)!
                break
                
                case "Other"  :
               
                     totalHome = totalHome + Double(data.expense!)!
                break
                
                case "Shoping"  :
                    totalShoping = totalShoping + Double(data.expense!)!
                break
                
                case "Transport"  :
                     totalTransport = totalTransport + Double(data.expense!)!
               
                break
                
                case "Travel"  :
                     totalTravel = totalTravel + Double(data.expense!)!
               
                break
                
                default :
                
                break
                }
            }
        }

        CategeryTotal.append(totalSports)
        CategeryTotal.append(totalHealth)
        CategeryTotal.append(totalFamily)
        CategeryTotal.append(totalFood)
        CategeryTotal.append(totalBills)
        CategeryTotal.append(totalEntertainment)
        CategeryTotal.append(totalFuel)
        CategeryTotal.append(totalHome)
        CategeryTotal.append(totalOther)
        CategeryTotal.append(totalShoping)
        CategeryTotal.append(totalTransport)
        CategeryTotal.append(totalTravel)

        // print(expenseList.count)
     
    }
    func fetchIncomeData()  {
        incomeList.removeAll()
        DatabaseConnection()
        var stmt : OpaquePointer?
        let selectquery = "SELECT Income_Id,Date,Amount,Category,Note FROM Income "
        
        if sqlite3_prepare(db, selectquery, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        var IncomeDate: String?
        var Ammount: String?
        var Catagory: String?
        var Note: String?
        
        
        let currentdate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        let d = formatter.string(from: currentdate)
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            
            let Data_id = sqlite3_column_int(stmt, 0)
            IncomeDate = String(cString: sqlite3_column_text(stmt, 1))
            Ammount = String(cString: sqlite3_column_text(stmt, 2))
            Catagory = String(cString: sqlite3_column_text(stmt, 3))
            Note = String(cString: sqlite3_column_text(stmt, 4))
            
            if (IncomeDate?.contains(d))!
            {
                guard let incomeData = Income(id: String(Data_id), date: IncomeDate, Amount: Ammount, catagory: Catagory, note: Note) else {
                    fatalError("Unable to instantiate Income")
            }
            incomeList += [incomeData]
            }
        }
        
        for i in 0...incomeList.count-1{
            let data = incomeList[i]
            //print(data?.catagory)
            let index = data.catagory
            //print(index)
//            if(totalIncome == 0){
                switch index {
                case "business"  :
                    totalIncome = totalIncome + Double((data.Amount)!)!
                    break
                case "extraincome":
                    totalIncome = totalIncome + Double((data.Amount)!)!
                    break
                case "gift":
                    totalIncome = totalIncome + Double((data.Amount)!)!
                    break
                case "loan":
                    totalIncome = totalIncome + Double((data.Amount)!)!
                    break
                case "salary":
                    totalIncome = totalIncome + Double((data.Amount)!)!
                    break
                default :
                    break
                }
//            }
        }
        // print(incomeList.count)
        
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



import UIKit
import SwiftCharts
import SQLite3
class BarChartViewController: UIViewController {

   // @IBOutlet weak var barChartView: BarChartView!
    var db : OpaquePointer?
    var expenseList = [Expense]()
    var expenses = [ExpenseData]()
    var incomeList = [Income]()
    var chart : BarsChart!
    var DecMonthexpenseList : Double = 0.0
    var NovMonthexpenseList : Double = 0.0
    var OctMonthexpenseList : Double = 0.0
    var SepMonthexpenseList : Double = 0.0
    var AugMonthexpenseList : Double = 0.0
    var JulMonthexpenseList : Double = 0.0
    var JunMonthexpenseList : Double = 0.0
    var MayMonthexpenseList : Double = 0.0
    var AprMonthexpenseList : Double = 0.0
    var MarMonthexpenseList : Double = 0.0
    var FebMonthexpenseList : Double = 0.0
    var JanMonthexpenseList : Double = 0.0
    var MonthwiseAmount = [Double]()
     var totalIncome = 0.0
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var month : String = ""
    var expenseAmount : Double = 0.0
    var chartView: BarsChart!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        //fetchIncomeData()
        fetchExpenseData()
        dataInsert()
        var max = 0
        for i in 0..<MonthwiseAmount.count
        {
            if (max < Int(MonthwiseAmount[i]))
            {
                max = Int(MonthwiseAmount[i])
            }
        }
        let total = String(max)
        
        var amount = Int(total.prefix(1))
        amount = amount! + 1
        var newamount = String(amount!)
        print(total.count)
        for i in 0..<total.count-1
        {
                newamount.append("0")
        }
        var finalamount = Int(newamount)!/10
        print(finalamount)
        let chartConfig = BarsChartConfig(valsAxisConfig: ChartAxisConfig(from: 0, to: Double(80000), by: Double(10000)))
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        var index : Int?
        var chartdata = [(String(month),Double(expenseAmount))]
        for i in 0..<MonthwiseAmount.count {
            expenseAmount = MonthwiseAmount[i]
            if(expenseAmount != 0.0)
            {
                index = i
            }
              //  chartdata.append((String(month),Double(expenseAmount)))
        }
        
        for i in (index!-3)..<MonthwiseAmount.count
        {
            month = months[i]
            expenseAmount = MonthwiseAmount[i]
            chartdata.append((String(month),Double(expenseAmount)))
        }
        chart = BarsChart(frame: frame, chartConfig: chartConfig, xTitle: "Month", yTitle: "Amount", bars: chartdata, color: UIColor.orange, barWidth: 15)
        self.view.addSubview(chart.view)
        self.chartView = chart
        
       
      
        self.view.backgroundColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchExpenseData()  {
        expenseList.removeAll()
        DatabaseConnection()
        var stmt : OpaquePointer?
        let selectquery = "SELECT Expense_Id,Date,Amount,Category,Place,Latitude,Longitude,Repeat,Remind,Note FROM Expense order by date(Date) ASC"
        
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
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
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
            //adding values to list
            
            guard let data = Expense(id: String(Data_id), date: ExpenseDate, expense: Ammount, catagory: Catagory, place: Place, latitude: Latitude,longitude: Longitude,Repeat: Repeat,remind: Remind, note: Note) else {
                fatalError("Unable to instantiate Expense")
            }
            expenseList += [data]
            
        }
        
        for i in 0..<expenseList.count{
            let data = expenseList[i]
            //print(data?.catagory)
            var index : String?
            let Date = data.date
            
            
            if(Date?.contains("Jan"))!
            {
                index = "Jan"
            }
            else if(Date?.contains("Feb"))!
            {
                index = "Feb"
            }
            else if(Date?.contains("Mar"))!
            {
                index = "Mar"
            }
            else if(Date?.contains("Apr"))!
            {
                index = "Apr"
            }
            else if(Date?.contains("May"))!
            {
                index = "May"
            }
            else if(Date?.contains("Jun"))!
            {
                index = "Jun"
            }
            else if(Date?.contains("Jul"))!
            {
                index = "Jul"
            }
            else if(Date?.contains("Aug"))!
            {
                index = "Aug"
            }
            else if(Date?.contains("Sep"))!
            {
                index = "Sep"
            }
            else if(Date?.contains("Oct"))!
            {
                index = "Oct"
            }
            else if(Date?.contains("Nov"))!
            {
                index = "Nov"
            }
            else if(Date?.contains("Dec"))!
            {
                index = "Dec"
            }
            //print(index)
            
            switch index {
            case "Jan"  :
                JanMonthexpenseList = JanMonthexpenseList +  Double((data.expense)!)!
                break
            case "Feb":
                FebMonthexpenseList = FebMonthexpenseList +  Double((data.expense)!)!
                break
            case "Mar":
                MarMonthexpenseList = MarMonthexpenseList +  Double((data.expense)!)!
                break
            case "Apr":
                AprMonthexpenseList = AprMonthexpenseList +  Double((data.expense)!)!
                break
            case "May":
                MayMonthexpenseList = MayMonthexpenseList +  Double((data.expense)!)!
                break
            case "Jun":
                JunMonthexpenseList = JunMonthexpenseList +  Double((data.expense)!)!
                break
            case "Jul":
                JulMonthexpenseList = JulMonthexpenseList +  Double((data.expense)!)!
                break
            case "Aug":
                AugMonthexpenseList = AugMonthexpenseList +  Double((data.expense)!)!
                break
            case "Sep":
                SepMonthexpenseList = SepMonthexpenseList +  Double((data.expense)!)!
                break
            case "Oct":
                OctMonthexpenseList = OctMonthexpenseList +  Double((data.expense)!)!
                break
            case "Nov":
                NovMonthexpenseList = NovMonthexpenseList +  Double((data.expense)!)!
                break
            case "Dec":
                DecMonthexpenseList = DecMonthexpenseList +  Double((data.expense)!)!
                break
            default :
                break
            }
        }
        
        MonthwiseAmount.append(JanMonthexpenseList)
        MonthwiseAmount.append(FebMonthexpenseList)
        MonthwiseAmount.append(MarMonthexpenseList)
        MonthwiseAmount.append(AprMonthexpenseList)
        MonthwiseAmount.append(MayMonthexpenseList)
        MonthwiseAmount.append(JunMonthexpenseList)
        MonthwiseAmount.append(JulMonthexpenseList)
        MonthwiseAmount.append(AugMonthexpenseList)
        MonthwiseAmount.append(SepMonthexpenseList)
        MonthwiseAmount.append(OctMonthexpenseList)
        MonthwiseAmount.append(NovMonthexpenseList)
        MonthwiseAmount.append(DecMonthexpenseList)
        
        // print(expenseList.count)
        
    }
    func dataInsert() {
        
        
        
        for i in 0..<MonthwiseAmount.count {
            let month = months[i]
            let expenseAmount = MonthwiseAmount[i]
            if(expenseAmount != 0.0)
            {
                let expense = ExpenseData(month: month, amount: expenseAmount)
                expenses.append(expense)
            }
        }
        
        
    }
    
    func DatabaseConnection()  {
        let fileUrl = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil ,create: false).appendingPathComponent("WalletAssistance.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{
            print("Error Opening database")
            return
        }
        
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
        
        for i in 0..<incomeList.count{
            let data = incomeList[i]
            //print(data?.catagory)
            let index = data.catagory
            //print(index)
            if(totalIncome != 0){
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
            }
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



import UIKit
import GoogleMaps
import GooglePlaces
import SQLite3


class AddViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource{
    
    //var obj = ExpenseViewController()
    
    // MARK: DECLERATION
    @IBOutlet weak var lbdate: UIButton!
    @IBOutlet weak var sr_icon_outlet: UIImageView!
  
    @IBOutlet weak var slideview: UIView!
    @IBOutlet weak var selector: UISegmentedControl!
    @IBOutlet weak var btnmainIcon: UIButton!
    @IBOutlet weak var txtamount: UITextField!
    @IBOutlet weak var lbreminder: UILabel!
    @IBOutlet weak var lbrepeat: UILabel!
   
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var txtNote: UITextView!
    
    @IBOutlet weak var set_reminder_outlet: UIButton!
    @IBOutlet weak var lbsearch: UIButton!
    @IBOutlet weak var set_Repeat: UIButton!
    
    @IBOutlet weak var search_icon: UIImageView!
    @IBOutlet weak var repeat_icon: UIImageView!
    @IBOutlet weak var remind_Icon: UIImageView!
    
    private var datePicker : UIDatePicker!
    var isslideViewOpen : Bool = true
    var db : OpaquePointer?
    var stmt : OpaquePointer?
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    var CategoryTag : Int = 1
    
    // FOR DATABASE ---Date,Amount,Category,Lalitude,longitude,Note)
    var d : String?
    var amount : String?
    var catagory : String?
    var place : String?
    var latitude : String?
    var longitude : String?
    var repeatTran : String = "Never"
    var remind : String = "Never"
    var note : String?
    var count : Int = 0
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
    let ExpenseiconWhite: [UIImage] = [
        UIImage(named: "Sports1")!,
        UIImage(named: "Transport1")!,
        UIImage(named: "Health1")!,
        UIImage(named: "Entertainment1")!,
        UIImage(named: "Family1")!,
        UIImage(named: "Food1")!,
        UIImage(named: "Fuel1")!,
        UIImage(named: "Shopping1")!,
        UIImage(named: "Other1")!,
        UIImage(named: "Bills1")!,
        UIImage(named: "Home1")!,
        UIImage(named: "Travel1")!
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
    

    //MARK: Main Icon Tapped
    @IBAction func tap(_ sender: UIButton) {
 
        
        if !isslideViewOpen{
            isslideViewOpen = true /// 1
            self.slideview!.isHidden = false
            UIView.setAnimationDuration(1)
            UIView.setAnimationDelegate(self)
            UIView.commitAnimations()
        }
        else
        {
            
            isslideViewOpen = false /// 0
            self.slideview!.isHidden = true
            UIView.setAnimationDuration(1)
            UIView.setAnimationDelegate(self)
            UIView.commitAnimations()
        }
    }
    // Date Picker Button Action
    @IBAction func Datep(_ sender: UIButton) {
        datePickerTapped()
    }
    
    // Reminader Button Action
    @IBAction func reminder(_ sender: UIButton) {
        let values = ["Never", "On a transcation date", "1 day before", "2 days before", "3 days before", "4 days before", "5 days before", "6 days before", "7 days before"]
        DPPickerManager.shared.showPicker(title: "Reminder Time", selected: "Value 1", strings: values) { (value, index, cancel) in
            if !cancel {
                // TODO: you code here
                self.lbreminder.isHidden=false
                self.lbreminder.text=value
                debugPrint(value as Any)
                
                self.remind = value!
//                if(self.repeatTran == nil){
//                    self.repeatTran = "Never"
//                }
            }
        }
    }
    
    // Repeat button action
    @IBAction func repeatp(_ sender: UIButton) {
        let values = ["Never", "Every Day", "Every 2 days", "Every week", "Every 2 weeks", "Every month", "Every 2 months", "Every 6 months", "Every year"]
        DPPickerManager.shared.showPicker(title: "Choose Your Repeat Period", selected: "Value 1", strings: values) { (value, index, cancel) in
            if !cancel {
                // TODO: you code here
                if (value == "Never")
                {
                    self.lbrepeat.text = value
                    print("is Never")
                }
                else
                {
                    self.sr_icon_outlet.isHidden=false
                    self.set_reminder_outlet.isHidden=false
                    self.lbrepeat.isHidden=false
                    self.lbrepeat.text=value
                }
                print(value as Any)
                self.repeatTran = value!
            }
        }
    }
    
    
    // Place Search Action
    @IBAction func btnsearch(_ sender: Any) {
        
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self as! GMSAutocompleteViewControllerDelegate
        UISearchBar.appearance().setTextColor(color: UIColor.black)
        self.present(autoCompleteController,animated: true,completion: nil)
        
        
    }
    // MARK: SEGMENTED SELECTOR
    @IBAction func selector(_ sender: UISegmentedControl) {
        
        switch selector.selectedSegmentIndex
        {
        case 0:
            count = 0
            
            lbsearch.isHidden = false
            set_Repeat.isHidden = false
            
            search_icon.isHidden = false
            
            repeat_icon.isHidden = false
            collectionView.reloadData()
        case 1:
            count = 1
            
            set_reminder_outlet.isHidden = true
            lbsearch.isHidden = true
            set_Repeat.isHidden = true
            
            search_icon.isHidden = true
            remind_Icon.isHidden = true
            repeat_icon.isHidden = true
            
            collectionView.reloadData()
        default:
            print("NOT SELECTED")
            break
        }
        
    }
    
    
    //MARK: Collection View Logic
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(count)
        if count == 0
        {
            return Expenseicon.count
        }
        else
        {
            return Incomeicon.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! iconCollectionViewCell
        
        if count == 0
        {
            cell.imgIcon.image = Expenseicon[indexPath.item]
            cell.lbIcon.text = Expenseiconlabel[indexPath.item]
        }
        else
        {
            cell.imgIcon.image = Incomeicon[indexPath.item]
            cell.lbIcon.text = Incomeiconlabel[indexPath.item]
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if count == 0
        {
            btnmainIcon.setBackgroundImage(ExpenseiconWhite[indexPath.item], for: .normal)
             self.catagory = Expenseiconlabel[indexPath.item]
            slideview.isHidden = true
            isslideViewOpen = false
        }
        else
        {
            btnmainIcon.setBackgroundImage(Incomeicon[indexPath.item], for: .normal)
            self.catagory = Incomeiconlabel[indexPath.item]
            slideview.isHidden = true
            isslideViewOpen = false
        }
        
    }
    
    func setDefaultCategory(){
        print(CategoryTag)
        switch CategoryTag {
        case 1  :
            btnmainIcon.setBackgroundImage(ExpenseiconWhite[CategoryTag-1], for: .normal)
            self.catagory = Expenseiconlabel[CategoryTag-1]
            break
            
        case 2  :
            btnmainIcon.setBackgroundImage(ExpenseiconWhite[CategoryTag-1], for: .normal)
            self.catagory = Expenseiconlabel[CategoryTag-1]
            break
        
        case 3  :
            btnmainIcon.setBackgroundImage(ExpenseiconWhite[CategoryTag-1], for: .normal)
            self.catagory = Expenseiconlabel[CategoryTag-1]
            break
            
        case 4  :
            btnmainIcon.setBackgroundImage(ExpenseiconWhite[CategoryTag-1], for: .normal)
            self.catagory = Expenseiconlabel[CategoryTag-1]
            break
            
        case 5  :
            btnmainIcon.setBackgroundImage(ExpenseiconWhite[CategoryTag-1], for: .normal)
            self.catagory = Expenseiconlabel[CategoryTag-1]
            break
            
        case 6  :
            btnmainIcon.setBackgroundImage(ExpenseiconWhite[CategoryTag-1], for: .normal)
            self.catagory = Expenseiconlabel[CategoryTag-1]
            break
        
        case 7  :
            btnmainIcon.setBackgroundImage(ExpenseiconWhite[CategoryTag-1], for: .normal)
            self.catagory = Expenseiconlabel[CategoryTag-1]
            break
            
        case 8  :
            btnmainIcon.setBackgroundImage(ExpenseiconWhite[CategoryTag-1], for: .normal)
            self.catagory = Expenseiconlabel[CategoryTag-1]
            break
        case 9  :
            btnmainIcon.setBackgroundImage(ExpenseiconWhite[CategoryTag-1], for: .normal)
            self.catagory = Expenseiconlabel[CategoryTag-1]
            break
            
        case 10  :
            btnmainIcon.setBackgroundImage(ExpenseiconWhite[CategoryTag-1], for: .normal)
            self.catagory = Expenseiconlabel[CategoryTag-1]
            break
            
        case 11  :
            btnmainIcon.setBackgroundImage(ExpenseiconWhite[CategoryTag-1], for: .normal)
            self.catagory = Expenseiconlabel[CategoryTag-1]
            break
            
        case 12  :
            btnmainIcon.setBackgroundImage(ExpenseiconWhite[CategoryTag-1], for: .normal)
            self.catagory = Expenseiconlabel[CategoryTag-1]
            break
        default :
            
            break
            
        }
    }
    
//    @IBAction func TextNoteTapped(_ sender: UITapGestureRecognizer) {
//        if txtNote.text == "Write a note or create a #hashtag"{
//        txtNote.text = ""
//        }
//    }
    
    // MARK: Databse Entry
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(AddViewController.TextNoteTapped(_:)))
//
//        txtNote.addGestureRecognizer(tapGesture1)
//        txtNote.isUserInteractionEnabled = true

        setDefaultCategory()
        if CategoryTag != nil{
        isslideViewOpen = false
        self.slideview!.isHidden = true
        }
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("WalletAssistance.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{
           
            print("Error opening database")
        }
        
        let createTable = "CREATE TABLE IF NOT EXISTS Expense (Expense_Id INTEGER PRIMARY KEY AUTOINCREMENT, Date TEXT, Amount TEXT, Category TEXT,Place TEXT, Latitude TEXT, Longitude TEXT, Repeat TEXT, Remind TEXT, Note TEXT)"
        
        let createTable1 = "CREATE TABLE IF NOT EXISTS Income (Income_Id INTEGER PRIMARY KEY AUTOINCREMENT, Date TEXT, Amount TEXT, Category TEXT, Note TEXT)"
        
        
        if sqlite3_exec(db, createTable, nil, nil, nil) != SQLITE_OK{
            print("Error crearing table")
            return
        }
        else
        {
            print(fileUrl.path)
            print("Expense Table Created")
        }
        if sqlite3_exec(db, createTable1, nil, nil, nil) != SQLITE_OK{
            print("Error crearing table")
            return
        }
        else
        {
            print(fileUrl.path)
            print("Income Table Created")
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //Alert Message
    func displayAlertMessage(messageToDisplay: String)
    {
        let alertController = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    // MARK:Database Insert
    @IBAction func addEntry(_ sender: Any) {
        
        self.amount = txtamount.text
        self.note = txtNote.text
        print(self.note)
        
        if(self.amount == ""){
            //print("null")
            displayAlertMessage(messageToDisplay: "Plaese Enter Ammount of Expense")
            return
        }
        if(Int(self.amount!)! < 1){
            //print("null")
            displayAlertMessage(messageToDisplay: "Plaese Enter Valid Ammount of Expense")
            return
        }
        if(self.d == nil){
            //print("null")
            displayAlertMessage(messageToDisplay: "Plaese Enter Date of Expense")
            return
        }
        if(self.note == "Write a note or create a #hashtag"){
            //print("null")
            displayAlertMessage(messageToDisplay: "Plaese Enter Valid Note For Expense")
            return
        }
        if(count == 0){
        if(self.place == nil){
            //print("null")
            displayAlertMessage(messageToDisplay: "Plaese Enter Place of Expense")
            return
        }
        }
        
        if count == 0
        {
            let insert = "INSERT INTO Expense (Date,Amount,Category,Place,Latitude,Longitude,Repeat,Remind,Note) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
            
            if sqlite3_prepare(db, insert, -1, &stmt, nil) != SQLITE_OK{
                print("Error binding query")
            }
            
            if sqlite3_bind_text(stmt, 1, self.d, -1, SQLITE_TRANSIENT) != SQLITE_OK{  //Date
            }
            if sqlite3_bind_text(stmt, 2, self.amount, -1, SQLITE_TRANSIENT) != SQLITE_OK{ // Amount
            }
            if sqlite3_bind_text(stmt, 3, self.catagory, -1, SQLITE_TRANSIENT) != SQLITE_OK{ // Categary
            }
            if sqlite3_bind_text(stmt, 4, self.place, -1, SQLITE_TRANSIENT) != SQLITE_OK{ // Place
            }
            if sqlite3_bind_text(stmt, 5, self.latitude, -1, SQLITE_TRANSIENT) != SQLITE_OK{ // Latitude
            }
            if sqlite3_bind_text(stmt, 6, self.longitude, -1, SQLITE_TRANSIENT) != SQLITE_OK{ // Lognitude
            }
            if sqlite3_bind_text(stmt, 7, self.repeatTran, -1, SQLITE_TRANSIENT) != SQLITE_OK{ // Repeat
            }
            if sqlite3_bind_text(stmt, 8, self.remind, -1, SQLITE_TRANSIENT) != SQLITE_OK{ // Remind
            }
            if sqlite3_bind_text(stmt, 9, self.note, -1, SQLITE_TRANSIENT) != SQLITE_OK{ // Note
            }
            if sqlite3_step(stmt) == SQLITE_DONE
            {
                //displayAlertMessage(messageToDisplay: "Employee Saved Successfully")
                print("Expense Data Saved Successfully")
                self.navigationController?.popViewController(animated: true)
            }
            else{
                let errmsg = String(cString: sqlite3_errmsg(db))
                print(errmsg)
            }
        }
        else
        {
            let insert = "INSERT INTO Income (Date,Amount,Category,Note) VALUES (?, ?, ?, ?)"
            
            if sqlite3_prepare(db, insert, -1, &stmt, nil) != SQLITE_OK{
                print("Error binding query")
            }
            
            if sqlite3_bind_text(stmt, 1, self.d, -1, SQLITE_TRANSIENT) != SQLITE_OK{  //Date
            }
            if sqlite3_bind_text(stmt, 2, self.amount, -1, SQLITE_TRANSIENT) != SQLITE_OK{ // Amount
            }
            if sqlite3_bind_text(stmt, 3, self.catagory, -1, SQLITE_TRANSIENT) != SQLITE_OK{ // Categary
            }
            if sqlite3_bind_text(stmt, 4, self.note, -1, SQLITE_TRANSIENT) != SQLITE_OK{ // Note
            }
            if sqlite3_step(stmt) == SQLITE_DONE
            {
                //displayAlertMessage(messageToDisplay: "Employee Saved Successfully")
                print("Income Data Saved Successfully")
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        print(self.d)
        print(self.amount)
        print(self.catagory)
        print(self.latitude)
        print(self.longitude)
        print(self.repeatTran)
        print(self.remind)
        print(self.note)
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: DATE PICKER
    func datePickerTapped() {
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.month = -3
        let threeMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        
        let datePicker = DatePickerDialog(textColor: .blue,
                                          buttonColor: .blue,
                                          font: UIFont.boldSystemFont(ofSize: 17),
                                          showCancelButton: true)
        datePicker.show("DatePickerDialog",
                        doneButtonTitle: "Done",
                        cancelButtonTitle: "Cancel",
                        minimumDate: threeMonthAgo,
                        maximumDate: currentDate,
                        datePickerMode: .date) { (date) in
                            if let dt = date {
                                let formatter = DateFormatter()
                                formatter.dateFormat = "dd-MMM-yy"
                                self.d = formatter.string(from: dt)
                                print(self.d)
                                self.lbdate.setTitle(formatter.string(from: dt), for: .normal)

                            }
        }
    }
    
}// End Of ViewController


//MARK: FOR SEARCHING PLACE
extension AddViewController: GMSAutocompleteViewControllerDelegate
{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        lbsearch.setTitle(place.name, for: .normal)
        print("Whole String ::\(place)")
        self.place = String(place.name)
        self.latitude = String (place.coordinate.latitude)
        self.longitude = String (place.coordinate.longitude)
        print(place.coordinate.latitude)
        print(place.coordinate.longitude)
        self.dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("error \(error)")
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

public extension UISearchBar
{
    public func setTextColor(color: UIColor)
    {
        // MARK: Suggest Places
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField    else {
            return
        }
        tf.textColor = color
    }
}



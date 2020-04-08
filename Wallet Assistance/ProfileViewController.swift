//
//  ProfileViewController.swift
//  Wallet Assistance
//
//  Created by Arpit on 16/09/18.
//  Copyright © 2018 Arpit. All rights reserved.
//

import UIKit
import GoogleSignIn
import SQLite3

class ProfileViewController: UIViewController {

    
    //PDF
    
    var datas = [Entry]()
    var tableData = ""
    let defaultRowHeight  = CGFloat(23.0)
    let defaultColumnWidth = CGFloat(150.0)
    let numberOfRowsPerPage = 50
    let topMargin = CGFloat(40.0)
    let leftMargin = CGFloat(20.0)
    let rightMargin = CGFloat(20.0)
    let bottomMargin = CGFloat (40.0)
    let textInset = CGFloat(5.0)
    let verticalPadding = CGFloat (10.0)
    
    
    //PDF
    

    @IBAction func ExportPDF(_ sender: Any) {
        readValues()
        createPDF()
    }
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    var db : OpaquePointer?
    var stmt : OpaquePointer?
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    var userDatas = [UserData]()
    var Userdata: UserData?
    var img : String?
    
    @IBAction func signOutButton(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        userLogin = false
        UserDefaults.standard.set(false, forKey: "userLogin")
        UserDefaults.standard.synchronize()
        googleButton.isHidden = false
        navigationController?.popToRootViewController(animated: true)
    }
    
    func profileSetup(){
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("WalletAssistance.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{
            
            print("Error opening database")
        }
        
        userDatas.removeAll()
        let queryString = "SELECT * FROM User"
        print(queryString)
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) == SQLITE_OK{
            var User_name: String?
            var User_Surname: String?
            var User_Email: String?
            var User_Img : String?
            //traversing through all the records
            while(sqlite3_step(stmt) == SQLITE_ROW){
                let User_id = sqlite3_column_int(stmt, 0)
                User_name = String(cString: sqlite3_column_text(stmt, 1))
                User_Surname = String(cString: sqlite3_column_text(stmt, 2))
                User_Email = String(cString: sqlite3_column_text(stmt, 3))
                User_Img = String(cString: sqlite3_column_text(stmt, 4))
                
                //adding values to list
                
                guard let userData = UserData(id: String(User_id), User_name: User_name, User_Surname: User_Surname, User_Email: User_Email, User_Img: User_Img) else {
                    fatalError("Unable to instantiate Expense")
                }
                userDatas += [userData]
            }
        }
        else{
            let errmsg = String(cString: sqlite3_errmsg(db))
            print(errmsg)
            
        }
        for i in 0...userDatas.count-1{
            Userdata = userDatas[i]
            userEmail.text = Userdata?.User_Email
            userName.text = Userdata?.User_name
            userName.text?.append(" ")
            userName.text?.append((Userdata?.User_Surname)!)
            img = "https://lh4.googleusercontent.com/"
            img?.append((Userdata?.User_Img)!)
            //img = Userdata?.User_Img
            let imgUrl = URL(string: img!)
            if let data = try? Data(contentsOf: imgUrl!)
            {
                let image: UIImage = UIImage(data: data)!
                profileImageView.image = image
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileSetup()
        // Do any additional setup after loading the view.
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
//        userEmail.text = GIDSignIn.sharedInstance()?.currentUser.profile.email
//        userName.text = GIDSignIn.sharedInstance()?.currentUser.profile.givenName
//        userName.text?.append(" ")
//        userName.text?.append((GIDSignIn.sharedInstance()?.currentUser.profile.familyName)!)
//        let img = GIDSignIn.sharedInstance()?.currentUser.profile.imageURL(withDimension: 120)
//        print(img)
//        if let data = try? Data(contentsOf: img!)
//        {
//            let image: UIImage = UIImage(data: data)!
//            profileImageView.image = image
//        }
        //guard let data:NSData = NSData(contentsOf: img!) else {}
        //profileImageView.image = UIImage.animatedImage(with: data, duration: 2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func createPDF() {
        var html = "<b><br/><br/><center><h1>Transcation</h1></b> <br/><br/><br><table border=1><tr><th>Sr No.</th><th>DATE</th><th>AMOUNT</th><th>LOCATION</th><th>CATEGERY</th><th>TYPE</th></tr>"
        for i in 0..<datas.count
        {
            let data = datas[i]
            let srno = i + 1
            var  subtableData = tableData +  "<tr><td>" + String(srno) +  "</td><td>"
            tableData = subtableData + (data.Date!) + "</td><td>" + (data.Amount!) + "</td><td>" + (data.Place!) + "</td><td>" + (data.Categary!) + "</td><td>" + (data.Type1!) + "</td></tr>"
        }
        
        html = html + tableData
        
        let fmt = UIMarkupTextPrintFormatter(markupText: html)
        
        // 2. Assign print formatter to UIPrintPageRenderer
        
        let render = UIPrintPageRenderer()
        render.addPrintFormatter(fmt, startingAtPageAt: 0)
        
        // 3. Assign paperRect and printableRect
        
        let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
        let printable = page.insetBy(dx: 0, dy: 0)
        
        render.setValue(NSValue(cgRect: page), forKey: "paperRect")
        render.setValue(NSValue(cgRect: printable), forKey: "printableRect")
        
        // 4. Create PDF context and draw
        
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)
        
        for i in 1...render.numberOfPages {
            UIGraphicsBeginPDFPage();
            let bounds = UIGraphicsGetPDFContextBounds()
            render.drawPage(at: i - 1, in: bounds)
        }
        
        UIGraphicsEndPDFContext();
        
        // 5. Save PDF file
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        pdfData.write(toFile: "\(documentsPath)/Transcation.pdf", atomically: true)
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
            }
        }
        else{
            let errmsg = String(cString: sqlite3_errmsg(db))
            print(errmsg)
            
        }
    }

}

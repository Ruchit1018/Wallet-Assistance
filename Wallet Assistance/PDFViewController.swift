//
//  PDFViewController.swift
//  WalletAssistance
//
//  Created by Radadiya on 23/09/18.
//  Copyright © 2018 Radadiya. All rights reserved.
//

import UIKit
import SQLite3

class PDFViewController: UIViewController {

    var db : OpaquePointer?
    var stmt : OpaquePointer?
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readValues()
        createPDF()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        let queryString = "SELECT Date as \"date\",Amount as \"amount\",Place as \"place\",Category as \"Categary\",\"Expense\" as \"Type\" FROM Expense UNION SELECT Date as \"date\", Amount as \"amount\", \"---\" as \"place\",Category as \"Category\",\"Income\" as \"Type\" from Income  order by date DESC"
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

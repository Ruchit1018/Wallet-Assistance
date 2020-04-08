//
//  Entry.swift
//  tableView
//
//  Created by Smit Patel on 22/09/18.
//  Copyright © 2018 Smit Patel. All rights reserved.
//

import Foundation

class Entry{
//    let createTable = "CREATE TABLE IF NOT EXISTS Expense (Expense_Id INTEGER PRIMARY KEY AUTOINCREMENT, Date TEXT, Amount TEXT, Category TEXT, Lalitude TEXT, Longitude TEXT, Repeat TEXT, Remind TEXT, Note TEXT)"
    
    var Date:String?
    var Amount:String?
    var Place:String?
    var Categary:String?
    var Type1 : String?

    
    init?(Date:String,Amount:String?,Place:String?,Categary:String?,Type:String?)
    {
        self.Date = Date
        self.Amount = Amount
        self.Place = Place
        self.Categary = Categary
        self.Type1 = Type
       
    }
}

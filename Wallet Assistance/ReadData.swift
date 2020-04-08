//
//  Data.swift
//  Wallet Assistance
//
//  Created by Arpit on 22/09/18.
//  Copyright © 2018 Arpit. All rights reserved.
//

import UIKit

class ReadData{
    
    //MARK: Properties
    
    var id: String?
    var date: String?
    var expense: String?
    var catagory: String?
    var place : String?
    var latitude: String?
    var longitude: String?
    var Repeat: String?
    var remind: String?
    var note: String?
    
    //MARK: Initialization
    
    init?(id: String?, date: String?, expense: String?, catagory: String?,place: String?, latitude: String?, longitude: String?, Repeat: String?, remind: String?, note: String?) {
        
        self.id = id
        self.date = date
        self.expense = expense
        self.catagory = catagory
        self.place = place
        self.latitude = latitude
        self.longitude = longitude
        self.Repeat = Repeat
        self.remind = remind
        self.note = note
    }
    
    
}


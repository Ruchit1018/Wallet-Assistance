//
//  ReadIncomeData.swift
//  Wallet Assistance
//
//  Created by Arpit on 22/09/18.
//  Copyright © 2018 Arpit. All rights reserved.
//

//
//  Data.swift
//  Wallet Assistance
//
//  Created by Arpit on 22/09/18.
//  Copyright © 2018 Arpit. All rights reserved.
//

import UIKit

class ReadIncomeData{
    
    //MARK: Properties
    
    var id: String?
    var date: String?
    var expense: String?
    var catagory: String?
    var note: String?
    
    //MARK: Initialization
    
    init?(id: String?, date: String?, expense: String?, catagory: String?, note: String?) {
        
        self.id = id
        self.date = date
        self.expense = expense
        self.catagory = catagory
        self.note = note
    }
    
    
}



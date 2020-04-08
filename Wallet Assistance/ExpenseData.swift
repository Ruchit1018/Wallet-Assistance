//
//  ExpenseData.swift
//  WalletAssistance
//
//  Created by Radadiya on 25/09/18.
//  Copyright © 2018 Radadiya. All rights reserved.
//

import Foundation
class ExpenseData{
    
    //MARK:PROPERTIES
    var month : String?
    var amount : Double?
   
    
    //MARK INITIALIZATION
    init( month : String?,amount : Double?)
    {
        self.month = month
        self.amount = amount
      
    }
}

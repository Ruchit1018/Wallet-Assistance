//
//  Income.swift
//  WalletAssistance
//
//  Created by Radadiya on 21/09/18.
//  Copyright © 2018 Radadiya. All rights reserved.
//

import Foundation
class Income{
    //MARK: Properties
    
    var id: String?
    var date: String?
    var Amount: String?
    var catagory: String?
    var note: String?
    
    //MARK: Initialization
    
    init?(id: String?, date: String?, Amount: String?, catagory: String?, note: String?) {
        
        self.id = id
        self.date = date
        self.Amount = Amount
        self.catagory = catagory
        self.note = note
    }
}

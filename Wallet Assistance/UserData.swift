//
//  UserData.swift
//  Wallet Assistance
//
//  Created by Arpit on 22/09/18.
//  Copyright © 2018 Arpit. All rights reserved.
//

import UIKit

class UserData{
    
    //MARK: Properties
    
    var id: String?
    var User_name: String?
    var User_Surname: String?
    var User_Email: String?
    var User_Img : String?

    
    //MARK: Initialization
    
    init?(id: String?, User_name: String?, User_Surname: String?, User_Email: String?,User_Img: String?) {
        
        self.id = id
        self.User_name = User_name
        self.User_Surname = User_Surname
        self.User_Email = User_Email
        self.User_Img = User_Img
    }
}

//
//  AuthenticationViewController.swift
//  Wallet Assistance
//
//  Created by Arpit on 09/09/18.
//  Copyright © 2018 Arpit. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import SQLite3


class AuthenticationViewController: UIViewController, GIDSignInUIDelegate {
    
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    var db : OpaquePointer?
    var stmt : OpaquePointer?
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    var image: UIImage?
    
    fileprivate func setupGoogleButtons(){
        
        googleButton.frame = CGRect(x: 10, y: mainView.frame.minX+10, width: mainView.frame.width-20, height: 50)
        bottomView.addSubview(googleButton)
        GIDSignIn.sharedInstance().uiDelegate = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        login()
    }
    override func viewWillAppear(_ animated: Bool) {
        userLogin = UserDefaults.standard.bool(forKey: "userLogin")
        print(userLogin)
        if(userLogin == true)
        {
            googleButton.isHidden = true
            self.performSegue(withIdentifier: "Auth", sender: AnyObject.self)
        }
    }
    
    func login(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(5))
        {
            if(userLogin == true)
            {
                self.performSegue(withIdentifier: "Auth", sender: AnyObject.self)
                UserDefaults.standard.set(true, forKey: "userLogin")
                UserDefaults.standard.synchronize()
                self.userTable()
            }
        }
    }

    func userTable(){
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("WalletAssistance.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{
            
            print("Error opening database")
        }
        
        let createTable = "CREATE TABLE IF NOT EXISTS User (User_Id INTEGER PRIMARY KEY AUTOINCREMENT, User_Name TEXT, User_Surname TEXT, User_Email TEXT, User_Photo TEXT)"
        if sqlite3_exec(db, createTable, nil, nil, nil) != SQLITE_OK{
            print("Error crearing table")
            return
        }
        else
        {
            print(fileUrl.path)
            print("User Table Created")
        }
        
        let userName = GIDSignIn.sharedInstance()?.currentUser.profile.givenName
        let userSurname = GIDSignIn.sharedInstance()?.currentUser.profile.familyName
        let userEmail = GIDSignIn.sharedInstance()?.currentUser.profile.email
        let img = GIDSignIn.sharedInstance()?.currentUser.profile.imageURL(withDimension: 120)
        print(img)
        let userImage = img?.path
        print(userImage)
        
        let insert = "INSERT INTO User (User_Name,User_Surname,User_Email,User_Photo) VALUES (?, ?, ?, ?)"
        
        if sqlite3_prepare(db, insert, -1, &stmt, nil) != SQLITE_OK{
            print("Error binding query")
        }
        
        if sqlite3_bind_text(stmt, 1, userName, -1, SQLITE_TRANSIENT) != SQLITE_OK{  //Date
        }
        if sqlite3_bind_text(stmt, 2, userSurname, -1, SQLITE_TRANSIENT) != SQLITE_OK{ // Amount
        }
        if sqlite3_bind_text(stmt, 3, userEmail, -1, SQLITE_TRANSIENT) != SQLITE_OK{ // Categary
        }
        if sqlite3_bind_text(stmt, 4, userImage, -1, SQLITE_TRANSIENT) != SQLITE_OK{ // Place
        }
        if sqlite3_step(stmt) == SQLITE_DONE
        {
            //displayAlertMessage(messageToDisplay: "Employee Saved Successfully")
            print("User Data Saved Successfully")
        }
        else{
            let errmsg = String(cString: sqlite3_errmsg(db))
            print(errmsg)
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().uiDelegate = self
        setupGoogleButtons()
        // Do any additional setup after loading the view.
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

}



import UIKit
import GoogleSignIn
import SQLite3

class SecondViewController: UIViewController {
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
        userLogin = false
        UserDefaults.standard.set(false, forKey: "userLogin")
        UserDefaults.standard.synchronize()
        googleButton.isHidden = false
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBOutlet weak var addincomeButton: UIButton!
    @IBAction func addIncomeBtn(_ sender: Any) {
        
        let addincomeButton  = UIButton(type: .custom)
        if let image = UIImage(named: "Food") {
            addincomeButton.setImage(image, for: .normal)
        }
    }
    
    @IBAction func addExpenseButton(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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

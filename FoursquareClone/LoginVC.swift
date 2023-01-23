//
//  ViewController.swift
//  FoursquareClone
//
//  Created by Berkay YAY on 12.12.2022.
//

import UIKit
import Parse


class LoginVC: UIViewController {

    @IBOutlet weak var usernameLabel: UITextField!
    
    
    @IBOutlet weak var passwordLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    @IBAction func signUpClicked(_ sender: Any) {
        if usernameLabel.text != "" && passwordLabel.text != "" {
            let user = PFUser()
            user.username = usernameLabel.text!
            user.password = passwordLabel.text!
            
            user.signUpInBackground { success, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error!")
                }else{
                    
                    
                    print("OK")
                }
            }
            
        }else{
            
        }
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        if usernameLabel.text != "" && passwordLabel.text != "" {
            PFUser.logInWithUsername(inBackground: usernameLabel.text!, password: passwordLabel.text!) { user, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error!")
                }else{
                    
                    // Segue actions
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
        } else{
            makeAlert(title: "Error", message: "Username/Password not found")
        }
    }
    
    func makeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
}


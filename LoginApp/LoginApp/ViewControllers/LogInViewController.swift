//
//  LogInViewController.swift
//  LoginApp
//
//  Created by Aniketh Prasad on 10/18/21.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()

    }
    func setUpElements(){
        errorLabel.alpha = 0
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(LoginButton)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func loginTapped(_ sender: Any) {
        //Validate Text Fields
        let email = emailTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
        //Sign in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil{
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else{
                result!.user.reload { (error) in
                    switch result!.user.isEmailVerified{
                    case true:
                        self.transitiontoHome()
                        return
                    case false:
                        self.errorLabel.text = "Please check your email to verify your account"
                        self.errorLabel.alpha = 1
                        result!.user.sendEmailVerification { (error) in
                            guard let error = error else{

                                return
                            }
                        }
                    }
                }
        }
        }
        
    }
    
    func transitiontoHome(){
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
}

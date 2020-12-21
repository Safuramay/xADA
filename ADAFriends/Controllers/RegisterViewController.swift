import Foundation
import UIKit
import Firebase
class RegisterViewController:UIViewController{
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var buddySwitch: UISwitch!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func register(_ sender: Any) {
        guard let fullname = fullName.text else {
            Utility.shared.showError(message: "Name not be empty", view: self)
            return
            
        }
        guard let email = email.text else {
            Utility.shared.showError(message: "Email can not be empty", view: self)
            return}
        guard let password = password.text else {
            Utility.shared.showError(message: "Password can not be empty", view: self)
            return}
        guard let passwordConfirm = passwordConfirm.text else {
            Utility.shared.showError(message: "Password", view: self)
            return}
        if email.hasSuffix("") && password == passwordConfirm {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                //print(error)
                guard let user = authResult?.user, error == nil else {
                    
                    Utility.shared.showError(message: error?.localizedDescription ?? "", view: self)
                    return}
                Utility.shared.showError(message: "You have registered succesfully", view: self)
                Constants.shared.ref.child("users").child(user.uid).setValue(["username": fullname, "buddy": self.buddySwitch.isOn, "fullname":fullname])
                Auth.auth().currentUser?.sendEmailVerification { (error) in
                    if let error = error{
                        Utility.shared.showError(message: error.localizedDescription, view: self)}
                }
                
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
    }
}

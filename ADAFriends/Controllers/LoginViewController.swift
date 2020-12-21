import Foundation
import UIKit
import Firebase

class LoginViewController:UIViewController{
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func login(_ sender: Any) {
        guard let email = self.email.text else {
            Utility.shared.showError(message: "Email can not be empty", view: self)
            return}
        
        guard let password = self.password.text else {
            Utility.shared.showError(message: "Password can not be empty", view: self)
            return}
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            
            if let user = authResult?.user {
                //if user.isEmailVerified{
                    Constants.shared.user = user
                    strongSelf.performSegue(withIdentifier: "LogInSegue", sender: self)
                    Constants.shared.ref.child("users")
                                        .child(user.uid)
                                        .observeSingleEvent(of: .value, with: { (snapshot) in
                    Constants.shared.userDetails = CustomUser(id: user.uid, data: snapshot.value as! NSDictionary)
                                        }) { (error) in
                    Utility.shared.showError(message: error.localizedDescription, view: strongSelf)}
                //} else{
                  //  Utility.shared.showError(message: "Your email is not yet verified", view: strongSelf)}
            }else{
                Utility.shared.showError(message: "Check your credentials", view: strongSelf)}
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let user = Auth.auth().currentUser
        if let user = user {
           // if user.isEmailVerified{
                Constants.shared.user = user
                Constants.shared.ref.child("users").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let data = snapshot.value as? NSDictionary{
                        Constants.shared.userDetails = CustomUser(id: user.uid, data: data)
                        self.performSegue(withIdentifier: "LogInSegue", sender: self)
                        
                    }
                    else{
                        do{
                            try Auth.auth().signOut()
                            Constants.shared.user = nil
                            Constants.shared.userDetails = nil
                        }catch{
                            Utility.shared.showError(message: "Something went wrong.", view: self)
                        }
                        
                    }
                  }) { (error) in
                    Utility.shared.showError(message: error.localizedDescription, view: self)
                }
                
            //}
            
        } //else{Utility.shared.showError(message: "Your emaile is not yet verified", view: self)}
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let backButton = UIBarButtonItem(title: "", style: .plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
    }
}

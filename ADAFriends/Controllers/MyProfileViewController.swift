import UIKit
import Firebase
class MyProfileViewController: UITableViewController {

    @IBOutlet var myProfileTable: UITableView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    @IBAction func signOut(_ sender: Any) {
        do{try Auth.auth().signOut()
            let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "Login") as? LoginViewController
            Constants.shared.user = nil
            Constants.shared.userDetails = nil
            self.navigationController!.show(loginViewController!, sender: self)
        }catch{}
        
    }
    
    @IBAction func editProfile(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.myProfileTable.tableFooterView = UIView()
        Utility.shared.downloadImage(size: 1*1024*1024,image:self.profilePic, id: Constants.shared.user!.uid)
        Constants.shared.ref.child("users").child(Constants.shared.user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let user = snapshot.value as! NSDictionary
            self.fullName.text = user["fullname"] as? String ?? ""
            self.email.text = Constants.shared.user!.email
            
           
          }) { (error) in
            Utility.shared.showError(message: error.localizedDescription, view: self)
        }
    }
    
        

}

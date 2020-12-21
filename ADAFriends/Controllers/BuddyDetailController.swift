import UIKit

class BuddyDetailController: UITableViewController {
    @IBOutlet var rankButtons: [UIButton]?
    var buddy:String = ""
    var user:CustomUser?
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBOutlet var buddyDetail: UITableView!
    
    func updateStars(tag:Int){
        for i in 0..<rankButtons!.count{
            if rankButtons![i].tag <= tag{
                rankButtons![i].setImage(UIImage(named: "starfilled"), for: .normal)
                
            }else{
                rankButtons![i].setImage(UIImage(named: "star"), for: .normal)
            }
        }
    }
    
    @IBAction func rank(_ sender: UIButton) {
        if buddy != Constants.shared.user!.uid{
            Constants.shared.ref.child("ranking")
                            .child(buddy)
                            .child(Constants.shared.user!.uid).setValue(["rank":sender.tag])
            Utility.shared.calculateRank(id:self.buddy,view:self.rankLabel)
            self.updateStars(tag: sender.tag)
            
        } else{
            Utility.shared.showError(message: "You can not rank yourself", view: self)
        }
    }
    
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    @IBAction func feedback(_ sender: Any) {
        performSegue(withIdentifier: "buddyFeedback", sender: self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateStars(tag: -1)
        
        Utility.shared.downloadImage(size: 1024*1024, image: self.profilePic, id: buddy)
        self.buddyDetail.tableFooterView = UIView()
        Utility.shared.calculateRank(id:self.buddy,view:self.rankLabel)
        
        Constants.shared.ref.child("users").child(buddy).observeSingleEvent(of: .value, with: { (snapshot) in
            self.user = CustomUser(id: self.buddy,data: snapshot.value as! NSDictionary)
            self.fullName.text = self.user!.fullName
           
          }) { (error) in
            Utility.shared.showError(message: "You can not rank yourself", view: self)
        }
        Constants.shared.ref.child("ranking").child(buddy).child(Constants.shared.user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? NSDictionary{
                print(data)
                self.updateStars(tag: data["rank"] as! Int)
            }
           
          }) { (error) in
            //Utility.shared.showError(message: "You can not rank yourself", view: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? BuddyFeedbackController{
            vc.buddy = self.user
        }
    }

}

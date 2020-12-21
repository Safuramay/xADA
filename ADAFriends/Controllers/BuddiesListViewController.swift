import UIKit

class BuddiesListViewController: UITableViewController {
    var users:[CustomUser] = []
    var buddy:String = ""
    @IBOutlet var buddyTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 
        self.buddyTable.tableFooterView = UIView()
        Constants.shared.ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
            self.users = []
            if let value = snapshot.value as? NSDictionary{
                print(value)
                for (key,value) in value{
                    let user = CustomUser(id:key as! String, data: value as! NSDictionary)
                    if user.buddy{
                        self.users.append(user)
                    }
                    self.buddyTable.reloadData()
                }
                
            }
          }) { (error) in
            Utility.shared.showError(message: error.localizedDescription, view: self)
        }    
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "buddyCell", for: indexPath) as! BuddyCell
        cell.fullName.text = self.users[indexPath.row].fullName
        Utility.shared.downloadImage(size: 512 * 512, image: cell.profilePic, id: self.users[indexPath.row].id)
        Utility.shared.calculateRank(id:self.users[indexPath.row].id,view:cell.ranking)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.buddy = self.users[indexPath.row].id
        self.performSegue(withIdentifier: "buddyDetail", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? BuddyDetailController{
            vc.buddy = self.buddy
        }
    }
    

}

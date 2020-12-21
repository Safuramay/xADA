import UIKit

class EventDetailTableViewController: UITableViewController {
    var event:Event?
    
    @IBOutlet var eventDetailTable: UITableView!
    @IBOutlet weak var attendButton: UIButton!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var organizer: UILabel!
    @IBOutlet weak var eventName: UILabel!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MessengerViewController{
            vc.event = self.event
        }
    }
    

    @IBAction func attend(_ sender: UIButton) {
        
        Constants.shared.ref.child("events").child(event!.id).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            if let value = snapshot.value as? NSDictionary{
                
                if (value["attendants"] == nil){
                    Constants.shared.ref.child("events").child(self.event!.id).updateChildValues(["attendants": [Constants.shared.user!.uid]])
                    var events:[String] = []
                    if let prevEvents = Constants.shared.userDetails?.events{
                        events = prevEvents
                    }
                    events.append(Constants.shared.user!.uid)
                    Constants.shared.ref.child("users")
                        .child(Constants.shared.user!.uid)
                        .setValue(["username": Constants.shared.userDetails!.username,
                                   "buddy": Constants.shared.userDetails!.buddy,
                                   "fullname":Constants.shared.userDetails!.fullName,
                                   "events":events])
                    sender.setTitle("Unsubscribe", for: .normal)
                    
                } else{
                    
                    var attendants = value["attendants"] as! Array<String>
                    if (attendants.contains(Constants.shared.user!.uid)){
                        print("you are already attending this event")
                        let updatedAttendants = attendants.filter { $0 != Constants.shared.user!.uid }
                
                       // let prevEvents = Constants.shared.userDetails!.events
                        let updatedEvents = Constants.shared.userDetails!.events.filter { $0 != self.event!.id }
                        Constants.shared.ref.child("events").child(self.event!.id).updateChildValues(["attendants": updatedAttendants])
                        Constants.shared.ref.child("users")
                            .child(Constants.shared.user!.uid)
                            .setValue(["username": Constants.shared.userDetails!.username,
                                       "buddy": Constants.shared.userDetails!.buddy,
                                       "fullname":Constants.shared.userDetails!.fullName,
                                       "events":updatedEvents])
                        sender.setTitle("Subscribe", for: .normal)
                    }else{
                        attendants.append(Constants.shared.user!.uid)
                        Constants.shared.ref.child("events").child(self.event!.id).updateChildValues(["attendants": attendants])
                        var events:[String] = []
                        if let prevEvents = Constants.shared.userDetails?.events{
                            events = prevEvents
                        }
                        events.append(Constants.shared.user!.uid)
                        Constants.shared.ref.child("users")
                            .child(Constants.shared.user!.uid)
                            .setValue(["username": Constants.shared.userDetails!.username,
                                       "buddy": Constants.shared.userDetails!.buddy,
                                       "fullname":Constants.shared.userDetails!.fullName ,
                                       "events":events])
                        sender.setTitle("Unsubscribe", for: .normal)
                    }
                }
                          }
          }) { (error) in
           
            Utility.shared.showError(message: error.localizedDescription, view: self)
            
        }
        
    }
    
    @IBAction func chat(_ sender: Any) {
        if self.attendButton.titleLabel?.text == "Unsubscribe"{
            self.performSegue(withIdentifier: "openMessageSegue", sender: nil)
        }else{
            Utility.shared.showError(message: "You need to subscribe first", view: self)
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.eventDetailTable.tableFooterView = UIView()
        self.eventDescription.text = self.event?.description
        self.date.text = self.event?.date

        self.eventName.text = self.event?.name
        if ((event!.attendants.contains(Constants.shared.user!.uid))){
            self.attendButton.setTitle("Unsubscribe", for: .normal)
        }
        Constants.shared.ref.child("users").child(event!.organizer).observeSingleEvent(of: .value, with: { (snapshot) in
            let user = snapshot.value as! NSDictionary
            self.organizer.text = user["fullname"] as? String ?? ""
           
          }) { (error) in
            Utility.shared.showError(message: error.localizedDescription, view: self)
            
        }
        
    }



}

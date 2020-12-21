import UIKit

class EventsViewController: UITableViewController {

    @IBOutlet weak var eventName: UITextField!
    
    @IBOutlet weak var eventDescription: UITextView!
    
    @IBOutlet weak var dinner: UISwitch!
    @IBOutlet weak var party: UISwitch!
    @IBOutlet weak var study: UISwitch!
    
    @IBOutlet weak var gaming: UISwitch!
    @IBOutlet weak var shopping: UISwitch!
    @IBOutlet weak var date: UIDatePicker!
    
    
    @IBAction func post(_ sender: Any) {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm"
        let dateString = df.string(from: date.date)
        Constants.shared.ref.child("events").child(UUID().uuidString).setValue(
            ["eventName": eventName.text ?? "",
             "eventDescription":eventDescription.text ?? "",
             "dinner":dinner.isOn,
             "party":party.isOn,
             "study":study.isOn,
             "gaming":gaming.isOn,
             "shopping":shopping.isOn,
             "date":dateString,
             "organizer":Constants.shared.user!.uid,
             "attendants":[Constants.shared.user!.uid]])
        
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
        navigationController?.popViewController(animated: false)
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

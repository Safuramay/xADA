import UIKit
import Firebase
class EventsTableViewController: UITableViewController {
    @IBOutlet var eventTable: UITableView!
    var events:[Event] = []
    var selectedEvent:Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.eventTable.tableFooterView = UIView()

        Constants.shared.ref.child("events").observeSingleEvent(of: .value, with: { (snapshot) in
            self.events = []
            if let value = snapshot.value as? NSDictionary{
                for (key,value) in value{
                    print(key,value)
                    let event = Event(data: value as! NSDictionary, id:key as! String)
                    self.events.append(event)
                }
                self.events.sort(by: {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
                    let date1 = dateFormatter.date(from: $0.date)
                    let date2 = dateFormatter.date(from: $1.date)
                    return date1! < date2!
                    
                })
                self.eventTable.reloadData()
            }
            
          }) { (error) in
            Utility.shared.showError(message: error.localizedDescription, view: self)
            //print(error.localizedDescription)
        }    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventCell
        cell.title.text = self.events[indexPath.row].name
        cell.eventDescription.text = self.events[indexPath.row].description
        cell.tags.text = ""
        for item in events[indexPath.row].type{
            
            cell.tags.text! += "[\(item)] "
        }
        cell.date.text = self.events[indexPath.row].date

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedEvent = self.events[indexPath.row]
        performSegue(withIdentifier: "eventDetailSegue", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EventDetailTableViewController{
            vc.event = self.selectedEvent
        }
    }
}

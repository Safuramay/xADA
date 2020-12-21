import UIKit

class MessengerViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var event:Event?
    @IBOutlet weak var message: UITextView!
    @IBOutlet var messagesTable: UITableView!
    var messages:[Message] = []
    
    @IBAction func sendMessage(_ sender: Any) {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm"
        let dateString = df.string(from: Date())
        Constants.shared.ref.child("messages").child(event!.id).child(UUID().uuidString).setValue(
            ["content":self.message.text!,"from":Constants.shared.userDetails!.fullName,"fromId":Constants.shared.user!.uid,"date":dateString])
        self.message.text = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messagesTable.tableFooterView = UIView()

       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.message.layer.borderWidth = 1
        self.message.layer.borderColor = UIColor.gray.cgColor
        self.message.layer.cornerRadius = 10
        self.reload()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)

        // needed to clear the text in the back navigation:
        self.navigationItem.title = " "
    }
    
    
    func reload(){
        Constants.shared.ref.child("messages").child(event!.id).observe(.value, with: { (snapshot) in
            print(snapshot)
            self.messages = []
            if let data = snapshot.value as? NSDictionary{
                for (key,value) in data {
                    let message:Message = Message(data: value as! NSDictionary, id: key as! String)
                    self.messages.append(message)
                }
                self.messages.sort(by: {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
                    let date1 = dateFormatter.date(from: $0.date)
                    let date2 = dateFormatter.date(from: $1.date)
                    return date1! < date2!
                    
                })
                self.messagesTable.reloadData()
                self.scrollToBottom()
            }
        }){ (error) in
            Utility.shared.showError(message: error.localizedDescription, view: self)
        }
    }
   
    
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.messages.count-1, section: 0)
            self.messagesTable.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var identifier = "Reciever"
        if (self.messages[indexPath.row].fromId == Constants.shared.user!.uid){identifier = "Sender"}
    
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MessageCell
        cell.author.text = self.messages[indexPath.row].from
        cell.date.text = self.messages[indexPath.row].date
        cell.message.text = self.messages[indexPath.row].content
        return cell
    }

}

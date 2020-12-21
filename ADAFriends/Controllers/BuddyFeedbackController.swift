import UIKit

class BuddyFeedbackController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var feedbackButton: UIButton!
    @IBOutlet weak var feedback: UITextField!
    @IBOutlet weak var feedbackList: UITableView!
    var buddy:CustomUser?
    var feedbacks:[Message] = []
    
    
    @IBAction func sendFeedback(_ sender: Any) {
        let filtered = self.feedbacks.filter{$0.id == Constants.shared.user!.uid}
        let intersectEvents = self.buddy?.events.filter{ Constants.shared.userDetails!.events.contains($0) }
        if intersectEvents!.isEmpty{
            Utility.shared.showError(message: "You can not leave feedback for this buddy since you have not attended any event with him", view: self)
            return
        }
        if !filtered.isEmpty{
            Utility.shared.showError(message: "You have already sent a feedback for this buddy", view: self)
            return
        }
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm"
        let dateString = df.string(from: Date())
        Constants.shared.ref.child("feedback").child(buddy!.id).child(Constants.shared.user!.uid).setValue(
            ["content":self.feedback.text ?? "",
             "date":dateString,
             "from":Constants.shared.userDetails!.fullName])
        self.feedback.text = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.feedbackList.tableFooterView = UIView()

       
        
    }
    
    
    
    func reload(){
        Constants.shared.ref.child("feedback").child(buddy!.id).observe(.value, with: { (snapshot) in
            print(snapshot)
            self.feedbacks = []
            if let data = snapshot.value as? NSDictionary{
                for (key,value) in data {
                    let message:Message = Message(data: value as! NSDictionary, id: key as! String)
                    self.feedbacks.append(message)
                }
                self.feedbacks.sort(by: {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
                    let date1 = dateFormatter.date(from: $0.date)
                    let date2 = dateFormatter.date(from: $1.date)
                    return date1! < date2!
                    
                })
                self.feedbackList.reloadData()
                
                self.scrollToBottom()
            }
        }){ (error) in
            Utility.shared.showError(message: error.localizedDescription, view: self)
            print(error.localizedDescription)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.feedback.layer.borderWidth = 1
        self.feedback.layer.borderColor = UIColor.gray.cgColor
        self.feedback.layer.cornerRadius = 10
        if buddy!.id == Constants.shared.user!.uid{
            self.feedback.isEnabled = false
            self.feedbackButton.isEnabled = false
        }
        self.reload()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationItem.title = " "
    }
    
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            if (!self.feedbacks.isEmpty){
                let indexPath = IndexPath(row: self.feedbacks.count-1, section: 0)
                self.feedbackList.scrollToRow(at: indexPath, at: .bottom, animated: false)}
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedbacks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Reciever", for: indexPath) as! MessageCell
        
        cell.author.text = self.feedbacks[indexPath.row].from
        cell.message.text = "\(self.feedbacks[indexPath.row].content)"
        cell.date.text = "\(self.feedbacks[indexPath.row].date)"
        
        return cell
    }

}

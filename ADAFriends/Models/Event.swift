

import Foundation

struct Event{
    var name:String = ""
    var type:[String] = []
    var id:String = ""
    var attendants:[String] = []
    var organizer:String = ""
    var description:String = ""
    var date:String = ""
    
    init(data:NSDictionary, id:String) {
        print("hello")
        self.name = data["eventName"] as! String
        self.id = id
        self.organizer = data["organizer"] as! String
        self.description = data["eventDescription"] as! String
        self.date = data["date"] as! String
        self.attendants = data["attendants"] as? Array<String> ?? []
        if (data["gaming"] as! Bool) {self.type.append("gaming") }
        if (data["dinner"] as! Bool) {self.type.append("dinner") }
        if (data["shopping"] as! Bool) {self.type.append("shopping") }
        if (data["party"] as! Bool) {self.type.append("party") }
        if (data["study"] as! Bool) {self.type.append("study") }
        
    }
}

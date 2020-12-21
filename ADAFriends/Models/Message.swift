

import Foundation

struct Message {
    var from:String = ""
    var to:String = ""
    var content:String = ""
    var id:String = ""
    var date:String = ""
    var fromId:String = ""
    init(data:NSDictionary, id:String) {
        //print("hello")
        self.from = data["from"] as? String ?? ""
        self.id = id
       // self.to = data["to"] as! String
        self.content = data["content"] as? String ?? ""
        self.date = data["date"] as? String ?? ""
        self.fromId = data["fromId"] as? String ?? ""
        
    }
}

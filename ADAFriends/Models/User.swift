

import Foundation

struct CustomUser{
    var id:String=""
    var fullName:String=""
    var username:String=""
    var email:String=""
    var buddy:Bool=false
    

    var events:[String] = []
    
    init(id:String,data:NSDictionary) {
        self.id = id
        self.username = data["username"] as! String
        self.fullName = data["fullname"] as! String
        self.buddy = data["buddy"] as! Bool
        self.events = data["events"] as? [String] ?? []
    }
}

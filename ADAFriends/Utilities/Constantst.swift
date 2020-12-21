

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
class Constants{
    static let shared = Constants()
    let ref: DatabaseReference = Database.database().reference()
    let storageRef = Storage.storage().reference()
    var user: User? = nil
    var userDetails: CustomUser? = nil

   
}



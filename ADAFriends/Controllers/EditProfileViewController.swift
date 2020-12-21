import UIKit
import Firebase

class EditProfileViewController: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var fileName:String = ""
    var data:Data? = nil
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet var editTable: UITableView!
    
    @IBAction func pickImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        self.profilePic.image = image
        self.fileName = Constants.shared.user!.uid
        let imagePath = getDocumentsDirectory().appendingPathComponent(self.fileName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
            self.data = jpegData
        }

        dismiss(animated: true)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @IBAction func upload(_ sender: Any) {
       // guard let data = self.data else {return}
        if let data = self.data{
            let riversRef = Constants.shared.storageRef.child("\(self.fileName).jpeg")
            _ = riversRef.putData(data, metadata: nil,completion:nil)
        }
        guard let fullname = fullName.text else {
            Utility.shared.showError(message: "Name not be empty", view: self)
            return
            
        }
        Constants.shared.ref.child("users").child(Constants.shared.user!.uid).setValue(["username":Constants.shared.userDetails!.username,
            "buddy": Constants.shared.userDetails!.buddy,
            "fullname":fullname,
            "events":Constants.shared.userDetails!.events
            ])
//
//        Constants.shared.ref.child("users").child(Constants.shared.user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
//            let user = snapshot.value as! NSDictionary
//            Constants.shared.ref.child("users").child(Constants.shared.user!.uid).setValue(["username":user["username"] as! String , "buddy": user["buddy"] as! Bool, "fullname":self.fullName.text])
//
//
//            }) { (error) in
//            Utility.shared.showError(message: error.localizedDescription, view: self)
//        }
            
         // let size = metadata.size
            
 
        
        
    }
    @IBAction func close(_ sender: Any) {
    }
    
    @IBOutlet weak var fullName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.editTable.tableFooterView = UIView()
        Utility.shared.downloadImage(size: 1*1024*1024,image:self.profilePic,id: Constants.shared.user!.uid)
        
        Constants.shared.ref.child("users").child(Constants.shared.user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let user = snapshot.value as! NSDictionary
            self.fullName.text = user["fullname"] as! String
          }) { (error) in
            Utility.shared.showError(message: error.localizedDescription, view: self)
        }
    }

}

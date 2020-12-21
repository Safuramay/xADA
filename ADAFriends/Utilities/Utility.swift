

import Foundation

import Firebase
class Utility{
    static let shared = Utility()
    func downloadImage(size:Int64,image:UIImageView,id:String){
        
        let riversRef = Constants.shared.storageRef.child("\(id).jpeg")
        riversRef.getData(maxSize: 1*1024*1024) {
            data, error in
            print(error.debugDescription)
          if let _ = error {
            if let vc = image.findViewController(){
                image.image = UIImage(named:"person")
               // Utility.shared.showError(message: error.localizedDescription, view: vc)
            }
          } else {
            image.image = UIImage(data: data!)
          }
        }
        
    }
    
    func calculateRank(id:String,view:UILabel){
        var sum:Double = 0
        var count = 0.0
        
        Constants.shared.ref.child("ranking").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            if let dict = snapshot.value as? NSDictionary{
                for (_,value) in dict{
                    sum = sum + ((value as! NSDictionary)["rank"] as! Double)
                    count = count + 1
                    
                }
                view.text = String(format: "%.1f", sum / count)
            } else{
                view.text = "0.0"
            }
            
            
            
           
          }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func showError(message:String,view:UIViewController,type:String = "error"){
        
           
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        
        view.present(alert, animated: true)

            
        
        
        
    }

   
}
extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}

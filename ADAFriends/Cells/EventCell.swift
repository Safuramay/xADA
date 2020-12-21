
import UIKit

class EventCell: UITableViewCell {
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var eventDescription: UILabel!
    
    @IBOutlet weak var tags: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

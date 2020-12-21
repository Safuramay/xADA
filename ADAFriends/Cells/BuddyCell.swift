
import UIKit

class BuddyCell: UITableViewCell {

    @IBOutlet weak var ranking: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

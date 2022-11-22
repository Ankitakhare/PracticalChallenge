
//  Created by ankita khare on 22/11/22.

import UIKit
import CoreData

class UserDataListCell: UITableViewCell {

    var isFromCoreData : Bool = false
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblDOB: UILabel!
    
    var user: UserModel?{
        didSet{
            self.setUpUI()
        }
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
            self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.height/2
            self.imgProfile.layer.masksToBounds = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpUI(){
        
        if let obj = user{
            self.lblName.text = obj.userData.fullName
            self.lblDOB.text = obj.userData.date
            self.lblGender.text = obj.gender

            if self.isFromCoreData == true{
                if let data = obj.userData.imgData{
                    DispatchQueue.main.async {
                        self.imgProfile.image = UIImage(data: data)
                    }
                }else{
                    self.imgProfile.image = UIImage(named: "img")
                }
            }else{
                if let url = URL(string: obj.userData.thumbnail){
                    DispatchQueue.global().async {
                        if let data = try? Data(contentsOf: url){
                            DispatchQueue.main.async {
                                self.imgProfile.image = UIImage(data: data)
                            }
                        }else{
                            self.imgProfile.image = UIImage(named: "img")
                        }
                    }
                }else{
                    self.imgProfile.image = UIImage(named: "img")
                }
            }
        }
    }
}




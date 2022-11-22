//
//  ProfileDataVC.swift
//  Celo
//
//Created by ankita khare on 16/11/22.

import UIKit

class ProfileDataVC: UIViewController {
    
    var user: UserModel?
    var isFromCoreData : Bool = false

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblDOB: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureuserProfileData()
    }
    
    func configureuserProfileData(){
        self.lblName.text = user?.userData.fullName
        self.lblDOB.text = user?.userData.date
        self.lblGender.text = user?.gender
        self.lblAddress.text = user?.userData.fullAddress
        self.lblPhone.text = user?.phone
        self.lblEmail.text = user?.email
        
        if self.isFromCoreData == true{
            if let data = user?.userData.imgData{
                DispatchQueue.main.async {
                    self.imgProfile.image = UIImage(data: data)
                }
            }else{
                self.imgProfile.image = UIImage(named: "img")
            }
        }else{
            if let url = URL(string: user?.userData.large ?? ""){
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
    
    @IBAction func btnBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
}

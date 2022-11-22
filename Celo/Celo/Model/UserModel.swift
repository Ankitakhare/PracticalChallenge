
// Created by ankita khare on 16/11/22.
//

import Foundation




struct UserModel {
        
    var userData: UserModelInfo
    var gender = ""
    var email = ""
    var phone = ""
    
    init(dict: [String:Any]) {
        
        let name = dict["name"] as? [String: Any] ?? [:]
        let picture = dict["picture"] as? [String: Any] ?? [:]
        let dob = dict["dob"] as? [String: Any] ?? [:]
        let location = dict["location"] as? [String: Any] ?? [:]
        self.gender = dict["gender"] as? String ?? ""
        self.email = dict["email"] as? String ?? ""
        self.phone = dict["phone"] as? String ?? ""
        
        self.userData = UserModelInfo.init(name: name, picture: picture, dob: dob, location: location)
    }
}

struct UserModelInfo {
    
    var fullName = ""
    var firstName = ""
    var lastName = ""
    var title = ""
    var thumbnail = ""
    var large = ""
    var age = 0
    var date = ""
    var country = ""
    var state = ""
    var city = ""
    var streetName = ""
    var postcode = 0
    var fullAddress = ""
    var imgData: Data?
    
    let dateFormatter = DateFormatter()
    
    init(name: [String:Any], picture: [String:Any], dob: [String:Any], location: [String:Any]) {
        
        self.title = name["title"] as? String ?? ""
        self.firstName = name["first"] as? String ?? ""
        self.lastName = name["last"] as? String ?? ""
        self.fullName = "\(self.title) \(self.firstName) \(self.lastName)"
        
        self.country = location["country"] as? String ?? ""
        self.state = location["state"] as? String ?? ""
        self.city = location["city"] as? String ?? ""
        self.postcode = location["postcode"] as? Int ?? 0
        
        let street = location["street"] as? [String: Any] ?? [:]
        self.streetName = street["name"] as? String ?? ""
        
        self.fullAddress = "\(self.streetName) \(self.city) (\(self.postcode)), \(self.state), \(self.country)"
        
        self.thumbnail = picture["thumbnail"] as? String ?? ""
        self.large = picture["large"] as? String ?? ""
        
        self.age = dob["age"] as? Int ?? 0
        
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date1 = dateFormatter.date(from: "2017-01-09T11:00:00.000Z")
        dateFormatter.dateFormat = "dd MMM yyyy"
        self.date = dateFormatter.string(from: date1 ?? Date())
    }
}


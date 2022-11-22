//

//
//  Created by ankita khare on 16/11/22.
//

import Foundation
import UIKit
import CoreData

enum APIError: LocalizedError {

    case responseInvalid
    case authorisationError(String)
    
    var errorDescription: String? {
        switch self {
        case .responseInvalid: return "The server response was invalid."
        case .authorisationError(let error): return "Failed Authorisation with service error: \(error)"
        }
    }
}

protocol ApiManagerProtocol {
    func apiToGetUserData(page: Int, completion : @escaping ([UserModel]?, Error?) -> ())
}

class ApiManager: ApiManagerProtocol {
    
    func apiToGetUserData(page: Int = 1, completion : @escaping ([UserModel]?, Error?) -> ()) {
                
        let Url = String(format: "https://randomuser.me/api/?page=\(page)&results=10")
        guard let serviceUrl = URL(string: Url) else { return }
        var urlRequest = URLRequest(url: serviceUrl)
        urlRequest.httpMethod = "GET"

        let session = URLSession.shared
        session.dataTask(with: urlRequest) { (data, response, error) in
            
            if let data = data {
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                                        
                    let dictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
                    let data = dictionary?["results"] as? [[String:Any]] ?? [[:]]
                    
                    var arrayList = [UserModel]()
                    for obj in data{
                        arrayList.append(UserModel(dict: obj))
                        self.saveToCoreData(object: UserModel(dict: obj))
                    }
                    
                    completion(arrayList, nil)
                    
                } catch {
                    completion(nil, APIError.responseInvalid)
                }
            }else{
                completion(nil, APIError.responseInvalid)
            }
        }.resume()
    }
    
    func saveToCoreData(object: UserModel) {
        
        DispatchQueue.main.async {
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let college = NSEntityDescription.insertNewObject(forEntityName: "UserEntity", into: context) as! UserEntity
            college.fullName = object.userData.fullName
            college.email = object.email
            college.address = object.userData.fullAddress
            college.gender = object.gender
            college.dob = object.userData.date
            college.phone = object.phone
            DispatchQueue.global().async {
                if let url = URL(string: object.userData.thumbnail), let data = try? Data(contentsOf: url){
                    
                        college.picture = data
                    }
                }
                
                
                do {
                    try context.save()
                    print("successfully saved")
                } catch {
                    print("Could not save")
                }
            }
        }
        
    
    
    
    
}

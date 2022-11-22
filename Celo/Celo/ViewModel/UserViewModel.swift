
//
//  Created by ankita khare on 16/11/22.
//

import Foundation
import UIKit

class UserViewModel {
    
    let apiManager: ApiManagerProtocol
    let internetChecker: InternetCheckerProtocol
    
    init(apiManager: ApiManagerProtocol = ApiManager(),
         internetChecker: InternetCheckerProtocol = InternetChecker()) {
        self.apiManager = apiManager
        self.internetChecker = internetChecker
    }
    
    var arrayList = [UserModel]()
    var isFromCoreData : Bool = false
    
    func apiToGetUserData(page: Int, completion : @escaping () -> ()) {
        
        if internetChecker.isInternetAvailable() {
            apiManager.apiToGetUserData(page: page) { [weak self] arrayList, error in
                if let error = error {
                    print(error)
                    // Add error handling
                    completion()
                    return
                }
                guard let arrayList = arrayList else {
                    return
                }
                self?.arrayList = arrayList
                self?.isFromCoreData = false
                completion()
            }
        } else {
            DispatchQueue.main.async {
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                var userData = [UserEntity]()
                do {
                    userData =
                        try context.fetch(UserEntity.fetchRequest())
                } catch {
                    print("couldnt fetch")
                }
                
                var arrayList = [UserModel]()

                for obj in userData{
                    
                    var user = UserModel(dict: [:])
                    
                    user.phone = obj.phone ?? ""
                    user.email = obj.email ?? ""
                    user.gender = obj.gender ?? ""
                    user.userData.fullName = obj.fullName ?? ""
                    user.userData.fullAddress = obj.address ?? ""
                    user.userData.date = obj.dob ?? ""
                    user.userData.imgData = obj.picture ?? nil
                    
                    arrayList.append(user)
                }

                self.arrayList = arrayList
                self.isFromCoreData = true
                completion()
            }
        }
    }
}

//
//  UserListVC.swift
//  Celo
//
// Created by ankita khare on 16/11/22.
//

import UIKit
import CoreData



class UserListVC: UIViewController {
    
    var userViewModel = UserViewModel()
    var lists = [UserModel]()
    var filteredList = [UserModel]()
    
    var currentPage : Int = 1
    var isLoadingList : Bool = false
        
    @IBOutlet weak var tableUserData: UITableView!
    @IBOutlet weak var txtSearch: UITextField!{
        didSet{
            txtSearch.delegate = self
        }
    }
    @IBOutlet weak var viewSearch: UIView!{
        didSet{
            viewSearch.layer.cornerRadius = 5
            viewSearch.layer.masksToBounds = true
            viewSearch.layer.borderColor = UIColor.darkGray.cgColor
            viewSearch.layer.borderWidth = 0.8
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.callWebserviceForUsersList(page: currentPage)
    }
    
    func callWebserviceForUsersList(page: Int){
        
        userViewModel.apiToGetUserData(page: page) { [weak self] in
            
            if let arr = self?.userViewModel.arrayList{
                self?.lists.append(contentsOf: arr)
                self?.filteredList = self?.lists ?? [UserModel]()
                self?.isLoadingList = false
                DispatchQueue.main.async {
                    self?.tableUserData.reloadData()
                }
            }
        }
    }
    
    func loadMoreItemsForList(){
        currentPage += 1
        callWebserviceForUsersList(page: currentPage)
    }
}

//MARK:- Table View Methods
extension UserListVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.filteredList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserDataCell", for: indexPath) as! UserDataListCell
        cell.user = self.filteredList[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileDataVC") as! ProfileDataVC
        vc.isFromCoreData = self.userViewModel.isFromCoreData
        vc.user = self.filteredList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
            self.isLoadingList = true
            self.loadMoreItemsForList()
        }
    }
}

extension UserListVC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtSearch{
            txtSearch.resignFirstResponder()
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var input = ""
        if let text = textField.text {
            input = (text as NSString).replacingCharacters(in: range, with: string)
        }
        
        let arr = self.lists.filter({ $0.userData.fullName.lowercased().contains(input.lowercased())})
        self.filteredList = arr
        
        if input.count == 0{
            self.filteredList = self.lists
        }
        
        DispatchQueue.main.async {
            self.tableUserData.reloadData()
        }
        
        return true
    }
}

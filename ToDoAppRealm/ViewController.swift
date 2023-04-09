//
//  ViewController.swift
//  ToDoAppRealm
//
//  Created by sixpep on 09/04/23.
//

import RealmSwift
import UIKit

class ViewController: UIViewController {

    var contactArray = [Contact]()
    
    @IBOutlet weak var contactTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        contactTableView.delegate = self
        contactTableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    @IBAction func addContactButtonTapped(_ sender: Any) {
        contactConfiguration(isAdd: true, index: 0)

    }
    
    func configuration(){
        contactTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        contactArray = DatabaseHelper.shared.getAllContacts()
    }
    
    func contactConfiguration(isAdd:Bool,index:Int){
        
        let alertController = UIAlertController(title: isAdd ? "Add Contact" : "Update", message: isAdd ? "Please enter your contact details" : "Update your contact details", preferredStyle: .alert)
        
        
        let save = UIAlertAction(title: isAdd ? "Save" : "Update", style: .default){_ in
            
            if let firstName = alertController.textFields?.first?.text,
               let lastName = alertController.textFields?[1].text{
                let contact = Contact(firstName: firstName, lastName: lastName)
                
                if isAdd{
                    self.contactArray.append(contact)
                    DatabaseHelper.shared.saveContact(contact: contact)
                }else{
                    //self.contactArray[index] = contact
                    DatabaseHelper.shared.updateContact(oldContact: self.contactArray[index], newContact: contact)
                }
                
                
                self.contactTableView.reloadData()
                //print(firstName,lastName)
            }
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
            alertController.addTextField { firstNameField in
                firstNameField.placeholder = isAdd ? " Name" : self.contactArray[index].firstName
            }
            alertController.addTextField { lastNameField in
                lastNameField.placeholder = isAdd ? "Phone Number" : self.contactArray[index].lastName
            }
        

        
        alertController.addAction(save)
        alertController.addAction(cancel)
        
        present(alertController, animated: true)
    }
    
}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = contactTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = contactArray[indexPath.row].firstName
        cell.detailTextLabel?.text = contactArray[indexPath.row].lastName
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Update") { _, _, _ in
            self.contactConfiguration(isAdd: false, index: indexPath.row)
        }
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            
            DatabaseHelper.shared.deleteContact(contact: self.contactArray[indexPath.row])
            self.contactArray.remove(at: indexPath.row)
            self.contactTableView.reloadData()
        }
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [edit,delete])
        return swipeConfiguration
    }


}

//
//  DatabaseHelper.swift
//  ToDoAppRealm
//
//  Created by sixpep on 10/04/23.
//

import UIKit
import RealmSwift

class DatabaseHelper{
    static let shared = DatabaseHelper()
    
    private var realm = try! Realm()
    
    func getDatabaseURL()->URL?{
        return Realm.Configuration.defaultConfiguration.fileURL
    }
    
    func saveContact(contact: Contact){
        try! realm.write{
            realm.add(contact)
        }
    }
    
    func updateContact(oldContact:Contact,newContact:Contact){
        try! realm.write{
            oldContact.firstName = newContact.firstName
            oldContact.lastName = newContact.lastName
        }
    }
    
    func deleteContact(contact:Contact){
        try! realm.write{
            realm.delete(contact)
        }
    }
    
    func getAllContacts()->[Contact]{
        return Array(realm.objects(Contact.self))
    }
    
}

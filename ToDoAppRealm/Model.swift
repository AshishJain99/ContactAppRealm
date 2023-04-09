//
//  Model.swift
//  ToDoAppRealm
//
//  Created by sixpep on 09/04/23.
//
import RealmSwift
import Foundation

class Contact:Object{
    @Persisted var firstName:String
    @Persisted var lastName:String
    
    convenience init(firstName: String, lastName: String) {
        self.init()
        self.firstName = firstName
        self.lastName = lastName
    }
}

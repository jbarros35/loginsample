//
//  UserRepository.swift
//  Exercise
//
//  Created by Jose Barros on 18/05/2020.
//  Copyright © 2020 Jose Barros. All rights reserved.
//
import CoreData
import UIKit
import Foundation

protocol UserRepository {
    /// Insert dummy users on the database for testing.
    func populateDatabase() throws
    /// Do login with user name and password
    /// - Parameters:
    ///   - userName: the user name
    ///   - password: the user's password
    func login(userName: String, password: String) throws -> User?
}



class UserRepositoryImpl: NSObject, UserRepository {
    
    let appDelegateObject = UIApplication.shared.delegate as! AppDelegate
    fileprivate var context: NSManagedObjectContext!
    static var shared = UserRepositoryImpl()
    
    fileprivate override init() {
        self.context = appDelegateObject.persistentContainer.viewContext
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - userName: <#userName description#>
    ///   - password: <#password description#>
    func login(userName: String, password: String) throws -> User? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        var filter = [NSPredicate]()
        let userNameFilter = NSPredicate(format: "username == %@", userName)
        let passwordFilter = NSPredicate(format: "password == %@", password)
        filter.append(userNameFilter)
        filter.append(passwordFilter)
        let userPasswordPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: filter)
        fetchRequest.predicate = userPasswordPredicate
        fetchRequest.fetchLimit = 1
        let results = try context.fetch(fetchRequest)
        let user = results.first as? User
        return user
    }
    
    /// <#Description#>
    func populateDatabase() throws {
        /// <#Description#>
        /// - Parameters:
        ///   - userName: <#userName description#>
        ///   - password: <#password description#>
        func createUser(userName: String, password: String, country: Country) -> User {
            let user = User(context: self.context)
            user.password = password
            user.username = userName
            user.country = country
            return user
        }
        /// <#Description#>
        /// - Parameters:
        ///   - countryCode: <#countryCode description#>
        ///   - name: <#name description#>
        func createCountry(countryCode: String, name: String) -> Country {
            let country = Country(context: self.context)
            country.code = countryCode
            country.name = name
            return country
        }
        let countries = [createCountry(countryCode: "PT", name: "Portugal"),
                         createCountry(countryCode: "Ch", name: "Switzerland"),
        createCountry(countryCode: "DE", name: "German"),
        createCountry(countryCode: "US", name: "United States")]

        _ = [createUser(userName: "Alex", password: "123456", country: countries[3]),
             createUser(userName: "John", password: "654321", country: countries[0]),
             createUser(userName: "Daniel", password: "999666", country: countries[1]),
             createUser(userName: "David", password: "changeme", country: countries[0])]
        try self.context.save()
    }

}

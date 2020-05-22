//
//  UserService.swift
//  Exercise
//
//  Created by Jose Barros on 18/05/2020.
//  Copyright © 2020 Jose Barros. All rights reserved.
//

import Foundation

protocol UserService {
    /// Get a users list from the service
    /// - Parameters:
    ///   - handler: callback for result treatment
    ///   - errorHandler: error handler callback
    func getUsers(handler: @escaping ([UserModel]) -> (), errorHandler: @escaping (RESTError) -> ()) throws
}

class UserServiceImpl: NSObject, UserService {
    
    let restClient = RESTClient.shared
    static var shared = UserServiceImpl()
    
    fileprivate override init() {
    }
    
    func getUsers(handler: @escaping ([UserModel]) -> (), errorHandler: @escaping (RESTError) -> ()) throws {
        /// <#Description#>
        /// - Parameter payload: <#payload description#>
        func handleReturn(payload: Any?) {
            if let payloadArray = payload as? [NSDictionary] {
                var users = [UserModel]()
                 for dict in payloadArray {
                     if let user = UserModel.from(dict) {
                         users.append(user)
                     }
                 }
                 handler(users)
            }
        }
        try restClient.makeRequest(route: .users, method: .GET, handler: handleReturn, errorHandler: errorHandler)
    }
}

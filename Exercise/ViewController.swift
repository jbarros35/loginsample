//
//  ViewController.swift
//  Exercise
//
//  Created by Jose Barros on 18/05/2020.
//  Copyright © 2020 Jose Barros. All rights reserved.
//
import CoreData
import UIKit
import SwiftMessages

class ViewController: UIViewController {
    
    lazy var repository: UserRepository = {
        return UserRepositoryImpl.shared
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        perform(#selector(loadLoginView), with: nil, afterDelay: 0.01)
    }

    @objc func loadLoginView() {
        if UserDefaults.standard.bool(forKey: "DatabaseOK") {
            log.debug("database loaded")
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "login", sender: nil)
            }
        } else {
            self.populateDataBase()
        }
    }
    
    func populateDataBase() {
        do {
            try self.repository.populateDatabase()
            UserDefaults.standard.set(true, forKey: "DatabaseOK")
            UserDefaults.standard.synchronize()
        } catch {
            log.error(error)
            messages.showMessage(type: .error, title: .error, message: "Error: \(error)", buttonTitle: nil)
        }
    }
    
}


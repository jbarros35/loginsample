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
    
    let spinner = SpinnerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        perform(#selector(loadLoginView), with: nil, afterDelay: 0.01)
    }

    @objc func loadLoginView() {
        self.createSpinnerView()
        if UserDefaults.standard.bool(forKey: "DatabaseOK") {
            log.debug("database loaded")
            #if targetEnvironment(simulator)
                if let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path {
                    print("Documents Directory: \(documentsPath)")
                }
            #endif
            self.redirectLogin()
        } else {
            self.populateDataBase()
        }
    }
    
    func redirectLogin() {
        DispatchQueue.main.async {
            self.removeSpinnerView()
            self.performSegue(withIdentifier: "login", sender: nil)
        }
    }
    
    func populateDataBase() {
        do {
            try self.repository.populateDatabase()
            UserDefaults.standard.set(true, forKey: "DatabaseOK")
            UserDefaults.standard.synchronize()
            self.redirectLogin()
        } catch {
            self.removeSpinnerView()
            log.error(error)
            messages.showMessage(type: .error, title: .error, message: "Error: \(error)", buttonTitle: nil)
        }
    }
    
    func createSpinnerView() {
        // add the spinner view controller
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    func removeSpinnerView() {
        // wait two seconds to simulate some work happening
        DispatchQueue.main.async {
            // then remove the spinner view controller
            self.spinner.willMove(toParent: nil)
            self.spinner.view.removeFromSuperview()
            self.spinner.removeFromParent()
        }
    }
}


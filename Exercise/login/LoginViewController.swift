//
//  LoginViewController.swift
//  Exercise
//
//  Created by Jose Barros on 18/05/2020.
//  Copyright © 2020 Jose Barros. All rights reserved.
//
import EmptyStateKit
import UIKit

extension LoginViewController: EmptyStateDelegate {
    /// <#Description#>
    /// - Parameters:
    ///   - emptyState: <#emptyState description#>
    ///   - button: <#button description#>
    func emptyState(emptyState: EmptyState, didPressButton button: UIButton) {
        self.view.emptyState.hide()
        self.userNameTxt.becomeFirstResponder()
    }
}

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    lazy var repository: UserRepository = {
        return UserRepositoryImpl.shared
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.emptyState.delegate = self
    }
    
    @IBAction func resetAction(_ sender: Any) {
        self.userNameTxt.text = nil
        self.passwordTxt.text = nil
    }
    
    /// Do login validates against DB
    /// - Parameter sender: <#sender description#>
    @IBAction func loginAction(_ sender: Any) {
        if let userName = self.userNameTxt.text, let password = self.passwordTxt.text,
            userName.count > 0, password.count > 0 {
            do {
                guard let _ = try self.repository.login(userName: userName, password: password) else {
                    self.view.emptyState.show(TableState.authError)
                    self.view.emptyState.format = TableState.authError.format
                    self.resetAction("")
                    return
                }
                perform(#selector(loadMainScreen), with: nil, afterDelay: 0.5)
            } catch {
                messages.showMessage(type: .error, title: .error, message: "Error ocurred: \(error)", buttonTitle: "OK")
            }
        } else {
            messages.showMessage(type: .warning, title: .warning, message: "Please enter your user name and password.", buttonTitle: "OK")
        }
    }
    
    @objc func loadMainScreen() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "usersList", sender: nil)
        }
    }
    
    /// <#Description#>
    /// - Parameter segue: <#segue description#>
    @IBAction func unwindLogin(_ segue: UIStoryboardSegue) {
        self.resetAction("")
        self.userNameTxt.becomeFirstResponder()
    }
    
}

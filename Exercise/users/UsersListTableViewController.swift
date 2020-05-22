//
//  UsersListTableViewController.swift
//  Exercise
//
//  Created by Jose Barros on 18/05/2020.
//  Copyright © 2020 Jose Barros. All rights reserved.
//

import UIKit

class UsersListTableViewController: UITableViewController {

    lazy var service: UserService = {
        return UserServiceImpl.shared
    }()
    
    var users: [UserModel]?
    
    let spinner = SpinnerViewController()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadUsers()
    }

    fileprivate func loadUsers() {
        do {
            self.createSpinnerView()
            try service.getUsers(handler: { users in
                self.users = users
                self.tableView.reloadData()
                self.removeSpinnerView()
            }, errorHandler: { error in
                self.removeSpinnerView()
                log.error(error)
            })
        } catch {
            self.removeSpinnerView()
            log.error(error)
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
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCellId", for: indexPath)
        if let users = self.users {
            cell.textLabel?.text = users[indexPath.row].name
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let user = self.users?[indexPath.row] {
            self.performSegue(withIdentifier: "showUserDetails", sender: user)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController,
            let detailView = navigationController.viewControllers.first as? UserDetailViewController,
            let currentUser = sender as? UserModel {
            detailView.user = currentUser
        }
    }
    
}

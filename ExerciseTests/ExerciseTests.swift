//
//  ExerciseTests.swift
//  ExerciseTests
//
//  Created by Jose Barros on 18/05/2020.
//  Copyright © 2020 Jose Barros. All rights reserved.
//

import XCTest
@testable import Exercise

class ExerciseTests: XCTestCase {
    
    fileprivate var loginController: LoginViewController?
    fileprivate var storyboard: UIStoryboard?
    override func setUp() {
        self.storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
            return
        }
        _ = viewController.view
        self.loginController = viewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testlogin() {
        let e = expectation(description: "Do Autologin")
        loginController?.userNameTxt.text = "Alex"
        loginController?.passwordTxt.text = "123456"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.loginController?.loginAction("test")
            e.fulfill()
        })
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testWrongLogin() {
        loginController?.userNameTxt.text = "xpto"
        loginController?.passwordTxt.text = "99999"
        loginController?.loginAction("test")
        let currentUserName = loginController?.userNameTxt.text
        let password = loginController?.passwordTxt.text
        XCTAssertEqual(currentUserName, "")
        XCTAssertEqual(password, "")
    }
    
    func testListUsers() {
        guard let listViewController = self.storyboard?.instantiateViewController(withIdentifier: "UsersListTableViewController") as? UsersListTableViewController else {
            return
        }
        let e = expectation(description: "Do Service call for list users")
        _ = listViewController.view
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            e.fulfill()
        })
        waitForExpectations(timeout: 2.0, handler: { error in
            if error == nil {
                // Test for user selection
                listViewController.tableView(listViewController.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
                // test for single cell display
                let cell = listViewController.tableView(listViewController.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
                XCTAssertNotNil(cell)
            } else {
                XCTFail()
            }
        })
    }
    
    func testNullUser() {
        guard let userDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailViewController") as? UserDetailViewController else {
            return
        }
        _ = userDetailViewController.view
    }
    
    func testDetailUser() {
        guard let userDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailViewController") as? UserDetailViewController else {
            return
        }
        do {
            let e = expectation(description: "Do Service call for list users")
            let service = UserServiceImpl.shared
            try service.getUsers(handler: { users in
                userDetailViewController.user = users.first
                _ = userDetailViewController.view
                e.fulfill()
            }, errorHandler: { error in
                XCTFail()
            })
            waitForExpectations(timeout: 3.0, handler: { error in
                if error == nil {
                    XCTAssertNotNil(userDetailViewController.user)
                    userDetailViewController.logout()
                } else {
                    XCTFail()
                }
            })
        } catch {
            XCTFail()
        }
    }
    
    func testMasterDetail() {
        guard let masterDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "UsersMasterDetailViewController") as? UsersMasterDetailViewController else {
            return
        }
        _ = masterDetailViewController.view
    }
    
    func testRestClientError() {
        do {
            let e = expectation(description: "Do a wrong call on the service")
            let client = RESTClient.shared
            client.serverEndpoint = "https://httpstat.us/404"
            try client.makeRequest(route: .wrongPath, handler: { result in
                // Won't happen anyway
            }, errorHandler: { error in
                e.fulfill()
                XCTAssertNotNil(error)
            })
            waitForExpectations(timeout: 10.0, handler: { error in
                if error != nil {
                    XCTFail()
                }
            })
        } catch {
            XCTFail()
        }
    }
}

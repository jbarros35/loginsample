//
//  UserDetailViewController.swift
//  Exercise
//
//  Created by Jose Barros on 18/05/2020.
//  Copyright © 2020 Jose Barros. All rights reserved.
//

import UIKit
import EmptyStateKit
import MapKit

extension UserDetailViewController: EmptyStateDelegate {
    /// <#Description#>
    /// - Parameters:
    ///   - emptyState: <#emptyState description#>
    ///   - button: <#button description#>
    func emptyState(emptyState: EmptyState, didPressButton button: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

class UserDetailViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var streetLbl: UILabel!
    @IBOutlet weak var suiteLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var zipCodeLbl: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var websiteLbl: UILabel!
    @IBOutlet weak var companyNameLbl: UILabel!
    @IBOutlet weak var catchPhraseLbl: UILabel!
    @IBOutlet weak var companyBsLbl: UILabel!
    
    var user: UserModel? {
        didSet {
            log.debug(user?.name)
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logout))
        ]
        self.userSelect()
    }
    
    fileprivate func userSelect() {
        if let user = self.user {
            self.nameLbl.text = user.name
            self.emailLbl.text = user.email
            self.userNameLbl.text = user.username
            self.streetLbl.text = user.address?.street
            self.suiteLbl.text = user.address?.suite
            self.cityLbl.text = user.address?.city
            self.zipCodeLbl.text = user.address?.zipcode
            self.phoneLbl.text = user.phone
            self.websiteLbl.text = user.website
            self.companyNameLbl.text = user.company?.name
            self.catchPhraseLbl.text = user.company?.catchPhrase
            self.companyBsLbl.text = user.company?.bs
            if let coordinates = user.address?.geo {
                self.map.centerToLocation(coordinates)
                let location = MKPointAnnotation()
                location.coordinate = coordinates
                map.addAnnotation(location)
            }
        } else {
            self.containerView.emptyState.delegate = self
            self.containerView.emptyState.show(TableState.noUser)
            self.containerView.emptyState.format = TableState.noUser.format
        }
    }
    
    @objc func logout() {
        performSegue(withIdentifier: "unwindLogin", sender: nil)
    }
}

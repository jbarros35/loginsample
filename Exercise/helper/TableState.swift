//
//  CustomState.swift
//  StateView
//
//  Created by Alberto Aznar de los Ríos on 24/05/2019.
//  Copyright © 2019 Alberto Aznar de los Ríos. All rights reserved.
//

import UIKit
import EmptyStateKit

enum TableState: CustomState {
    
    case noInternet
    case unknownError
    case authError
    case noUser
    
    var image: UIImage? {
        switch self {
            case .noInternet: return UIImage(named: "broken-link")
            case .unknownError: return UIImage(named: "error")
            case .authError: return UIImage(named: "id-card")
            case .noUser: return UIImage(named: "id-card")
        }
    }
    
    var title: String? {
        switch self {
            case .noInternet: return "No Connection"
            case .unknownError: return "Error"
            case .authError: return "Authentication failed"
            case .noUser: return "No User was selected"
        }
    }
    
    var description: String? {
        switch self {
            case .noInternet: return "Please check the internet connection and try again."
            case .unknownError: return "An unexpected error has been ocurred."
            case .authError: return "Your password or username is not valid."
            case .noUser: return "Please select an user for see details."
        }
    }
    
    var titleButton: String? {
        switch self {
            case .noInternet: return "Go back"
            case .unknownError: return "Try again"
            case .authError: return "Done"
            case .noUser: return ""
        }
    }
}

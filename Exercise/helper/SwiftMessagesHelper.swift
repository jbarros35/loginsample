//
//  SwiftMessagesHelper.swift
//  loxy4-app
//
//  Created by Jose on 21/10/2019.
//  Copyright © 2019 SatcomInt. All rights reserved.
//
import SwiftMessages
import Foundation

let messages = SwiftMessagesHelper()

class SwiftMessagesHelper {
    
    enum titles: String {
        case error
        case success
        case warning
        case information
    }
    
    /// <#Description#>
    /// - Parameter type: <#type description#>
    /// - Parameter title: <#title description#>
    /// - Parameter message: <#message description#>
    /// - Parameter buttonTitle: <#buttonTitle description#>
    func showMessage(type: Theme, title: titles, message: String, buttonTitle: String?) {
        let msg = MessageView.viewFromNib(layout: .cardView)
        msg.configureTheme(type)
        msg.configureContent(title: title.rawValue, body: message)
        if let _ = buttonTitle {
            msg.button?.setTitle(buttonTitle, for: .normal)
        }        
        SwiftMessages.show(view: msg)
    }
    
}

//
//  State+Format.swift
//  StateView
//
//  Created by Alberto Aznar de los Ríos on 27/05/2019.
//  Copyright © 2019 Alberto Aznar de los Ríos. All rights reserved.
//

import UIKit
import EmptyStateKit

extension TableState {
    
    var format: EmptyStateFormat {
        switch self {
            
            case .unknownError:
                
                var format = EmptyStateFormat()
                format.buttonColor = "FF386C".toColor()
                format.position = EmptyStatePosition(view: .center, text: .center, image: .bottom)
                format.animation = EmptyStateAnimation.fade(0.3, 0.3)
                format.verticalMargin = -10
                format.horizontalMargin = 40
                format.imageSize = CGSize(width: 320, height: 200)
                format.buttonShadowRadius = 10
                format.gradientColor = (UIColor(named: "darkRed")!, "ffffff".toColor())
                format.backgroundColor = .black
                return format
            
            
            case .noInternet:
                
                var format = EmptyStateFormat()
                format.buttonColor = "44CCD6".toColor()
                format.position = EmptyStatePosition(view: .bottom, text: .left, image: .top)
                format.verticalMargin = 40
                format.horizontalMargin = 40
                format.imageSize = CGSize(width: 320, height: 200)
                format.buttonShadowRadius = 10
                format.gradientColor = (UIColor(named: "primary")!, UIColor(named: "secondary")!)
                format.titleAttributes = [.font: UIFont(name: "AvenirNext-DemiBold", size: 26)!, .foregroundColor: UIColor.white]
                format.descriptionAttributes = [.font: UIFont(name: "Avenir Next", size: 14)!, .foregroundColor: UIColor.white]
                return format
            
            case .authError:
                
                var format = EmptyStateFormat()
                format.buttonColor = "44CCD6".toColor()
                format.position = EmptyStatePosition(view: .top, text: .right, image: .top)
                format.animation = EmptyStateAnimation.fade(0.3, 0.3)
                format.verticalMargin = 20
                format.horizontalMargin = 40
                format.imageSize = CGSize(width: 320, height: 200)
                format.buttonShadowRadius = 10
                return format
            
            case .noUser:
                
                var format = EmptyStateFormat()
                format.position = EmptyStatePosition(view: .top, text: .right, image: .top)
                format.animation = EmptyStateAnimation.fade(0.3, 0.3)
                format.verticalMargin = 20
                format.horizontalMargin = 40
                format.imageSize = CGSize(width: 320, height: 200)
                format.buttonWidth = 0
                return format
            
        }
    }
}

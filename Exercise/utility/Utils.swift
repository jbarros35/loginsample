//
//  Utils.swift
//  loxy4-arch
//
//  Created by Jose on 04/06/2018.
//  Copyright © 2018 SatcomInt. All rights reserved.
//

import UIKit
import MapKit

/// <#Description#>
///
/// - pad: <#pad description#>
/// - phone: <#phone description#>
/// - undefined: <#undefined description#>
public enum DeviceType {
    case pad
    case phone
    case undefined
}

/// <#Description#>
public class Utils: NSObject {

    public static let birthDate = "yyyy-MM-dd"
    public static let timeDisplay = "dd.MM.yyyy HH:mm"
    public static let jsonDate = "yyyy-MM-dd'T'HH:mm:ssZ"

    // MARK: read variables from Info.plist file.
    ///
    /// - Parameter key: <#key description#>
    /// - Returns: <#return value description#>
    public static func readInfoVar(key: String) -> Any? {
        return Bundle.main.object(forInfoDictionaryKey: key)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    /// <#Description#>
    ///
    /// - Parameter hex: <#hex description#>
    /// - Returns: <#return value description#>
    public static func hexStringToUIColor (hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension String {
    public func toColor() -> UIColor {
        return Utils.hexStringToUIColor(hex: self)
    }
}

extension MKMapView {
  func centerToLocation(
    _ location: CLLocationCoordinate2D,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}

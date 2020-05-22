//
//  FileHelper.swift
//  Exercise
//
//  Created by Jose Barros on 18/05/2020.
//  Copyright © 2020 Jose Barros. All rights reserved.
//

import Foundation

extension FileManager {
    
    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    public static func getDefault() -> FileManager {
        return FileManager.default
    }
    /// <#Description#>
    ///
    /// - Parameter filePath: <#filePath description#>
    /// - Returns: <#return value description#>
    public static func createUserDirectory(_ filePath: String) -> Bool {
        do {
            let documentPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(filePath)
            try FileManager.getDefault().createDirectory(atPath: documentPath, withIntermediateDirectories: true,
                                                         attributes: nil)
            return true
        } catch {
            return false
        }
    }

}

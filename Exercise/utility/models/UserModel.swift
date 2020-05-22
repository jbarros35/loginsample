//
//  UserModel.swift
//  Exercise
//
//  Created by Jose Barros on 18/05/2020.
//  Copyright © 2020 Jose Barros. All rights reserved.
//

import Foundation
import Mapper
import CoreLocation

extension CLLocationCoordinate2D: Convertible {
    /// <#Description#>
    /// - Parameter value: <#value description#>
  public static func fromMap(_ value: Any) throws -> CLLocationCoordinate2D {
    guard let location = value as? NSDictionary,
        let lat = location["lat"] as? String, let latitude = Double(lat),
        let long = location["lng"] as? String, let longitude = Double(long) else {
         throw MapperError.convertibleError(value: value, type: [String: Double].self)
      }
      return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
}

class UserModel: Mappable {
    
    var id: Int?
    var name: String?
    var username: String?
    var email: String?
    var address: Address?
    var phone: String?
    var website: String?
    var company: Company?
    
    required init(map: Mapper) throws {
        self.id = map.optionalFrom("id")
        self.name = map.optionalFrom("name")
        self.username = map.optionalFrom("username")
        self.email = map.optionalFrom("email")
        self.address = map.optionalFrom("address")
        self.phone = map.optionalFrom("phone")
        self.website = map.optionalFrom("website")
        self.company = map.optionalFrom("company")
    }
}

class Address: Mappable {
    
    var street: String?
    var suite: String?
    var city: String?
    var zipcode: String?
    var geo: CLLocationCoordinate2D?
    
    required init(map: Mapper) throws {
        self.street = map.optionalFrom("street")
        self.suite = map.optionalFrom("suite")
        self.city = map.optionalFrom("city")
        self.zipcode = map.optionalFrom("zipcode")
        self.geo = map.optionalFrom("geo")
    }
}

class Company: Mappable {
    
    var name: String?
    var catchPhrase: String?
    var bs: String?
 
    required init(map: Mapper) throws {
        self.name = map.optionalFrom("name")
        self.catchPhrase = map.optionalFrom("catchPhrase")
        self.bs = map.optionalFrom("bs")
    }
}

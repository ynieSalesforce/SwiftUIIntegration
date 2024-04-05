//
//  LoadCriteria.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/5/24.
//

import Foundation
import MapKit

struct LoadCriteria {
  let address: String
  let location: CLLocation
  
  init(address: String, location: CLLocation) {
    self.address = address
    self.location = location
  }
  
  init(address: String, location: CLLocationCoordinate2D) {
    self.address = address
    self.location = .init(latitude: location.latitude, longitude: location.longitude)
  }
}

//
//  LoadCriteria.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/5/24.
//

import Foundation
import MapKit

struct LoadCriteria {
  let location: CLLocation
  
  init(location: CLLocation) {
    self.location = location
  }
  
  init(location: CLLocationCoordinate2D) {
    self.location = .init(latitude: location.latitude, longitude: location.longitude)
  }
}

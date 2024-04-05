//
//  AddressService.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/5/24.
//

import Foundation
import MapKit
import ReactiveSwift

struct AddressService {
  static func coordinates(from addresses: [String]) async -> [String: CLLocationCoordinate2D] {
    await withTaskGroup(of: (String, CLLocationCoordinate2D?).self) { group in
      for address in addresses {
        group.addTask { await (address, getCoordinate(from: address)) }
      }
      
      return await group.reduce(into: [:]) { dictionary, result in
        guard let address = result.1 else { return }
        dictionary[result.0] = address
      }
    }
  }
  
  static func getCoordinate(from address: String) async -> CLLocationCoordinate2D? {
    let geocoder = CLGeocoder()
    
    guard let location = try? await geocoder.geocodeAddressString(address)
      .compactMap( { $0.location } )
      .first(where: { $0.horizontalAccuracy >= 0 } )
    else {
      return nil
    }
    
    return location.coordinate
  }
  
  static func coordinates(from address: String) -> Signal<CLLocation?, Never>{
    let geoCoder = CLGeocoder()
    let (signal, observer) = Signal<CLLocation?, Never>.pipe()
    geoCoder.geocodeAddressString(address) { (placemarks, error) in
      guard let placemarks = placemarks,
            let location = placemarks.first?.location else {
        observer.send(value: nil)
        return
      }
      observer.send(value: location)
    }
    return signal
  }
}

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
  var coordinates: (String) -> ValueSignalProducer<CLLocation?> = coordinates
  var asyncCoordinate: (String) async -> CLLocationCoordinate2D? = asyncCoordinate
}

extension AddressService {
  static var live = AddressService()
}

extension AddressService {
  static func coordinates(from addresses: [String]) async -> [CLLocationCoordinate2D] {
    await withTaskGroup(of: (String, CLLocationCoordinate2D?).self) { group in
      for address in addresses {
        group.addTask { await (address, asyncCoordinate(from: address)) }
      }
      
      return await group.reduce(into: []) { dictionary, result in
        // guard let address = result.1 else { return }
      }
    }
  }
  
  static func asyncCoordinate(from address: String) async -> CLLocationCoordinate2D? {
    let geocoder = CLGeocoder()
    
    guard let location = try? await geocoder.geocodeAddressString(address)
      .compactMap( { $0.location } )
      .first(where: { $0.horizontalAccuracy >= 0 } )
    else {
      return nil
    }
    
    return location.coordinate
  }
  
  static func coordinates(from address: String) -> ValueSignalProducer<CLLocation?>{
    return ValueSignalProducer<CLLocation?> { observer, _ in
      let geoCoder = CLGeocoder()
      geoCoder.geocodeAddressString(address) { (placemarks, error) in
        guard let placemarks = placemarks,
              let location = placemarks.first?.location else {
          observer.send(value: nil)
          return
        }
        observer.send(value: location)
      }
    }
  }
}

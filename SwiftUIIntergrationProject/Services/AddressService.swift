//
//  AddressService.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/5/24.
//

import Foundation
import MapKit
import ReactiveSwift
import Combine

struct AddressService {
  var coordinates: (String) -> ValueSignalProducer<CLLocation?> = coordinates
  var asyncCoordinate: (String) async -> CLLocationCoordinate2D? = asyncCoordinate
  var coordinatePublisher: (String) -> AnyPublisher<CLLocation?, Never> = coordinatePub
}

extension AddressService {
  static var live = AddressService()
}

/*
 This service returns addresses in its various permutations.
 It does not return an error, but in an ideal world, it should return an address/coordinates
 not found error
*/
extension AddressService {
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
  
  static func coordinatePub(from address: String) -> AnyPublisher<CLLocation?, Never> {
    return Future<CLLocation?, Never> { promise in
      let geoCoder = CLGeocoder()
      geoCoder.geocodeAddressString(address) { (placemarks, error) in
        guard let placemarks = placemarks,
              let location = placemarks.first?.location else {
          promise(.success(nil))
          return
        }
        promise(.success(location))
      }
    }.eraseToAnyPublisher()
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

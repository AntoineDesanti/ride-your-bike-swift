//
//  City.swift
//  ride-your-bike
//
//  Created by Antoine Desanti on 09/04/2022.
//

import Foundation

public struct City{
    let name : String
    let latitude: Double
    let longitude: Double

}

public let cities = [
    City(name: "Nantes",  latitude: 47.2151496951626, longitude: -1.55022624256337),
    City(name: "Marseille", latitude: 43.290716834278136, longitude: 5.359258014511654),
    City(name: "Toulouse",  latitude: 43.59474911973265, longitude: 1.444132711268797),
]


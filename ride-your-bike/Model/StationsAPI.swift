//
//  StationsAPI.swift
//  ride-your-bike
//
//  Created by Antoine Desanti on 09/04/2022.
//

import Foundation


let api_url =  "https://api.jcdecaux.com/vls/v1/stations?apiKey=" + JCDecaux_API_Key
let final_url = URL(string:api_url)
var current_fetch_stations: [Station] = [];



public func getStations() -> [Station]{
    var fetchedStations: [Station] = []
    Task{
        do{
            let data =  try await fetchStations()
            current_fetch_stations = data
            
        }
        catch {
                print("Request failed with error: \(error)")
            }
    }
    
    print("getStations ", current_fetch_stations)
    return current_fetch_stations
 }

public func fetchStations() async throws -> [Station] {
    guard let url = final_url else { fatalError("Missing URL") }
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
    let results = try JSONDecoder().decode([Station].self, from: data)
    print("Async fetchStations", results.count)
    return results
}

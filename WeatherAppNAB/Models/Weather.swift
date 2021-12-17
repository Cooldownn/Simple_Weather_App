//
//  Weather.swift
//  WeatherAppNAB
//
//  Created by Hung P Dang on 17/12/2021.
//

import Foundation
struct Weather: Codable {
    let list: [WeatherList]
}

struct WeatherList: Codable {
    let dt: Double
    let temp: Temperature
    let pressure: Int
    let humidity: Int
    let weather: [WeatherDescription]
}


struct Temperature: Codable {
    let day: Double
}

struct WeatherDescription: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}


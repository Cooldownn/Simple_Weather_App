//
//  Presenter.swift
//  WeatherAppNAB
//
//  Created by Hung P Dang on 17/12/2021.
//

import Foundation
import UIKit

protocol WeatherPresenterDelegate: AnyObject {
    func presentWeather(weather: Weather)
    func presentError(error: String)
}

typealias PresenterDelegate = WeatherPresenterDelegate & UIViewController

class WeatherPresenter {
    
    weak var delegate: PresenterDelegate?
    
    public func setViewDelegate(delegate: PresenterDelegate) {
        self.delegate = delegate
    }
    
    public func getWeathersData(location: String) {
        guard let url = URL(string:"https://api.openweathermap.org/data/2.5/forecast/daily?q=\(location)&cnt=5&appid=60c6fbeb4b93ac653c492ba806fc346d&units=metric")
        else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let weathers = try JSONDecoder().decode(Weather.self, from: data)
                self?.delegate?.presentWeather(weather: weathers)
            } catch {
                print(error)
                self?.delegate?.presentError(error: "No data found with corresponding location")
            }
        }
        task.resume()
    }
    
}

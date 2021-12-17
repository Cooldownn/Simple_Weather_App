//
//  ViewController.swift
//  WeatherAppNAB
//
//  Created by Hung P Dang on 17/12/2021.
//

import UIKit

class WeatherViewController: UIViewController, WeatherPresenterDelegate, UITableViewDelegate, UITableViewDataSource {
    
    private let presenter = WeatherPresenter()
    
    private var weathers = [WeatherList]()
    
    @IBOutlet weak var locTextField: UITextField!
    
    @IBOutlet weak var cancelBtnTitle: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        locTextField.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        validate()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Weather Forecast"
        cancelBtnTitle.setTitle("Find", for: .normal)
        locTextField.layer.borderWidth = 1
        locTextField.layer.masksToBounds = true
        locTextField.layer.cornerRadius = 8
        errorLabel.isHidden = true
        
        // Table View
        let nib = UINib(nibName: "WeatherTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "WeatherTableViewCell")
        
        // Presenter
        presenter.setViewDelegate(delegate: self)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weathers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        let timeStamp = Global.UnixTimeStampToString(timeStamp: weathers[indexPath.row].dt)
        let averageTemp = round(weathers[indexPath.row].temp.day)
        let pressure = weathers[indexPath.row].pressure
        let humidity = weathers[indexPath.row].humidity
        let description = weathers[indexPath.row].weather[0].description
        let icon = weathers[indexPath.row].weather[0].icon
        let url = URL(string: "http://openweathermap.org/img/wn/\(icon)@2x.png")
        if let imageData = try? Data(contentsOf: url!) {
            cell.imgView.image = UIImage(data: imageData)
        }
        cell.dateLabel.text = "Date: \(timeStamp)"
        cell.tempLabel.text = "Average Temprature: \(averageTemp.cleanValue) ℃"
        cell.pressureLabel.text = "Pressure: \(pressure)"
        cell.hudmidLabel.text = "Humidity: \(humidity)"
        cell.descriptionLabel.text = "Description: \(description)"
        return cell
    }

    func presentWeather(weather: Weather) {
        self.weathers = weather.list
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.dismiss(animated: false)
            self.errorLabel.text = "Success"
            self.errorLabel.textColor = UIColor.green
        }
    }
    
    func presentError(error: String) {
        DispatchQueue.main.async {
            self.dismiss(animated: false, completion: nil)
            self.showAlert(for: error)
            self.errorLabel.text = "Failed"
            self.errorLabel.textColor = UIColor.blue
        }
    }
    
    func validate() {
        do {
            let location = try locTextField.validatedText(validationType: ValidatorType.location)
            presenter.getWeathersData(location: location)
            errorLabel.isHidden = false
            errorLabel.text = ""
        }
        catch (let error){
            self.dismiss(animated: false, completion: nil)
            locTextField.layer.borderWidth = 2
            locTextField.layer.borderColor = CGColor(red: 219/255, green: 8/255, blue: 30/255, alpha: 1)
            errorLabel.text = (error as! ValidationError).message
            errorLabel.isHidden = false
        }
    }
    
    func showAlert(for alert: String) {
        dismiss(animated: false, completion: nil)
        let alertController = UIAlertController(title: nil, message: alert, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension Double {
    var cleanValue: String
    {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

extension UITextField {
    func validatedText(validationType: ValidatorType) throws -> String {
        let validator = ValidatorFactory.validatorFor(type: validationType)
        return try validator.validated(self.text!)
    }
}


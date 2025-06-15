//
//  ForecastViewController.swift
//  CloudCast
//
//  Created by Kabir Dhillon on 6/15/25.
//

import UIKit

// Class declaration, including the name of the class and its subclass (UIViewController)
class ForecastViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var forecastImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    
    private var forecasts = [WeatherForecast]() // tracks all the possible forecasts
    private var selectedForecastIndex = 0 // tracks which forecast is being shown, defaults to 0
    
    // MARK: - Methods
    
    // Function override for the view controller
    // This is fired when the view has finished loading for the first time
    override func viewDidLoad() {
        // Some functions require you to call the super class implementation
        // Always read the online documentation to know if you need to
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //        let fakeData = WeatherForecast(temperature: 25.0, date: Date(), weatherCode: .partlyCloudy)
        //            configure(with: fakeData)
        
        forecasts = createMockData()
        addGradient()
        configure(with: forecasts[selectedForecastIndex]) // configure the UI to show the first mock data
    }
    
    // Returns an array of fake WeatherForecast data models to show
    private func createMockData() -> [WeatherForecast] {
        // This is just using the Calendar API to get a few random dates
        let today = Date()
        var dateComponents = DateComponents()
        dateComponents.day = 1
        let tomorrow = Calendar.current.date(byAdding: dateComponents, to: today)!
        let dayAfterTomorrow = Calendar.current.date(byAdding: dateComponents, to: tomorrow)!
        // Create a few mock data to show
        let mockData1 = WeatherForecast(windSpeed: 3.3,
                                        weatherCode: .violentRainShowers,
                                        precipitation: 33.3,
                                        temperature: 59.5,
                                        date:today)
        let mockData2 = WeatherForecast(windSpeed: 3.7,
                                        weatherCode: .fog,
                                        precipitation: 13.3,
                                        temperature: 65.5,
                                        date: tomorrow)
        let mockData3 = WeatherForecast(windSpeed: 2.8,
                                        weatherCode: .partlyCloudy,
                                        precipitation: 23.3,
                                        temperature: 49.5,
                                        date: dayAfterTomorrow)
        return [mockData1, mockData2, mockData3]
    }
    
    private func configure(with forecast: WeatherForecast) {
        forecastImageView.image = forecast.weatherCode.image
        descriptionLabel.text = forecast.weatherCode.description
        temperatureLabel.text = "\(forecast.temperature)°F"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        dateLabel.text = dateFormatter.string(from: forecast.date)
        humidityLabel.text = "\(forecast.windSpeed) mph"
        precipitationLabel.text = "\(forecast.precipitation)%"
    }
    
    @IBAction func didTapForwardButton(_ sender: UIButton) {
        selectedForecastIndex = min(forecasts.count - 1, selectedForecastIndex + 1) // don't go higher than the number of forecasts
        configure(with: forecasts[selectedForecastIndex]) // change the forecast shown in the UI
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        selectedForecastIndex = max(0, selectedForecastIndex - 1) // don't go lower than 0 index
        configure(with: forecasts[selectedForecastIndex]) // change the forecast shown in the UI
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(red: 0.54, green: 0.88, blue: 0.99, alpha: 1.00).cgColor,
                                UIColor(red: 0.51, green: 0.81, blue: 0.97, alpha: 1.00).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

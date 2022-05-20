//
//  DetailWeatherViewController.swift
//  testWeather
//
//  Created by Алексей Моторин on 19.05.2022.
//

import UIKit

class DetailWeatherViewController: UIViewController {

    var weatherManager = WeatherManager()
    var city: String!
   
    private lazy var stackCityAndTempLabels: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 0
        stack.axis = .vertical
        stack.distribution = .fill
        stack.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.3803921569, blue: 0.3882352941, alpha: 1)
        stack.layer.cornerRadius = 10
        return stack
    }()
    
    private lazy var stackImageAnddescriptionLabels: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.3803921569, blue: 0.3882352941, alpha: 1)
        stack.layer.cornerRadius = 10
        return stack
    }()
    
    private lazy var stackSunrise: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.3803921569, blue: 0.3882352941, alpha: 1)
        stack.layer.cornerRadius = 10
        return stack
    }()
    
    private lazy var stackSunset: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.3803921569, blue: 0.3882352941, alpha: 1)
        stack.layer.cornerRadius = 10
        return stack
    }()
    
    private lazy var stackInformationLabels: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.3803921569, blue: 0.3882352941, alpha: 1)
        stack.layer.cornerRadius = 10
        return stack
    }()
    
    private lazy var cityNameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        label.text = "--"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var conditionalImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        var largeFont = UIFont.systemFont(ofSize: 100)
        var configuration = UIImage.SymbolConfiguration(font: largeFont)
        imageView.tintColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        return imageView
    }()
    
    private lazy var sunriseImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        var largeFont = UIFont.systemFont(ofSize: 100)
        var configuration = UIImage.SymbolConfiguration(font: largeFont)
        imageView.tintColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        imageView.image = UIImage(systemName: "sunrise")
        return imageView
    }()
    
    private lazy var sunsetImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        var largeFont = UIFont.systemFont(ofSize: 100)
        var configuration = UIImage.SymbolConfiguration(font: largeFont)
        imageView.tintColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        imageView.image = UIImage(systemName: "sunset")
        return imageView
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 50)
        label.textColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "°C"
        return label
    }()
    
    private lazy var feelsLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 22)
        label.textColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        label.text = "--"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var sunriseLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 22)
        label.textColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        label.text = "--"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var sunsetLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 22)
        label.textColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        label.text = "--"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 22)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        label.text = "--"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager.delegate = self
        weatherManager.fetchWweather(cityName: city)
        
        view.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        
        view.addSubview(stackCityAndTempLabels)
        stackCityAndTempLabels.addArrangedSubview(cityNameLabel)
        stackCityAndTempLabels.addArrangedSubview(temperatureLabel)
        
        view.addSubview(stackImageAnddescriptionLabels)
        stackImageAnddescriptionLabels.addArrangedSubview(conditionalImage)
        stackImageAnddescriptionLabels.addArrangedSubview(descriptionLabel)
        
        view.addSubview(stackInformationLabels)
        stackInformationLabels.addArrangedSubview(feelsLabel)
 
        view.addSubview(stackSunset)
        stackSunset.addArrangedSubview(sunsetImage)
        stackSunset.addArrangedSubview(sunsetLabel)
        
        view.addSubview(stackSunset)
        stackSunset.addArrangedSubview(sunsetImage)
        stackSunset.addArrangedSubview(sunsetLabel)
        
        view.addSubview(stackSunrise)
        stackSunrise.addArrangedSubview(sunriseImage)
        stackSunrise.addArrangedSubview(sunriseLabel)

        NSLayoutConstraint.activate([
            
            stackCityAndTempLabels.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            stackCityAndTempLabels.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackCityAndTempLabels.widthAnchor.constraint(equalToConstant: 300),
            
            stackInformationLabels.topAnchor.constraint(equalTo: stackCityAndTempLabels.bottomAnchor, constant: 30),
            stackInformationLabels.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            stackInformationLabels.widthAnchor.constraint(equalToConstant: 170),
            stackInformationLabels.heightAnchor.constraint(equalToConstant: 170),
            
            stackImageAnddescriptionLabels.topAnchor.constraint(equalTo: stackCityAndTempLabels.bottomAnchor, constant: 30),
            stackImageAnddescriptionLabels.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            stackImageAnddescriptionLabels.widthAnchor.constraint(equalToConstant: 170),
            stackImageAnddescriptionLabels.heightAnchor.constraint(equalToConstant: 170),
            
            stackSunset.topAnchor.constraint(equalTo: stackImageAnddescriptionLabels.bottomAnchor, constant: 30),
            stackSunset.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            stackSunset.widthAnchor.constraint(equalToConstant: 170),
            stackSunset.heightAnchor.constraint(equalToConstant: 170),
            
            stackSunrise.topAnchor.constraint(equalTo: stackInformationLabels.bottomAnchor, constant: 30),
            stackSunrise.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            stackSunrise.widthAnchor.constraint(equalToConstant: 170),
            stackSunrise.heightAnchor.constraint(equalToConstant: 170),
           
            conditionalImage.heightAnchor.constraint(equalToConstant: 120),
            sunsetImage.heightAnchor.constraint(equalToConstant: 120),
            sunriseImage.heightAnchor.constraint(equalToConstant: 120),
        ])
    }
}

extension DetailWeatherViewController: WeatherManagerDelegate {
    func didUpdadeWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.cityNameLabel.text = weather.cityName
            self.conditionalImage.image = UIImage(systemName: weather.conditionName)
            self.temperatureLabel.text = weather.temperatureString + " " + "°C"
            self.feelsLabel.text = " Feels like \(weather.feelsLikeString)°C"
            self.descriptionLabel.text = weather.weatherDescription
            self.sunriseLabel.text = " Sunrise: \(weather.sunriseString)"
            self.sunsetLabel.text = " Sunset: \(weather.sunsetString)"
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}

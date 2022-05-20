//
//  CustomTableViewCell.swift
//  testWeather
//
//  Created by Алексей Моторин on 16.05.2022.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    var weatherManager = WeatherManager()
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.backgroundColor = #colorLiteral(red: 0.02352941176, green: 0.3803921569, blue: 0.3882352941, alpha: 1)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var cityNameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 22)
        label.textColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        label.text = "--"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var temperatureLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)
        label.textColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        label.text = "--"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var oCLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)
        label.textColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "°C"
        return label
    }()
    
    var conditionalImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        var largeFont = UIFont.systemFont(ofSize: 100)
        var configuration = UIImage.SymbolConfiguration(font: largeFont)
        imageView.tintColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        weatherManager.delegate = self
        
        contentView.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        contentView.addSubview(backView)
        
        backView.addSubview(cityNameLabel)
        backView.addSubview(conditionalImage)
        backView.addSubview(temperatureLabel)
        backView.addSubview(oCLabel)
        
        NSLayoutConstraint.activate([
            
            backView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            cityNameLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 10),
            cityNameLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 10),
            cityNameLabel.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
            cityNameLabel.widthAnchor.constraint(equalToConstant: 100),
            
            conditionalImage.leadingAnchor.constraint(equalTo: cityNameLabel.trailingAnchor, constant: 20),
            conditionalImage.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
            conditionalImage.topAnchor.constraint(equalTo: backView.topAnchor, constant: 10),
            conditionalImage.widthAnchor.constraint(equalToConstant: 70),
           
            temperatureLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 10),
            temperatureLabel.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: oCLabel.leadingAnchor, constant: -5),
            
            oCLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 10),
            oCLabel.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
            oCLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -10),
        ])
    }
}

extension CustomTableViewCell: WeatherManagerDelegate {
    func didUpdadeWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.cityNameLabel.text = weather.cityName
            self.conditionalImage.image = UIImage(systemName: weather.conditionName)
            self.temperatureLabel.text = weather.temperatureString
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}


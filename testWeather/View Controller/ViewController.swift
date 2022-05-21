//
//  ViewController.swift
//  testWeather
//
//  Created by Алексей Моторин on 16.05.2022.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    var cities: Results<WeatherCities>!
    private var filtredCities: Results<WeatherCities>!
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    private var ascendingSorting = true
    
    var weatherManager = WeatherManager()
    
    private lazy var weatherTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Default")
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "Custom")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        setupView()
        setupNavigationBar()
        setupSearchController()
        
        cities = realm.objects(WeatherCities.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        weatherTableView.reloadData()
    }
    
    private func setupView() {
        view.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        view.addSubview(weatherTableView)
        weatherTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        weatherTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        weatherTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        weatherTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    
    private func setupNavigationBar() {
        title = "Weather in:"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCity))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: weatherTableView, action: #selector(weatherTableView.reloadData))
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white ]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = #colorLiteral(red: 0.2196078431, green: 0.2196078431, blue: 0.2196078431, alpha: 1)
        navBarAppearance.shadowColor = nil
        navBarAppearance.shadowImage = nil
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self // получать информации должен быть наш класс
        searchController.obscuresBackgroundDuringPresentation = false // позволяет взаимодействовать с результатом поиска
        searchController.searchBar.placeholder = "Enter city"
        searchController.searchBar.searchTextField.textColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        navigationItem.searchController = searchController // добавили поиск в нав бар
        definesPresentationContext = true // позволяет отпустить поиск при переходе на другой экран
    }
    
    @objc private func addCity() {
        let alert = UIAlertController(title: "Enter city", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Save", style: .default) { [unowned alert] _ in
            let answer = alert.textFields![0]
           
            let cityName = WeatherCities()
            
            guard answer.text != ""  else { return }
            if let city = answer.text {
                cityName.nameCity = city.split(separator: " ").joined(separator: "%20")
                
                StorageManager.saveObject(cityName)
                self.weatherTableView.reloadData()
                
            }
        }
        
        alert.addTextField { textField in
            textField.placeholder = " Enter city"
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}

// MARK: work with tableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // count cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filtredCities.count
        }
        
       return cities.isEmpty ? 0 : cities.count
        
    }
    
    // creat cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Custom", for: indexPath) as? CustomTableViewCell else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Default", for: indexPath)
            return cell
        }
        
        let city = cities[indexPath.row]
        cell.weatherManager.fetchWweather(cityName: city.nameCity.split(separator: " ").joined(separator: "%20"))
        return cell
    }
    
    // height cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    
    // delete cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let city = cities[indexPath.row]
        
        if editingStyle == .delete {            
            tableView.beginUpdates()
            StorageManager.deleteObject(city)
            tableView.deleteRows(at: [indexPath], with: .fade )
            tableView.endUpdates()
            
        }
    }
    
    // show detail cell (Detail weather)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var city = WeatherCities()
        
        if isFiltering {
            city = filtredCities[indexPath.row]
        } else {
            city = cities[indexPath.row]
        }
       
        let detailWeatherVC = DetailWeatherViewController()
        detailWeatherVC.city = city.nameCity.split(separator: " ").joined(separator: "%20")
        present(detailWeatherVC, animated: true)
    }
    
}

// MARK: work with searchBar
extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText (_ searchText: String) {
        filtredCities = cities.filter("nameCity CONTAINS[c] %@", searchText, searchText)
        weatherTableView.reloadData()
    }
}


//
//  ViewController.swift
//  testWeather
//
//  Created by Алексей Моторин on 16.05.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    
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
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController // добавили поиск в нав бар
        definesPresentationContext = true // позволяет отпустить поиск при переходе на другой экран
    }
    
    @objc private func addCity() {
        let alert = UIAlertController(title: "Enter city", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Save", style: .default) { [unowned alert] _ in
            let answer = alert.textFields![0]
            guard answer.text != ""  else { return }
            if let city = answer.text {
                guard !Cities.city.contains(city) else { return }
                Cities.city.append(city)
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
        Cities.city.count
        
    }
    
    // creat cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Custom", for: indexPath) as? CustomTableViewCell else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Default", for: indexPath)
            return cell
        }
        
        if Cities.city[indexPath.row] != "" {
            let city = Cities.city[indexPath.row].split(separator: " ").joined(separator: "%20")
            cell.weatherManager.fetchWweather(cityName: city)
        }
        
        return cell
    }
    
    // height cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    
    // delete cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Cities.city.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // show detail cell (Detail weather)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailWeatherVC = DetailWeatherViewController()
        detailWeatherVC.city = Cities.city[indexPath.row].split(separator: " ").joined(separator: "%20")
        present(detailWeatherVC, animated: true)
    }
    
}

// MARK: work with searchBar
extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}


//
//  HomeViewController.swift
//  Assignment
//
//  Created by Harshit ‎ on 6/16/25.
//

import UIKit

class HomeViewController: UIViewController {
    private let viewModel = HomeViewModel()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "DataCell")
        return table
    }()
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupViewModel()
        loadData()
        
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                print(dataFilePath)
    }
    
    private func setupUI() {
        title = "Home"
        view.backgroundColor = Constants.Colors.backgroundColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(refreshData)
        )
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
    }
    
    private func loadData() {
        viewModel.loadDataFromCoreData()
        if viewModel.dataItems.isEmpty {
            viewModel.fetchDataFromAPI()
        }
    }
    
    @objc private func refreshData() {
        viewModel.fetchDataFromAPI()
    }
    
    private func showEditAlert(for index: Int) {
        let item = viewModel.dataItems[index]
        
        let alert = UIAlertController(title: "Edit Item", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Name"
            textField.text = item.name
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Data (Optional)"
            textField.text = item.data
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let nameField = alert.textFields?[0],
                  let dataField = alert.textFields?[1],
                  let name = nameField.text, !name.isEmpty else {
                self?.showAlert(title: "Error", message: "Name cannot be empty")
                return
            }
            
            self?.viewModel.updateItem(item, name: name, data: dataField.text)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteItem(item)
        }
        
        alert.addAction(saveAction)
        alert.addAction(deleteAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath)
        let item = viewModel.dataItems[indexPath.row]
        
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.data
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showEditAlert(for: indexPath.row)
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func didFetchData() {
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    func didFailWithError(_ error: Error) {
        refreshControl.endRefreshing()
        showAlert(title: "Error", message: error.localizedDescription)
    }
    
    func didUpdateData() {
        tableView.reloadData()
        showAlert(title: "Success", message: "Item updated successfully")
    }
    
    func didDeleteData(_ item: DataItem) {
        tableView.reloadData()
        showAlert(title: "Success", message: "Item deleted successfully")
    }
}

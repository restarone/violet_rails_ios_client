//
//  AppPickerViewController.swift
//  Violet Rails
//
//  Created by Joses Solmaximo on 05/05/23.
//

import UIKit

class AppPickerViewController: UIViewController {
    private var tableView: UITableView!

    override func viewDidLoad() {
        view.backgroundColor = .systemBackground

        title = "Apps"

        setupTableView()
        setupNavigationBar()
    }

    func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "appCell")
        view.addSubview(tableView)
    }

    func setupNavigationBar(){
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        addButton.tintColor = .black
        navigationItem.rightBarButtonItem = addButton
    }

    @objc func addButtonTapped() {
        let alertController = UIAlertController(title: "Add Link", message: nil, preferredStyle: .alert)

        alertController.addTextField { (textField) in
            textField.placeholder = "Link"
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let link = alertController.textFields?[0].text,
                  let url = URL(string: link),
                  let tabBarController = self.tabBarController as? TabBarController
            else { return }
            
            guard !VisitableViewManager.shared.baseURLs.contains(url) else {
                let alert = Alerts.okAlert(title: "This URL is already added", message: "Please enter another URL")
                
                self.present(alert, animated: true)
                
                return
            }
            
            Task {
                do {
                    try await tabBarController.getTabs(endpoint: link)
                    
                    VisitableViewManager.shared.addBaseURL(url)
                    VisitableViewManager.shared.setSelectedURL(url)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    let alert = Alerts.okAlert(title: "URL isn't valid", message: "Please enter another URL")
                    
                    self.present(alert, animated: true)
                }
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)

        present(alertController, animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}

extension AppPickerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VisitableViewManager.shared.baseURLs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "appCell", for: indexPath)

        let tableRows = VisitableViewManager.shared.baseURLs
        let baseURL = tableRows[tableRows.index(tableRows.startIndex, offsetBy: indexPath.row)]

        cell.textLabel?.text = baseURL.absoluteString
        cell.selectionStyle = .none

        if baseURL == VisitableViewManager.shared.selectedURL {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tabBarController = tabBarController as? TabBarController {
            let endpoint = VisitableViewManager.shared.baseURLs[indexPath.row]
            
            Task {
                do {
                    try await tabBarController.getTabs(endpoint: endpoint.absoluteString)
                    
                    VisitableViewManager.shared.setSelectedURL(endpoint)
                    
                    tableView.reloadData()
                } catch {
                    
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            VisitableViewManager.shared.removeBaseURL(VisitableViewManager.shared.baseURLs[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

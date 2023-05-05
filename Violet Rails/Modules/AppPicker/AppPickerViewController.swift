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
            if let link = alertController.textFields?[0].text {
                if let url = URL(string: link) {
                    VisitableViewManager.shared.addBaseURL(url)

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
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

        cell.textLabel?.text = baseURL
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
            tabBarController.getTabs(endpoint: VisitableViewManager.shared.baseURLs[indexPath.row])

            tableView.reloadData()
        }
    }
}

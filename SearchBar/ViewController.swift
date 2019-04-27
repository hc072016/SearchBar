//
//  ViewController.swift
//  SearchBar
//
//  Created by Howie C on 4/26/19.
//  Copyright © 2019 Howie C. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    static let defaultTableViewCellReuseIdentifier = "DefaultTableViewCell"
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.init(red: 194 / 255, green: 255 / 255, blue: 240 / 255, alpha: 1)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ViewController.defaultTableViewCellReuseIdentifier)
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 30
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.defaultTableViewCellReuseIdentifier, for: indexPath)
     
     // Configure the cell...
        cell.textLabel?.text = "#\(indexPath.row)"
        cell.textLabel?.textColor = UIColor.white
        switch indexPath.row % 2 {
        case 0:
            cell.backgroundColor = UIColor.init(red: 202 / 255, green: 234 / 255, blue: 255 / 255, alpha: 1)
        case 1:
            cell.backgroundColor = UIColor.init(red: 255 / 255, green: 119 / 255, blue: 130 / 255, alpha: 1)
        default:
            cell.backgroundColor = UIColor.white
        }
     return cell
     }
    
    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}


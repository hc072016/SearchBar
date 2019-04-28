//
//  ViewController.swift
//  SearchBar
//
//  Created by Howie C on 4/26/19.
//  Copyright © 2019 Howie C. All rights reserved.
//

//  constraints in storyboard are for visual demonstration, removed at build time.
//  all constraints are set up in code

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    static let defaultTableViewCellReuseIdentifier = "DefaultTableViewCell"
    static let defaultSearchBarBackgroundViewCornerRadius: CGFloat = 3
    static let searchBarBackgroundViewNarrowMargin: CGFloat = 0
    static let searchBarBackgroundViewWideMargin: CGFloat = 4
    static let defaultSearchBarStackViewSpacing: CGFloat = 8
    static let searchBarStackViewNarrowMargin: CGFloat = 4
    static let searchBarStackViewWideMargin: CGFloat = 8
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBarBackgroundView: UIView!
    @IBOutlet weak var searchBarStackView: UIStackView!
    @IBOutlet weak var searchBarTextField: UITextField!
    @IBOutlet weak var searchBarButton: UIButton!
    
    var tableViewTopConstraint: NSLayoutConstraint?
    var searchBarBackgroundViewTopConstraint: NSLayoutConstraint?
    var searchBarBackgroundViewTrailingConstraint: NSLayoutConstraint?
    var searchBarStackViewTopConstraint: NSLayoutConstraint?
    var searchBarStackViewLeadingConstraint: NSLayoutConstraint?
    var searchBarStackViewTrailingConstraint: NSLayoutConstraint?
    var searchBarStackViewBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.init(red: 194 / 255, green: 255 / 255, blue: 240 / 255, alpha: 1)
        
        tableView.keyboardDismissMode = .onDrag
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ViewController.defaultTableViewCellReuseIdentifier)
        // constraint tableView to safe area
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableViewTopConstraint = tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        tableViewTopConstraint?.isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        searchBarBackgroundView.layer.cornerRadius = ViewController.defaultSearchBarBackgroundViewCornerRadius
        // search bar background view resize according to its subviews – a text field and a button embedded in a stack view
        searchBarBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        searchBarBackgroundViewTopConstraint = searchBarBackgroundView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: ViewController.searchBarBackgroundViewWideMargin)
        searchBarBackgroundViewTopConstraint?.isActive = true
        searchBarBackgroundViewTrailingConstraint = self.view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: searchBarBackgroundView.trailingAnchor, constant: ViewController.searchBarBackgroundViewWideMargin)
        searchBarBackgroundViewTrailingConstraint?.isActive = true
        searchBarBackgroundView.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        
        searchBarStackView.axis = .horizontal
        // this makes the stack view as tall as the height of the taller of the two embedded views.
        searchBarStackView.alignment = .fill
        searchBarStackView.distribution = .fill
        searchBarStackView.spacing = ViewController.defaultSearchBarStackViewSpacing
        searchBarStackView.translatesAutoresizingMaskIntoConstraints = false
        searchBarStackViewTopConstraint = searchBarStackView.topAnchor.constraint(equalTo: searchBarBackgroundView.topAnchor, constant: ViewController.searchBarStackViewNarrowMargin)
        searchBarStackViewTopConstraint?.isActive = true
        searchBarStackViewLeadingConstraint = searchBarStackView.leadingAnchor.constraint(equalTo: searchBarBackgroundView.leadingAnchor, constant: ViewController.searchBarStackViewNarrowMargin)
        searchBarStackViewLeadingConstraint?.isActive = true
        searchBarStackViewTrailingConstraint = searchBarBackgroundView.trailingAnchor.constraint(equalTo: searchBarStackView.trailingAnchor, constant: ViewController.searchBarStackViewNarrowMargin)
        searchBarStackViewTrailingConstraint?.isActive = true
        searchBarStackViewBottomConstraint = searchBarBackgroundView.bottomAnchor.constraint(equalTo: searchBarStackView.bottomAnchor, constant: ViewController.searchBarStackViewNarrowMargin)
        searchBarStackViewBottomConstraint?.isActive = true
        
        // with a lower content hugging priority, text field expands while button stays the same
        searchBarTextField.setContentHuggingPriority(UILayoutPriority(249), for: .horizontal)
        // as text field has a content hugging priority of 751, which is larger than the button's compression resistance priority of 750, and the stack view's alignment is set to .fill, so the stack view will be set as tall as the text field
        // alternative: stackView.alignment = .center; one more constraint to make textField and button equal heights
        searchBarTextField.setContentHuggingPriority(UILayoutPriority(751), for: .vertical)
        var searchBarTextFieldLayoutConstraint: NSLayoutConstraint
        searchBarTextField.translatesAutoresizingMaskIntoConstraints = false
        searchBarTextFieldLayoutConstraint = searchBarTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor)
        // as the setup of the stack view, essentially, searchBarTextField.leadingAnchor = searchBarBackgroundView.leadingAnchor + 4
        // searchBarBackgroundView.leadingAnchor is a required constraint, so is it not possible to satify both; however, unsatisfied optional constraints act as a pulling force, coming to closest to the constraints.
        // optional constraints and inequalities works together.
        // when text field is hidden, background view collapses to around the button size; when text field is not hidden, background expands across the screen.
        searchBarTextFieldLayoutConstraint.priority = .defaultLow
        searchBarTextFieldLayoutConstraint.isActive = true
        
        searchBarButton.addTarget(self, action: #selector(searchBarButtonDidTap(_:)), for: .touchUpInside)
        searchBarButton.translatesAutoresizingMaskIntoConstraints = false
        searchBarButton.widthAnchor.constraint(equalTo: searchBarButton.heightAnchor).isActive = true
        // this makes the expansion animation text field anchor to the button
        // this constant must match the stackView.spacing, or else it would be an unsatisfied constraint
        searchBarButton.leadingAnchor.constraint(equalTo: searchBarTextField.trailingAnchor, constant: ViewController.defaultSearchBarStackViewSpacing).isActive = true
    }
    
    @objc func searchBarButtonDidTap(_ sender: Any) {
        self.view.layoutIfNeeded() // this one is recommended to make sure layout is updated before the animation
        UIView.animate(withDuration: 0.3) {
            if self.searchBarTextField.isHidden {
                self.tableViewTopConstraint?.isActive = false
                self.tableViewTopConstraint = self.tableView.topAnchor.constraint(equalTo: self.searchBarBackgroundView.bottomAnchor)
                self.tableViewTopConstraint?.isActive = true
                self.searchBarTextField.isHidden = false
                self.searchBarBackgroundView.layer.cornerRadius = 0
                self.searchBarBackgroundViewTopConstraint?.constant = ViewController.searchBarBackgroundViewNarrowMargin
                self.searchBarBackgroundViewTrailingConstraint?.constant = ViewController.searchBarBackgroundViewNarrowMargin
                self.searchBarStackViewTopConstraint?.constant = ViewController.searchBarStackViewWideMargin
                self.searchBarStackViewLeadingConstraint?.constant = ViewController.searchBarStackViewWideMargin
                self.searchBarStackViewTrailingConstraint?.constant = ViewController.searchBarStackViewWideMargin
                self.searchBarStackViewBottomConstraint?.constant = ViewController.searchBarStackViewWideMargin
            } else {
                self.tableViewTopConstraint?.isActive = false
                self.tableViewTopConstraint = self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
                self.tableViewTopConstraint?.isActive = true
                self.searchBarTextField.isHidden = true
                self.searchBarBackgroundView.layer.cornerRadius = ViewController.defaultSearchBarBackgroundViewCornerRadius
                self.searchBarBackgroundViewTopConstraint?.constant = ViewController.searchBarBackgroundViewWideMargin
                self.searchBarBackgroundViewTrailingConstraint?.constant = ViewController.searchBarBackgroundViewWideMargin
                self.searchBarBackgroundView.layer.cornerRadius = ViewController.defaultSearchBarBackgroundViewCornerRadius
                self.searchBarStackViewTopConstraint?.constant = ViewController.searchBarStackViewNarrowMargin
                self.searchBarStackViewLeadingConstraint?.constant = ViewController.searchBarStackViewNarrowMargin
                self.searchBarStackViewTrailingConstraint?.constant = ViewController.searchBarStackViewNarrowMargin
                self.searchBarStackViewBottomConstraint?.constant = ViewController.searchBarStackViewNarrowMargin
            }
            self.view.layoutIfNeeded() // this one is needed somehowmm, by Apple. there is small animation glitch without this line – the button shaking
        }
        
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
        cell.selectionStyle = .none
        switch indexPath.row % 2 {
        case 0:
            cell.backgroundColor = UIColor.init(red: 255 / 255, green: 119 / 255, blue: 130 / 255, alpha: 1)
        case 1:
            cell.backgroundColor = UIColor.init(red: 202 / 255, green: 234 / 255, blue: 255 / 255, alpha: 1)
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


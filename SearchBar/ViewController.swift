//
//  ViewController.swift
//  SearchBar
//
//  Created by Howie C on 4/26/19.
//  Copyright © 2019 Howie C. All rights reserved.
//

//  the main purpose is for demonstration of optional constraints and inequalities.
//  constraints in storyboard are for visual demonstration, removed at build time.
//  all constraints are set up in code.

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    static let defaultTableViewCellReuseIdentifier = "DefaultTableViewCell"
    static let defaultSearchBarBackgroundViewCornerRadius: CGFloat = 3
    static let searchBarBackgroundViewNarrowMargin: CGFloat = 0
    static let searchBarBackgroundViewWideMargin: CGFloat = 4
    static let searchBarStackViewNarrowSpacing: CGFloat = 4
    static let searchBarStackViewWideSpacing: CGFloat = 8
    static let searchBarStackViewNarrowMargin: CGFloat = 4
    static let searchBarStackViewWideMargin: CGFloat = 8
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBarBackgroundView: UIView!
    @IBOutlet weak var searchBarStackView: UIStackView!
    @IBOutlet weak var searchBarTextField: UITextField!
    @IBOutlet weak var searchBarButton: UIButton!
    
    let alphabetArray: Array = ["Α:α – alpha; transliterated as ‘a’", "Β:β – beta; transliterated as ‘b’", "Γ:γ – gamma; transliterated as ‘g’", "Δ:δ – delta; transliterated as ‘d’", "Ε:ε – epsilon; transliterated as ‘e’", "Ζ:ζ – zeta; transliterated as ‘z’", "Η:η – eta; transliterated as ‘e’ or ‘ē’", "Θ:θ – theta; transliterated as ‘th’", "Ι:ι – iota; transliterated as ‘i’", "Κ:κ – kappa; transliterated as ‘k’", "Λ:λ – lambda; transliterated as ‘l’", "Μ:μ – mu; transliterated as ‘m’", "Ν:ν – nu; transliterated as ‘n’", "Ξ:ξ – xi; transliterated as ‘x’", "Ο:ο omicron; transliterated as ‘o’", "Π:π – pi; transliterated as ‘p’", "Ρ:ρ – rho; transliterated as ‘r’ or (when written with a rough breathing) ‘rh’", "Σ:σ / ς(end of a word) sigma; transliterated as ‘s’", "Τ:τ – tau; transliterated as ‘t’", "Υ:υ – upsilon; transliterated as ‘u’ or (chiefly in English words derived through Latin) as ‘y’", "Φ:φ – phi; transliterated as ‘ph’ or (in modern Greek) ‘f’", "Χ:χ – chi; transliterated as ‘kh’ or ‘ch’", "Ψ:ψ – psi; transliterated as ‘ps’", "Ω:ω – omega; transliterated as ‘o’ or ‘ō’"]
    var filteredResultArray: [String] = []
    
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
        
        tableView.keyboardDismissMode = .interactive
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
        searchBarStackView.spacing = ViewController.searchBarStackViewNarrowSpacing
        searchBarStackView.translatesAutoresizingMaskIntoConstraints = false
        searchBarStackViewTopConstraint = searchBarStackView.topAnchor.constraint(equalTo: searchBarBackgroundView.topAnchor, constant: ViewController.searchBarStackViewNarrowMargin)
        searchBarStackViewTopConstraint?.isActive = true
        searchBarStackViewLeadingConstraint = searchBarStackView.leadingAnchor.constraint(equalTo: searchBarBackgroundView.leadingAnchor, constant: ViewController.searchBarStackViewNarrowMargin)
        searchBarStackViewLeadingConstraint?.isActive = true
        searchBarStackViewTrailingConstraint = searchBarBackgroundView.trailingAnchor.constraint(equalTo: searchBarStackView.trailingAnchor, constant: ViewController.searchBarStackViewNarrowMargin)
        searchBarStackViewTrailingConstraint?.isActive = true
        searchBarStackViewBottomConstraint = searchBarBackgroundView.bottomAnchor.constraint(equalTo: searchBarStackView.bottomAnchor, constant: ViewController.searchBarStackViewNarrowMargin)
        searchBarStackViewBottomConstraint?.isActive = true
        
        searchBarTextField.delegate = self
        searchBarTextField.addTarget(self, action: #selector(textFieldDidChangeEditing(_:)), for: .editingChanged)
        searchBarTextField.returnKeyType = .done
        searchBarTextField.clearButtonMode = .whileEditing
        // with a lower content hugging priority, text field expands while button stays the same
        searchBarTextField.setContentHuggingPriority(UILayoutPriority(249), for: .horizontal)
        // as text field has a content hugging priority of 751, which is larger than the button's compression resistance priority of 750, and the stack view's alignment is set to .fill, so the stack view will be set as tall as the text field
        // alternative: stackView.alignment = .center; one more constraint to make textField and button equal heights
        searchBarTextField.setContentHuggingPriority(UILayoutPriority(751), for: .vertical)
        searchBarTextField.translatesAutoresizingMaskIntoConstraints = false
        var searchBarTextFieldLayoutConstraint: NSLayoutConstraint
        searchBarTextFieldLayoutConstraint = searchBarTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor)
        // as the setup of the stack view, essentially, searchBarTextField.leadingAnchor = searchBarBackgroundView.leadingAnchor + 4
        // searchBarBackgroundView.leadingAnchor is a required constraint, so is it not possible to satify both; however, unsatisfied optional constraints act as a pulling force, coming to closest to the constraints.
        // optional constraints and inequalities works together.
        // when text field is hidden, background view collapses to around the button size; when text field is not hidden, background expands across the screen.
        searchBarTextFieldLayoutConstraint.priority = .defaultLow
        searchBarTextFieldLayoutConstraint.isActive = true
        // the optional constraint anchor its leading anchor to the view.safeAreaLayoutGuide.leadingAnchor
        // somehow, the animation has anchor point to the view.safeAreaLayoutGuide.leadingAnchor
        // this constraint forces text field animates along with the background view
        searchBarTextField.leadingAnchor.constraint(greaterThanOrEqualTo: searchBarBackgroundView.leadingAnchor).isActive = true
        
        searchBarButton.addTarget(self, action: #selector(searchBarButtonDidTap(_:)), for: .touchUpInside)
        searchBarButton.translatesAutoresizingMaskIntoConstraints = false
        searchBarButton.widthAnchor.constraint(equalTo: searchBarButton.heightAnchor).isActive = true
    }
    
    // MARK: - UITableViewDataSource Protocol
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isUsingFilteredResultArray() {
            return filteredResultArray.count
        } else {
            return alphabetArray.count
        }
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.defaultTableViewCellReuseIdentifier, for: indexPath)
     
     // Configure the cell...
        if isUsingFilteredResultArray() {
            cell.textLabel?.text = filteredResultArray[indexPath.row]
        } else {
            cell.textLabel?.text = alphabetArray[indexPath.row]
        }
        cell.textLabel?.textColor = UIColor.init(white: 0.4, alpha: 1)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.minimumScaleFactor = 0.8
        cell.textLabel?.allowsDefaultTighteningForTruncation = true
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
    
    // MARK: - UITableViewDelegate Protocol
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    // MARK: - UITextFieldDelegate Protocol
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !searchBarTextField.isHidden {
            setSearchBarHidden(true)
        }
    }
    
    // this method can be used for different search bar behaviour, e.g., keep search bar on screen while it is not first responder
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // instead of using searchBarTextField.resignFirstResponder(), keybaord dismissal animation is grouped with search bar dismissal animation
        setSearchBarHidden(!searchBarTextField.isHidden)
        return false
    }
    
    // MARK: -
    @objc private func textFieldDidChangeEditing(_ textField: UITextField) {
        populateFilteredResultArray(with: textField.text)
        tableView.reloadData()
    }
    
    private func populateFilteredResultArray(with string: String?) {
        if let searchString = string, !searchString.isEmpty {
            filteredResultArray = alphabetArray.filter({ (string) -> Bool in
                return string.lowercased().contains(searchString.lowercased())
            })
        } else {
            filteredResultArray = []
        }
    }
    
    func isUsingFilteredResultArray() -> Bool {
        return !searchBarTextField.isHidden && !(searchBarTextField.text?.isEmpty ?? true)
    }
    
    @objc private func searchBarButtonDidTap(_ sender: Any) {
        setSearchBarHidden(!searchBarTextField.isHidden)
    }
    
    private func setSearchBarHidden(_ hidden: Bool) {
        if searchBarTextField.isHidden != hidden {
            self.view.layoutIfNeeded() // this one is recommended to make sure layout is updated before the animation
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                if hidden {
                    self.tableViewTopConstraint?.isActive = false
                    self.tableViewTopConstraint = self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
                    self.tableViewTopConstraint?.isActive = true
                    self.searchBarTextField.isHidden = true
                    self.searchBarTextField.resignFirstResponder() // so that keyboard animation is grouped together
                    self.tableView.reloadData()
                    self.searchBarBackgroundView.layer.cornerRadius = ViewController.defaultSearchBarBackgroundViewCornerRadius
                    self.searchBarBackgroundViewTopConstraint?.constant = ViewController.searchBarBackgroundViewWideMargin
                    self.searchBarBackgroundViewTrailingConstraint?.constant = ViewController.searchBarBackgroundViewWideMargin
                    self.searchBarBackgroundView.layer.cornerRadius = ViewController.defaultSearchBarBackgroundViewCornerRadius
                    self.searchBarStackViewTopConstraint?.constant = ViewController.searchBarStackViewNarrowMargin
                    self.searchBarStackViewLeadingConstraint?.constant = ViewController.searchBarStackViewNarrowMargin
                    self.searchBarStackViewTrailingConstraint?.constant = ViewController.searchBarStackViewNarrowMargin
                    self.searchBarStackViewBottomConstraint?.constant = ViewController.searchBarStackViewNarrowMargin
                    self.searchBarStackView.spacing = ViewController.searchBarStackViewNarrowSpacing
                } else {
                    self.tableViewTopConstraint?.isActive = false
                    self.tableViewTopConstraint = self.tableView.topAnchor.constraint(equalTo: self.searchBarBackgroundView.bottomAnchor)
                    self.tableViewTopConstraint?.isActive = true
                    self.searchBarTextField.isHidden = false
                    self.searchBarTextField.becomeFirstResponder() // so that keyboard animation is grouped together
                    self.tableView.reloadData()
                    self.searchBarBackgroundView.layer.cornerRadius = 0
                    self.searchBarBackgroundViewTopConstraint?.constant = ViewController.searchBarBackgroundViewNarrowMargin
                    self.searchBarBackgroundViewTrailingConstraint?.constant = ViewController.searchBarBackgroundViewNarrowMargin
                    self.searchBarStackViewTopConstraint?.constant = ViewController.searchBarStackViewWideMargin
                    self.searchBarStackViewLeadingConstraint?.constant = ViewController.searchBarStackViewWideMargin
                    self.searchBarStackViewTrailingConstraint?.constant = ViewController.searchBarStackViewWideMargin
                    self.searchBarStackViewBottomConstraint?.constant = ViewController.searchBarStackViewWideMargin
                    self.searchBarStackView.spacing = ViewController.searchBarStackViewWideSpacing
                }
                self.view.layoutIfNeeded() // this one is needed somehowmm, by Apple. there is small animation glitch without this line – the button shaking
            }) { (finished) in
                // empty for now
            }
        }
    }
}

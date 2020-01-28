//
//  OnboardViewController.swift
//  Pepper
//
//  Created by Daniel Bernal on 17/10/19.
//  Copyright © 2019 Daniel Bernal. All rights reserved.
//

import UIKit

protocol ExceptionsViewControllerDelegate: class {
    func exceptionsViewControllerViewDidAppear()
    func exceptionsViewControllerViewDidDisappear()
}

class ExceptionsViewController: UIViewController, ExceptionsView, Storyboardeable {

    weak var delegate: ExceptionsViewControllerDelegate?
    var presenter: ExceptionsPresenter?

    // MARK: Properties
    let reuseIdentifier = "exceptionCell"
    let removeButtonText = "Delete"
    
    let alreadyExistsError = ErrorAlert(title: "Ooops!",
                                          text: "The domain you are trying to add already exists!",
                                          button: "OK")
    let invalidDomainError = ErrorAlert(title: "Ooops!",
                                   text: "The domain you are trying to add is invalid!",
                                   button: "OK")
    let genericError = ErrorAlert(title: "Ooops!",
                                   text: "Something bad ocurred.  Please try again!",
                                   button: "OK")
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addRuleTxt: UITextField!
    @IBOutlet weak var addRuleBtn: UIButton!
    @IBOutlet weak var addHeaderView: UIView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.attachView(view: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.exceptionsViewControllerViewDidAppear()
        configureUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.exceptionsViewControllerViewDidDisappear()
    }
    
    @IBAction func addRuleBtnTapped(_ sender: Any) {
        guard let text = addRuleTxt.text else { return }
        addRule(domain: text)
        
    }
   
    // MARK: ExceptionsView
    func notifyAddRuleError(message: ErrorAlert) {
        presentAlertWithMessage(message: message)
    }
    
    func resetForm() {
        addRuleTxt.text = ""
        self.view.endEditing(true)
    }
    
    func configureUI() {
        addRuleTxt.delegate = self
        
    }
    
    // MARK: Utility
    func addRule(domain: String) {
         presenter?.addRule(domain: domain, completion: { (result) in
             switch result {
             case .success:
                 DispatchQueue.main.async {
                     self.resetForm()
                     self.tableView.reloadData()
                 }
             case .failure(let error):
                 DispatchQueue.main.async {
                     switch error {
                     case .recordExists:
                         self.notifyAddRuleError(message: self.alreadyExistsError)
                     case .invalidDomain:
                         self.notifyAddRuleError(message: self.invalidDomainError)
                     default:
                         self.notifyAddRuleError(message: self.genericError)
                     }
                 }
             }
         })
     }
    
}

extension ExceptionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.totalRules() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rule = presenter?.rule(atIndex: indexPath)
        let cell = UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        cell.textLabel?.text = rule
        return cell
    } 
}

extension ExceptionsViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {}

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = addRuleTxt.text else { return true }
        addRule(domain: text)
        resetForm()
        return true
    }
}

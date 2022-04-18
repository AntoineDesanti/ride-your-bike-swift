//
//  SearchViewController.swift
//  ride-your-bike
//
//  Created by Antoine Desanti on 10/04/2022.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var exitButton: UIButton!
    weak var delegate: ViewController!
    
    @IBOutlet weak var startPointField: UITextField!
    @IBOutlet weak var endPointField: UITextField!
    @IBOutlet weak var startSearchButton: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isOpaque = false
        view.backgroundColor = .clear
        exitButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        startSearchButton.addTarget(self, action: #selector(launchSearch), for: .touchUpInside)
    }
    
    @objc fileprivate func closeView(){
        self.dismiss(animated: false, completion: nil)
        delegate.closeSearchView()
    }
    
    @objc fileprivate func launchSearch(){
        closeView()
        delegate.subSearchMethod(startPointString: startPointField.text!, endPointString: endPointField.text!)
    }
    

}

//
//  SearchViewController.swift
//  HobPl
//
//  Created by Никита on 18.02.2021.
//  Copyright © 2021 BmjCstms. All rights reserved.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBarForNewItems: UISearchBar!
    @IBOutlet weak var resultTableView: UITableView!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBAction func isPressedCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var namesArray: [String] = []
    var filteredNames: [String] = []
   
    var networkService = NetworkService()
    
    var delegateVC: UpdateVCProtocol?
    
    let realm = try! Realm()
    var dataOfPlaces: Results<NoteOfPlace>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarForNewItems.delegate = self
        searchBarForNewItems.placeholder = "Search"
        
        resultTableView.delegate = self
        resultTableView.dataSource = self
        
        closeButton.setTitle("Close", for: .normal)
        //Mark: load array of cities names from geo api
        networkService.loadDataOfPlaces { [self] (data) in
        
            guard let data = data else { return }
            self.namesArray = data
            DispatchQueue.main.sync {
                self.filteredNames = namesArray
                self.resultTableView.reloadData()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Mark: filtering search text and array of loaded names
        if searchText.isEmpty == false {
                filteredNames = namesArray.filter({ $0.contains(searchText) })
        } else {
            filteredNames = namesArray
        }
        resultTableView.reloadData()
    }
    //Mark: whith search button on keyboard adding new item to Realm, update data in ViewController
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBarForNewItems.resignFirstResponder()
        guard let addingName = searchBar.text else { return }
        try! self.realm .write {
            let newValue = NoteOfPlace()
            newValue.itemName = addingName
            self.realm.add(newValue.self)
        }
        delegateVC?.updateVC()
        dismiss(animated: true, completion: nil)
    }
    
}

extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityName", for: indexPath)
        cell.textLabel?.text = filteredNames[indexPath.row]
        return cell
    }
    //Mark: adding new item from filtered data pressing to tableview cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let indexPath = resultTableView.indexPathForSelectedRow else { return }
        try! self.realm .write {
            let newValue = NoteOfPlace()
            newValue.itemName = filteredNames[indexPath.row]
            self.realm.add(newValue.self)
        }
        delegateVC?.updateVC()
        dismiss(animated: true, completion: nil)
    }
}


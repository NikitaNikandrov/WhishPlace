//
//  ViewController.swift
//  HobPl
//
//  Created by Никита on 12.07.2020.
//  Copyright © 2020 BmjCstms. All rights reserved.
//

import UIKit
import RealmSwift

protocol UpdateVCProtocol: AnyObject {
    func updateVC()
}

class ViewController: UIViewController, UpdateVCProtocol {
    //Mark: Realm
    let realm = try! Realm()
    var dataOfPlaces: Results<NoteOfPlace>!
    
    @IBOutlet weak var myPlacesTable: UITableView!
    
    @IBAction func pushAdd(_ sender: Any) {
        //Mark: going to SearchVC pushing add button
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let searchVC = storyboard.instantiateViewController(identifier: "SearchViewController") as? SearchViewController else { return }
        searchVC.delegateVC = self
        self.present(searchVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myPlacesTable.delegate = self
        myPlacesTable.dataSource = self
        //Mark: download data from Realm
        dataOfPlaces = realm.objects(NoteOfPlace.self)
    }
    //Mark: this method updates ViewCintroller when in SearchVC added new item
    func updateVC() {
        DispatchQueue.main.async {
            self.realm.refresh()
            self.dataOfPlaces = self.realm.objects(NoteOfPlace.self)
        }
        myPlacesTable.reloadData()
    }
    //Mark: going to DetailVC when tebleview cell was pushed
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(identifier: "DeteilViewController") as? DetailViewController else { return }
        
        let item = dataOfPlaces[indexPath.row]
        
        detailVC.selectedPlaceName = item.itemName
        detailVC.indexOfItem = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        show(detailVC, sender: nil)
    }
    //Mark: delete tableview cell whith swipe
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! self.realm.write{
                let dellItem = dataOfPlaces[indexPath.row]
                self.realm.delete(dellItem)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else { return }
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataOfPlaces.count != 0 {
            return dataOfPlaces.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeNameCell", for: indexPath)
        let item = dataOfPlaces[indexPath.row]
        cell.textLabel?.text = item.itemName
        return cell
    }
}

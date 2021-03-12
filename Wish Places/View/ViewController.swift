//
//  ViewController.swift
//  HobPl
//
//  Created by Никита on 12.07.2020.
//  Copyright © 2020 BmjCstms. All rights reserved.
//

import UIKit
import RealmSwift

protocol UpdateViewController {
    func updateVC()
}

class ViewController: UIViewController, UpdateViewController {
    
    let realm = try! Realm()
    var dataOfPlaces: Results<NoteOfPlace>! // контейнер свойств реалм
    
    @IBOutlet weak var myPlacesTable: UITableView!
    
    @IBAction func pushAdd(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let noteOfPlaceViewController = storyboard.instantiateViewController(identifier: "SearchViewController") as? SearchViewController else { return }
        noteOfPlaceViewController.delegateVC = self
        self.present(noteOfPlaceViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myPlacesTable.delegate = self
        myPlacesTable.dataSource = self
        dataOfPlaces = realm.objects(NoteOfPlace.self)
    }
    
    func updateVC() {
        DispatchQueue.main.async {
            self.realm.refresh()
            self.dataOfPlaces = self.realm.objects(NoteOfPlace.self)
        }
        myPlacesTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(identifier: "DeteilViewController") as? DetailViewController else { return }
        
        let item = dataOfPlaces[indexPath.row]
        
        detailVC.selectedPlaceName = item.itemName
        detailVC.indexOfItem = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        show(detailVC, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // функция удаления ячейки таблицы
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
        let item = dataOfPlaces[indexPath.row] // создаем экземпляр по индексу из массива реалм
        cell.textLabel?.text = item.itemName
        return cell
    }
}

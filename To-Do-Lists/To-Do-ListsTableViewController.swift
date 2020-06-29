//
//  To-Do-ListsTableViewController.swift
//  To-Do-Lists
//
//  Created by Adithep on 6/28/20.
//  Copyright © 2020 Adithep. All rights reserved.
//

import UIKit
import CoreData

class To_Do_ListsTableViewController: UITableViewController {

    var toDo = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItem()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return toDo.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath)
        cell.textLabel?.text = toDo[indexPath.row].title
        if toDo[indexPath.row].done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if toDo[indexPath.row].done == true {
            toDo[indexPath.row].done = false
        } else {
            toDo[indexPath.row].done = true
        }
        
        saveItem()
    }
    
    //MARK: - Add button actions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.toDo.append(newItem)
            self.saveItem()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (cancel) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New Item.."
            textField = alertTextField
        }
        alert.addAction(cancel)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Save Item
    func saveItem() {
        do {
            try context.save()
        } catch {
            print("Error saving data \(error)")
        }
        self.tableView.reloadData()
    }
    
    //MARK: - Load Item
    func loadItem() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            toDo = try context.fetch(request)
        } catch {
            print("Error fetching data \(error)")
        }
    }
}

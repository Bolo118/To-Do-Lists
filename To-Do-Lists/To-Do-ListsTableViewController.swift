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
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        // edit item
        let edit = UIAlertAction(title: "Edit", style: .default) { (edit) in
            var textField = UITextField()
            let alert = UIAlertController(title: "Edit", message: nil, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let edit = UIAlertAction(title: "Edit", style: .default) { (edit) in
                self.toDo[indexPath.row].title = textField.text!
                self.saveItem()
            }
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Edit Item.."
                textField = alertTextField
            }
            alert.addAction(cancel)
            alert.addAction(edit)
            self.present(alert, animated: true, completion: nil)
        }
        
        // delete item
        let delete = UIAlertAction(title: "Delete", style: .default) { (delete) in
            let alert = UIAlertController(title: "Delete", message: nil, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let delete = UIAlertAction(title: "Delete", style: .default) { (delete) in
                self.context.delete(self.toDo[indexPath.row])
                self.toDo.remove(at: indexPath.row)
                self.saveItem()
            }
            alert.addAction(cancel)
            alert.addAction(delete)
            self.present(alert, animated: true, completion: nil)
        }
        
        // Cancel button
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Edit button
        alert.addAction(edit)
        
        // Delete button
        alert.addAction(delete)
        
        
        present(alert, animated: true, completion: nil)
        saveItem()
    }
    
    //MARK: - Add button actions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.toDo.append(newItem)
            self.saveItem()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
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
        tableView.reloadData()
    }
    
}

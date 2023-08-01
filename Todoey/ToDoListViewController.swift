//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var itemArray = [Item]()
    var selectedCategory : Catagory? {
        //변경된 직후 호출
        didSet{
            loadItems()
        }
    }
    
    
    let defaults = UserDefaults.standard
    //dataFilePath
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    @IBOutlet weak var slkslsdklsd: UINavigationItem!
    //CoreData context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigation Bar Setting
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.systemBlue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        
        
//        loadItems()
        
//        self.tableView.reloadData()
        
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField : UITextField = UITextField()
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the Add Item button on our alert
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCatagory = self.selectedCategory
            
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            self.loadItems()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
        }

        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)

    }
    
    //MARK - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // Fetch a cell of the appropriate type.
       let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
       
       let item = itemArray[indexPath.row]
       // Configure the cell’s contents.
        cell.textLabel!.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        if item.done == true {
            cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
        }

       return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        //Update Completed Title
//        itemArray[indexPath.row].setValue("Completed", forKey: "title")
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        
    }
    
//    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .delete
//    }
//
//    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            // Delete 순서 중요 context 제거 후
//            context.delete(itemArray[indexPath.row])
//            itemArray.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }

    
    func saveItems() {
//        let encoder = PropertyListEncoder()
        do {
//            let data = try encoder.encode(self.itemArray)
//            try data.write(to : self.dataFilePath!)
            try context.save()
        }catch{
            print("Error Encoding item Array")
        }
  
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        //userDefault Load
//        if let data = try? Data(contentsOf: dataFilePath!){
//            let decoder = PropertyListDecoder()
//
//            do {
//                itemArray = try decoder.decode([Item].self, from: data)
//            }catch{
//                print("Error Decoding Item")
//            }
//
//        }

        
        let categoryPredicate = NSPredicate(format: "parentCatagory.name MATCHES %@", selectedCategory!.name!)
    
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
            print("Load Items::::::::::::::::",try context.fetch(request))
            tableView.reloadData()
        }catch {
            print("Error Load Item \(error)")
        }
        

        
    }
    
  
    
}

//MARK - SearchBarDelegate Methods

extension ToDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        let prediacte = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key : "title", ascending: true)]
   
        loadItems(with : request , predicate: prediacte)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
    
}



////MARK - TableView Datasouorce Methods
//extension ToDoListViewController : UITableViewDataSource {
//    // Return the number of rows for the table.
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//       return 0
//    }
//
//    // Provide a cell object for each row.
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//       // Fetch a cell of the appropriate type.
//       let cell = tableView.dequeueReusableCell(withIdentifier: "cellTypeIdentifier", for: indexPath)
//
//       // Configure the cell’s contents.
//       cell.textLabel!.text = "Cell text"
//
//       return cell
//    }
//
//
//
//}


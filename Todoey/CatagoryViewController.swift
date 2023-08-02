//
//  CatagoryViewController.swift
//  Todoey
//
//  Created by 강신규 on 2023/07/31.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CatagoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories = [Category]()
    
    
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
        
//        loadCategories()

    }
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        var textField : UITextField = UITextField()
        let alert = UIAlertController(title: "Add New Todo Catagory", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Catagory", style: .default) { (action) in
            // what will happen once the user clicks the Add Item button on our alert

            let newCatagory = Category()
            newCatagory.name = textField.text!
            self.categories.append(newCatagory)

            self.save(category: newCatagory)

            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Catagory"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK - Save Data Load Data
    func save(category : Category) {
        do {
            try realm.write{
                realm.add(category)
            }
        }catch{
            print("Error Encoding Catagory Array")
        }
  
    }
    
//    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
//        do {
//            categories = try context.fetch(request)
//            print("Load Items::::::::::::::::",try context.fetch(request))
//            tableView.reloadData()
//        }catch {
//            print("Error Load Catagory \(error)")
//        }
//    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatagoryCell", for: indexPath)

        let category = categories[indexPath.row]
        // Configure the cell’s contents.
        cell.textLabel!.text = category.name

        return cell
    }
    
    
    // MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        goToItems
        performSegue(withIdentifier: "goToItems", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
             
        }
        
    }

}

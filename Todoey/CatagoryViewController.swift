//
//  CatagoryViewController.swift
//  Todoey
//
//  Created by 강신규 on 2023/07/31.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CatagoryViewController: SwipteTableViewController {

    
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationSetting()
        loadCategories()
        
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        
    }
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        var textField : UITextField = UITextField()
        let alert = UIAlertController(title: "Add New Todo Catagory", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Catagory", style: .default) { (action) in
            // what will happen once the user clicks the Add Item button on our alert

            let newCatagory = Category()
            newCatagory.name = textField.text!
            newCatagory.backgroundColorHexValue = UIColor.randomFlat().hexValue()
            
            self.save(category: newCatagory)

            DispatchQueue.main.async {
                self.loadCategories()
                
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
            print("Error Save Category")
        }
  
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK - Delete Data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let category = self.categories?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(category)
                }
            }catch{
                print("Error Delete Category, \(error)")
            }
        }
    }
    
    
    func navigationSetting(){
        //navigation Bar Setting
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.systemBlue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
    }
 
    
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //Nil Coalescing Operator
        //Not nil return categories count
        //if nil return 1
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories Added  Yet"
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].backgroundColorHexValue ?? "0xFFFFFF")
        
        return cell
    }
    
//    //MARK - Swipe Library
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
//
    

    
    // MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
            
        }
        
    }

}



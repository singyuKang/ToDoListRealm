//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipteTableViewController  {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        //변경된 직후 호출
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
        //pop navigation gesture delegate
//        navigationController?.interactivePopGestureRecognizer?.delegate = self
//        loadItems()
        
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
 
        if let colourHex = selectedCategory?.backgroundColorHexValue {
               
            title = selectedCategory!.name
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist.")}
         
            //navigation Bar Setting
            if let navBarColour = UIColor(hexString: colourHex){
//                let appearance = UINavigationBarAppearance()
//                navBar.backgroundColor = UIColor(hexString: colourHex)
//                appearance.configureWithTransparentBackground()
//                appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//                navigationItem.standardAppearance = appearance
//                navigationItem.scrollEdgeAppearance = appearance
                
                searchBar.tintColor = navBarColour
                navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
//                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
            }
            
        
            
            
//            navigationItem.hidesBackButton = true
//            navigationItem.setHidesBackButton(true, animated: true)
            
            
        }
    }
    
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField : UITextField = UITextField()
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the Add Item button on our alert

            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error Saving New Items, \(error)")
                }
            }
            
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
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // Fetch a cell of the appropriate type.
//        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
    
        if let item = todoItems?[indexPath.row] {

            cell.itemLabel?.text = item.title
            cell.ItemCheckRight.isHidden = item.done ? false : true
            
   
        }else{
            cell.textLabel?.text = "No Items Added"
        }
//        cell.accessoryType = .checkmark
  
       return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if let item = todoItems?[indexPath.row] {
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print("Error saving done status")
            }
        }
        
        
//        tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let item = todoItems?[indexPath.row]{
                do{
                    try realm.write{
                        realm.delete(item)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }catch{
                    print("Error Delete Item, \(error)")
                }
            }

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    
    func saveItems(item : Item) {
        do {
            try realm.write{
                realm.add(item)
            }
        }catch{
            print("Error Save Items")
        }
  
    }
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
//        print("todoItems:::::::::::", todoItems)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.todoItems?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(item)
                }
            }catch{
                print("Error Delete Item, \(error)")
            }
        }
    }
}

//MARK - SearchBarDelegate Methods

extension ToDoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
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




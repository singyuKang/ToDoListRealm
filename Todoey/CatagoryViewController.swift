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
import SwiftUI

class CatagoryViewController: SwipteTableViewController {

    
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    deinit {
//        NotificationCenter.default.removeObserver()
        print("deinit CatagoryViewController")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loadCategories()
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 80
        tableView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: "CategoryCell")
        // Drag & Drop 기능을 위한 부분
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist.")}
        navigationSetting()
        navBar.titleTextAttributes = [.foregroundColor : UIColor.white]
    }

    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        var textField : UITextField = UITextField()
        let alert = UIAlertController(title: "Add New Todo Catagory", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Catagory", style: .default) { (action) in
            // what will happen once the user clicks the Add Item button on our alert

            let newCatagory = Category()
            newCatagory.name = textField.text!
            newCatagory.backgroundColorHexValue = UIColor.randomFlat().hexValue()
            newCatagory.CategoryIndex = self.categories?.count ?? 0
            
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
        categories = realm.objects(Category.self).sorted(byKeyPath: "CategoryIndex", ascending: true)
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
        appearance.backgroundColor = UIColor(hexString: "#D980FA")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
    }
    
    //MARK - tableView Delete
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        UIApplication.shared.showAlert(title: "", message: "카테고리를 삭제하시겠습니까?", hideCancel: false, cancelTitle: "취소", confirmTitle: "확인", cancelHandler: nil, confirmHandler: {
            if editingStyle == .delete {
                if let category = self.categories?[indexPath.row]{
                    do{
                        try self.realm.write{
                            self.realm.delete(category)
                            tableView.deleteRows(at: [indexPath], with: .fade)
                        }
                    }catch{
                        print("Error Delete category, \(error)")
                    }
                }

            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }
        })
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
        
//        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        
        if let category = categories?[indexPath.row] {
            
//            guard let categoryColour = UIColor(hexString: category.backgroundColorHexValue) else {fatalError("category backgroundColorHexValue  cell Color Setting Error")}
            cell.categoryLabel?.text = category.name
            cell.categoryLabel?.textColor = UIColor(hexString: "#778ca3")
            cell.selectionStyle = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        do {
            try realm.write{
//                realm.add(category)
                categories?[sourceIndexPath.row].CategoryIndex = destinationIndexPath.row
                categories?[destinationIndexPath.row].CategoryIndex = sourceIndexPath.row
            }
        }catch{
            print("Error Save categories?[sourceIndexPath.row]")
        }
    }

    // MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        NotificationCenter.default.post(name: CatagoryViewController.newCatagoryInsert, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }

}


//MARK - UITableView UITableViewDragDelegate
extension CatagoryViewController : UITableViewDragDelegate{
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}

// MARK:- UITableView UITableViewDropDelegate
extension CatagoryViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) { }
}

extension CatagoryViewController {
    static let newCatagoryInsert = Notification.Name(rawValue : "newCatagoryInsert")
}
 






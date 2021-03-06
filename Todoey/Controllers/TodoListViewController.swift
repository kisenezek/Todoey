//
//  ViewController.swift
//  Todoey
//
//  Created by Zsobrák Patrik on 2019. 01. 02..
//  Copyright © 2019. Zsobrák Patrik. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    
    var itemArray = [Item]()

    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // delegate the UI serch bar
        
      
        
       // print(dataFilePath)
        
      //  let newItem = Item()
       // newItem.title = "Find Mike"
       // //newItem.done = true
       // itemArray.append(newItem)
        
        
        //rbetöltés a item.plistből
       
    
        
    
        // Do any additional setup after loading the view, typically from a nib.
        
     //   if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
      //      itemArray = items
       // }
    }
  
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        
        //ternary operator ==
        // value = condition ? valueIfTRUE : valueIfFALSE
        
        cell.accessoryType =  item.done ? .checkmark : .none
        
        // Ezzel a felső sorral lehet kihelyetesíteni.
      //  if item.done == true {
      //      cell.accessoryType = .checkmark
      //  }
      //  else{
     //       cell.accessoryType = .none
     //   }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
         //context.delete(itemArray.remove(at: indexPath.row))
      //itemArray.remove(at: indexPath.row)
        
       
        
       // itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    
        saveItems()
        
     
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todexy Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once on the
            
           
        
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
         self.saveItems()
           // self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
           
           
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }


func saveItems()
{
    
    
    do {
        
       try context.save()
        
    }
    catch {
        print("Error encoding item array")
    }
    
    self.tableView.reloadData()
}
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest() , predicate : NSPredicate? = nil)
   {
    
    let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
    //let request : NSFetchRequest<Item>  = Item.fetchRequest()
    
    if let additionalPredicate = predicate { request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        
        
    }else{
        
        request.predicate = categoryPredicate
    }
    
    
   // let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
   // request.predicate = compoundPredicate
    do {
     itemArray = try  context.fetch(request)
    
    }catch {
        print("Error Fetching data from context")
        }
    
    tableView.reloadData()
    }
   

}

//MARK: - Searchbar Method

extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let  predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //order
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request , predicate : predicate)
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            
            
            // visszaállítja a billentyűzertet, meg megszakítja a threadet.. illetve  visszaállítja a curzort a kereső funkcióba.
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

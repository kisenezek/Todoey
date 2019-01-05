//
//  ViewController.swift
//  Todoey
//
//  Created by Zsobrák Patrik on 2019. 01. 02..
//  Copyright © 2019. Zsobrák Patrik. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    
    var itemArray = [Item]()
       let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        
       // print(dataFilePath)
        
      //  let newItem = Item()
       // newItem.title = "Find Mike"
       // //newItem.done = true
       // itemArray.append(newItem)
        
        
        //rbetöltés a item.plistből
        loadItems()
        
    
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
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    
        saveItems()
        
     
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todexy Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once on the
            
            let newItem = Item()
            newItem.title = textField.text!
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
    let encoder = PropertyListEncoder()
    
    do {
        let data = try encoder.encode(itemArray)
        try data.write(to: dataFilePath!)
        
    }
    catch {
        print("Error encoding item array")
    }
    
    self.tableView.reloadData()
}
    
    func loadItems()
    {
        
        if  let data = try? Data(contentsOf: dataFilePath!){
          let decoder = PropertyListDecoder()
            do{
            itemArray =  try decoder.decode([Item].self, from: data)
        } catch {
            print("Error with decode")
        }
        }
      
        
    
}
}

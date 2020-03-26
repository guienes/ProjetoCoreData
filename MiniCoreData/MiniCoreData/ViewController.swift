//
//  ViewController.swift
//  MiniCoreData
//
//  Created by Guilherme Enes on 26/03/20.
//  Copyright © 2020 Guilherme Enes. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var people: [NSManagedObject] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Lista de coisas aleatórias"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        //3
        do {
          people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    @IBAction func addName(_ sender: Any) { //adiciona um nome
        
        let alert = UIAlertController(title: "Novo nome",
                                      message: "Adicione um novo nome",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
          [unowned self] action in
          
          guard let textField = alert.textFields?.first,
            let nameToSave = textField.text else {
              return
          }
          
          self.save(name: nameToSave)
          self.tableView.reloadData()   //atualiza table view
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar",
                                         style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func save(name: String){
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }

        let managedContext =
          appDelegate.persistentContainer.viewContext

        let entity =
          NSEntityDescription.entity(forEntityName: "Person",
                                     in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        person.setValue(name, forKeyPath: "name")
        
        do {
          try managedContext.save()
          people.append(person)
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return people.count
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath)
                 -> UITableViewCell {

    let person = people[indexPath.row]
    let cell =
      tableView.dequeueReusableCell(withIdentifier: "Cell",
                                    for: indexPath)
    cell.textLabel?.text =
      person.value(forKeyPath: "name") as? String //procura na entidade Person o atributo name, e pega seu valor.
    return cell
  }
}


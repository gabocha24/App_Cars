//
//  AppDelegate.swift
//  CattalogoAPPCars
//
//  Created by Mane on 26/04/19.
//  Copyright © 2019 UTNG. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //creating a cell using the custom class
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        
        //the artist object
        let car: Car
    
        //getting the artist of selected position
        car = carList[indexPath.row]
        
        //adding values to labels
        cell.lblMarca.text = car.marca
        cell.lblModelo.text = car.modelo
        cell.lblColor.text = car.color
        cell.lblTransmision.text = car.transmision
       
        //returning cell
        return cell
    }
     var carList = [Car]()
    
    @IBOutlet weak var textFieldMarca: UITextField!
    @IBOutlet weak var textFieldmodelo: UITextField!
    @IBOutlet weak var textFieldColor: UITextField!
    @IBOutlet weak var textFieldTransmision: UITextField!

    @IBOutlet weak var tblCars: UITableView!
    @IBAction func buAdd(_ sender: UIButton) {
        addCar()
    }
    
    @IBOutlet weak var labelMessage: UILabel!
    
    //this function will be called when a row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //getting the selected artist
        let car  = carList[indexPath.row]
        
        //building an alert
        let alertController = UIAlertController(title: car.marca, message: "Dame los valores a Actualizar", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Actualizar", style: .default) { (_) in
            
            //getting artist id
            let id = car.id
            
            //getting new values
            let marca = alertController.textFields?[0].text
            let modelo = alertController.textFields?[1].text
            let color = alertController.textFields?[2].text
            let transmision = alertController.textFields?[3].text
    
            //calling the update method to update artist
        
            
            self.updateCar(id: id!, marca: marca!, modelo: modelo!, color: color!, transmision: transmision!)
        }
        
        let cancelAction = UIAlertAction(title: "Eliminar", style: .cancel) { (_) in
            //deleting artist
            self.deletePerson(id: car.id!)
        }
        //adding two textfields to alert
        alertController.addTextField { (textField) in
            textField.text = car.marca
        }
        alertController.addTextField { (textField) in
            textField.text = car.modelo
        }
        alertController.addTextField { (textField) in
            textField.text = car.color
        }
        alertController.addTextField { (textField) in
            textField.text = car.transmision
        }
      
        //adding action
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //presenting dialog
        present(alertController, animated: true, completion: nil)
    }
    
    func updateCar(id:String, marca:String, modelo:String, color:String, transmision: String){
        //creating artist with the new given values
        let car =     ["id":id,
                      "marca": marca,
                      "modelo": modelo,
                      "color": color,
                      "transmision":transmision
        ]
        
        //updating the artist using the key of the artist
        refCars.child(id).setValue(car)
        
    }
    
    func deletePerson(id:String){
        refCars.child(id).setValue(nil)
        
    }
    
    
    var refCars: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        FirebaseApp.configure()
        
        //getting a reference to the node artists
        refCars = Database.database().reference().child("Cars");
        
        //observing the data changes
        refCars.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.carList.removeAll()
                
                //iterating through all the values
                for cars in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let carObject = cars.value as? [String: AnyObject]
                    let id  = carObject?["id"]
                    let marca  = carObject?["marca"]
                    let modelo = carObject?["modelo"]
                    let color = carObject?["color"]
                    let transmision = carObject?["transmision"]
                    
                    //creating artist object with model and fetched values
                    let car =    Car(id: id as! String,
                                     marca: marca as! String,
                                     modelo: modelo as! String,
                                     color: color as! String,
                                     transmision: transmision as! String)
                    
                    //appending it to list
                    self.carList.append(car)
                }
                //reloading the tableview
                self.tblCars.reloadData()
            }
        })
    }
    
    func addCar(){
        let key = refCars.childByAutoId().key
    
        let car =     ["id":key,
                      "marca": textFieldMarca.text! as String,
                      "modelo": textFieldmodelo.text! as String,
                      "color": textFieldColor.text! as String,
                      "transmision": textFieldTransmision.text! as String
                      ]
        
        refCars.child(key ?? "oilo").setValue(car)
    }
}

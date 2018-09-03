//
//  CreatVC.swift
//  Art Book(Coredata)
//
//  Created by Alper on 30.08.2018.
//  Copyright © 2018 Alper. All rights reserved.
//

import UIKit
import CoreData

class CreatVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var paintingTextField: UITextField!
    @IBOutlet weak var artistTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    
    var chosenPainting = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if chosenPainting != "" {
           
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
            fetchRequest.predicate = NSPredicate(format: "name = %@", self.chosenPainting)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results =  try context.fetch(fetchRequest)
                
                if results.count > 0 {
                    for result in results as! [NSManagedObject]{
                        if let name = result.value(forKey: "name") as? String {
                            self.paintingTextField.text = name
                        }
                        
                        if let artist = result.value(forKey: "artist") as? String {
                            self.artistTextField.text = artist
                        }
                        
                        if let year = result.value(forKey: "year") as? Int {
                            self.yearTextField.text = String(year)
                        }
                        
                        
                        if let imageData = result.value(forKey: "image") as? Data {
                            let image = UIImage(data: imageData)
                            self.imageView.image = image!
                        }
                    }
                }
                
                
            } catch {
                print("ERROR")
            }
            
            
            
        } else {
            self.imageView.image = UIImage(named: "tapme")
            self.paintingTextField.text = ""
            self.artistTextField.text = ""
            self.yearTextField.text = ""
        }
        
        paintingTextField.delegate = self
        artistTextField.delegate = self
        yearTextField.delegate = self

        
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newArt = NSEntityDescription.insertNewObject(forEntityName: "Paintings", into: context)
        
        newArt.setValue(paintingTextField.text, forKey: "name")
        newArt.setValue(artistTextField.text, forKey: "artist")
        
        if let year = Int(yearTextField.text!) {
             newArt.setValue(year, forKey: "year")
        }

        let data = UIImageJPEGRepresentation(imageView.image!, 0.5)
        newArt.setValue(data, forKey: "image")
        
        do{
          try context.save()
            print("We managed to save context successfully")
        } catch {
        print("ERROR")
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "paintingCreated"), object: nil)
        self.navigationController?.popViewController(animated: true)

    }
    
    
    @objc func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate  = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

}


extension CreatVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
}

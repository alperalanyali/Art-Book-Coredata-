//
//  ViewController.swift
//  Art Book(Coredata)
//
//  Created by Alper on 30.08.2018.
//  Copyright © 2018 Alper. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var nameArray = [String]()
    var artistArray = [String]()
    var yearArray = [Int]()
    var imageArray = [UIImage]()
    var selectectedPainting = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        retieveInfo()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.retieveInfo), name: NSNotification.Name(rawValue: "paintingCreated"), object: nil)
    }
    
    @objc func retieveInfo(){
        
        self.nameArray.removeAll(keepingCapacity: false)
        self.artistArray.removeAll(keepingCapacity: false)
        self.yearArray.removeAll(keepingCapacity: false)
        self.imageArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
        
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    
                    if let name = result.value(forKey: "name") as? String {
                        self.nameArray.append(name)
                    }
                    
                    
                    if let artist = result.value(forKey: "artist") as? String {
                        self.artistArray.append(artist)
                    }
                    
                    if let year = result.value(forKey: "year") as? Int {
                        self.yearArray.append(year)
                    }
                    
                    if let imageData = result.value(forKey: "image") as? Data {
                       let image = UIImage(data: imageData)
                        self.imageArray.append(image!)
                    }
                    
                    self.tableView.reloadData()
                }
            }
            
        } catch {
            print("ERROR in fetching data from Coredata")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCreateVC"{
            let destinationVC = segue.destination as! CreatVC
            destinationVC.chosenPainting = self.selectectedPainting
        }
    }
    @IBAction func addButtonPresssed(_ sender: Any) {
        performSegue(withIdentifier: "toCreateVC", sender: nil)
        self.selectectedPainting = ""
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectectedPainting = nameArray[indexPath.row]
        performSegue(withIdentifier: "toCreateVC", sender: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }
}


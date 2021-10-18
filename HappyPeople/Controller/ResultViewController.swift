//
//  ResultViewController.swift
//  HAPPYPEOPLE
//
//  Created by SHORT on 29/8/21.
//

import UIKit
class ResultViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var resultImgView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var resultProcessor = ResultProcessor()
    var people : [Person] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Receive data from Main view
        NotificationCenter.default.addObserver(self, selector: #selector(didGetImg(_:)), name: Notification.Name("img"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetText(_:)), name: Notification.Name("text"), object: nil)
        
        // Set table view data source and register UI view for cell
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PersonCell", bundle: nil), forCellReuseIdentifier: "TableCell")
    }
    
    // Receive data from Main view
    @objc func didGetImg(_ notification: Notification) {
        let gotImage = notification.object as! UIImage?
        resultImgView.image = gotImage
        print("Display received image")
    }
    
    // Receive data from Main view
    @objc func didGetText(_ notification: Notification) {
        let gotText = notification.object as! Data
        people = resultProcessor.getPeople(result: gotText)
        DispatchQueue.main.async {
            self.tableView.reloadData()
            print("Display received text")
        }
    }
    
}

// Controller for table view
extension ResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! PersonCell
        cell.person.text = people[indexPath.row].id
        cell.age.text = people[indexPath.row].age
        cell.gender.text = people[indexPath.row].gender
        cell.ethnicity.text = people[indexPath.row].ethnicity
        cell.emotion.text = people[indexPath.row].emotion
        return cell
    }
}

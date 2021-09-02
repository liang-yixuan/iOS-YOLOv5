//
//  ResultViewController.swift
//  RUOK
//
//  Created by SHORT on 29/8/21.
//

import UIKit
class ResultViewController: UIViewController {
    @IBOutlet weak var resultImgView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var resultProcessor = ResultProcessor()
    var people : [Person] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didGetImg(_:)), name: Notification.Name("img"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetText(_:)), name: Notification.Name("text"), object: nil)
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PersonCell", bundle: nil), forCellReuseIdentifier: "TableCell")
    }
    
    @objc func didGetImg(_ notification: Notification) {
        let gotImage = notification.object as! UIImage?
        resultImgView.image = gotImage
        print("Display received image")
    }
    
    @objc func didGetText(_ notification: Notification) {
        let gotText = notification.object as! Data
        people = resultProcessor.getPeople(result: gotText)
        DispatchQueue.main.async {
            self.tableView.reloadData()
            print("Display received text")
        }
    }
    
}

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

// could add a delegate method for cells to be click

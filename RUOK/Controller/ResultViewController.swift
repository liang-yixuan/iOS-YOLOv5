//
//  ResultViewController.swift
//  RUOK
//
//  Created by SHORT on 29/8/21.
//

import UIKit
class ResultViewController: UIViewController {
    @IBOutlet weak var resultImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didGetImg(_:)), name: Notification.Name("img"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetText(_:)), name: Notification.Name("text"), object: nil)
    }
    
    @objc func didGetImg(_ notification: Notification) {
        let gotImage = notification.object as! UIImage?
        resultImgView.image = gotImage
    }
    
    @objc func didGetText(_ notification: Notification) {
        let gotText = notification.object as! String?
        // process text result here
        print(gotText!)
    }
    
}

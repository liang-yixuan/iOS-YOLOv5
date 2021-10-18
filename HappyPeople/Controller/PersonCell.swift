//
//  PersonCell.swift
//  HAPPYPEOPLE
//
//  Created by SHORT on 2/9/21.
//

import UIKit

class PersonCell: UITableViewCell {

    @IBOutlet weak var personCell: UIView!
    @IBOutlet weak var person: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var ethnicity: UILabel!
    @IBOutlet weak var emotion: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        personCell.layer.cornerRadius = 10
        personCell.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

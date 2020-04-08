//
//  EntryTableViewCell.swift
//  tableView
//
//  Created by Smit Patel on 22/09/18.
//  Copyright © 2018 Smit Patel. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var Amount: UILabel!
    @IBOutlet weak var categary: UILabel!
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var Place: UILabel!
    @IBOutlet weak var Tp: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  HistoryCell.swift
//  translator
//
//  Created by TONY on 21/05/2019.
//  Copyright © 2019 TONY. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    @IBOutlet weak var inputedTextLabel: UILabel!
    @IBOutlet weak var langFromLabel: UILabel!
    @IBOutlet weak var langToLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

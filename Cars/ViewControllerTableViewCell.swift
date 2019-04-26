//
//  AppDelegate.swift
//  CattalogoAPPCars
//
//  Created by Mane on 26/04/19.
//  Copyright © 2019 UTNG. All rights reserved.
//

import UIKit

class ViewControllerTableViewCell: UITableViewCell {


    @IBOutlet weak var lblMarca: UILabel!
    @IBOutlet weak var lblModelo: UILabel!
    @IBOutlet weak var lblColor: UILabel!
    @IBOutlet weak var lblTransmision: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

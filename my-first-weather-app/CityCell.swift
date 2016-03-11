//
//  CityCell.swift
//  my-first-weather-app
//
//  Created by Francisco Claret on 10/03/16.
//  Copyright © 2016 Francisco Claret. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

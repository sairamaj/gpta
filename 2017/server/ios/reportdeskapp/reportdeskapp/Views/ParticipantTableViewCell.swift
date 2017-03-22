//
//  ParticipantTableViewCell.swift
//  reportdeskapp
//
//  Created by Sourabh Jamlapuram on 3/22/17.
//  Copyright © 2017 gpta. All rights reserved.
//

import UIKit

class ParticipantTableViewCell: UITableViewCell {

    @IBOutlet weak var arrivedSwitch: UISwitch!
    @IBOutlet weak var nameLabel: UILabel!
    var CurrentParticipant: Participant!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onArrivalChanged(_ sender: Any) {
        CurrentParticipant.arrived = arrivedSwitch.isOn
        Repository.shared.updateParticipantArrivalInf(id: CurrentParticipant.getId(), isArrived: CurrentParticipant.arrived)
    }
}

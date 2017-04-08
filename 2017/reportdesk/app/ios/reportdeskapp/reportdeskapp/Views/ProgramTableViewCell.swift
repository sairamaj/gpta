//
//  ProgramTableViewCell.swift
//  reportdeskapp
//
//  Created by Sourabh Jamlapuram on 3/24/17.
//  Copyright © 2017 gpta. All rights reserved.
//

import UIKit

protocol DetailButtonPressedDelegate{
    func OnClicked(program:Program, currentCell:ProgramTableViewCell,isHide:Bool)
}

class ProgramTableViewCell: UITableViewCell {
    
    @IBOutlet weak var arrivedCountLabel: UILabel!
    @IBOutlet weak var arrivalIndicatorView: UIView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var reportTimeLabel: UILabel!
    @IBOutlet weak var programTimeLabel: UILabel!
    @IBOutlet weak var choreographerLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sequenceLabel: UILabel!
    var CurrentProgram: Program!
    var showDetailDelegate:DetailButtonPressedDelegate!
    var CurrentRow:Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        if self.CurrentProgram == nil{
            return
        }
        
        if( self.CurrentProgram.areAllParticipantsArrived()){
            
            self.arrivalIndicatorView.backgroundColor = UIColor.green
        }else if(self.CurrentProgram.isAtlestOnParticipantArrived()){
            self.arrivalIndicatorView.backgroundColor = UIColor.yellow
        }
        else{
            
            self.arrivalIndicatorView.backgroundColor = UIColor.red
        }
        self.nameLabel.text = self.CurrentProgram!.Name
        self.sequenceLabel.text = String(self.CurrentProgram!.Sequence)
        self.choreographerLabel.text = self.CurrentProgram!.Choreographer
        self.programTimeLabel.text = self.CurrentProgram!.ProgramTime
        self.reportTimeLabel.text = self.CurrentProgram!.ReportTime
        self.durationLabel.text = self.CurrentProgram!.Duration
        self.arrivedCountLabel.text = String(self.CurrentProgram!.getArrivedCount()) + "/" + String(self.CurrentProgram!.getParticipantsCount())
        
    }
    
    
    @IBAction func onShowHideDetails(_ sender: Any) {
        if let delegate = self.showDetailDelegate{
            delegate.OnClicked(program: self.CurrentProgram, currentCell: self, isHide:true)
        }
    }
    
}

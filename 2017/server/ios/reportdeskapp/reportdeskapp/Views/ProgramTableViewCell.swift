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

    @IBOutlet weak var arrivalIndicatorView: UIView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var greenroomTimeLabel: UILabel!
    @IBOutlet weak var reportTimeLabel: UILabel!
    @IBOutlet weak var programTimeLabel: UILabel!
    @IBOutlet weak var choreographerLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
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
        }else{
 
            self.arrivalIndicatorView.backgroundColor = UIColor.red
        }
        self.nameLabel.text = self.CurrentProgram!.Name
        self.choreographerLabel.text = self.CurrentProgram!.Choreographer
        self.programTimeLabel.text = self.CurrentProgram!.ProgramTime
        self.reportTimeLabel.text = self.CurrentProgram!.ReportTime
        self.greenroomTimeLabel.text = self.CurrentProgram!.GreenroomTime
        self.durationLabel.text = self.CurrentProgram!.Duration
     
    }
    
    
    @IBAction func onShowHideDetails(_ sender: Any) {
        if let delegate = self.showDetailDelegate{
            delegate.OnClicked(program: self.CurrentProgram, currentCell: self, isHide:true)
        }
    }

}

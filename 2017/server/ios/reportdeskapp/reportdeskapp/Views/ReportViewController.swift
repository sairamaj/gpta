//
//  ReportViewController.swift
//  reportdeskapp
//
//  Created by Sourabh Jamlapuram on 4/2/17.
//  Copyright © 2017 gpta. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {

  
    @IBOutlet weak var totalProgramLabel: UILabel!
    @IBOutlet weak var readyForEventLabel: UILabel!
    @IBOutlet weak var totalParticipantsLabel: UILabel!
    @IBOutlet weak var totalArrivedParticipantsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     //   refresh()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        refresh()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh() -> Void{
        
        var readyPrograms:Int = 0
        var totalParticipants:Int = 0
        var totalParticipantsArrived = 0
        
        for p in Repository.shared.programs{
            if p.areAllParticipantsArrived(){
                readyPrograms += 1
            }
            totalParticipants += p.Participants.count
            totalParticipantsArrived += p.getArrivedCount()
            
        }
        self.totalProgramLabel.text = String(Repository.shared.programs.count)
        self.readyForEventLabel.text = String(readyPrograms)
        self.totalParticipantsLabel.text = String(totalParticipants)
        self.totalArrivedParticipantsLabel.text = String(totalParticipantsArrived)
    }

    @IBAction func onRefresh(_ sender: Any) {
        refresh()
    }
}

//
//  ParticipantTableViewController.swift
//  reportdeskapp
//
//  Created by Sourabh Jamlapuram on 3/21/17.
//  Copyright © 2017 gpta. All rights reserved.
//

import UIKit

class ParticipantTableViewController: UITableViewController {

    var CurrentProgram:Program!
    var participants:[Participant] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if( CurrentProgram == nil){
            self.participants = Repository.shared.getAllParticipants()
        }else{
            self.participants = CurrentProgram.getParticipants()
        }
        
        self.sortParticipants()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.participants.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "participantcellidentifier", for: indexPath) as! ParticipantTableViewCell

        let participant = self.participants[indexPath.row]
        cell.CurrentParticipant = participant
        cell.nameLabel?.text =  participant.name
        if participant.arrived {
            cell.arrivedSwitch.isOn = true
        }

        return cell
    }
 
    func sortParticipants() -> Void{
        self.participants = self.participants.sorted(by: { (p1, p2) -> Bool in
            p1.name.localizedCompare(p2.name)  == ComparisonResult.orderedAscending      })
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    

}

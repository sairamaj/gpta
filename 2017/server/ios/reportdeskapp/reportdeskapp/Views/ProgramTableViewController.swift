//
//  ProgramTableViewController.swift
//  reportdeskapp
//
//  Created by Sourabh Jamlapuram on 3/19/17.
//  Copyright © 2017 gpta. All rights reserved.
//

import UIKit

class ProgramTableViewController: UITableViewController ,DetailButtonPressedDelegate{

     var programs:[Program] = []
     var selectedRow:Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()


        Repository.shared.getPrograms( callback:    {
            (objects) -> Void in
            
            
            for object in objects{
                self.programs.append(object)
            }
            
            self.sortPrograms()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()    // reload in UI thread.
            }
            
        })
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.separatorStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return programs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "programcellidentifier", for: indexPath) as! ProgramTableViewCell

        cell.CurrentProgram = self.programs[indexPath.row]
        cell.CurrentRow = indexPath.row
        cell.showDetailDelegate = self
        return cell
    }
 
    func sortPrograms() -> Void{
        self.programs = self.programs.sorted(by: { (p1, p2) -> Bool in
            p1.Name.localizedCompare(p2.Name)  == ComparisonResult.orderedAscending      })
        
    }

    /*
     Only one program will be shown with details
 */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if( indexPath.row == self.selectedRow){
            return CGFloat(250)
        }
        
        return CGFloat(40)
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

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let participantController = segue.destination as! ParticipantTableViewController
        
        if let selectedRowPath  = self.tableView.indexPathForSelectedRow{
            let currentProgram = self.programs[selectedRowPath.row]
           // participantController.Participants = self.Programs[selectedRowPath.row].getParticipants()
            participantController.CurrentProgram = currentProgram
            
        }
        
    }
    
    func OnClicked(program:Program, currentCell:ProgramTableViewCell, isHide:Bool){
        if( self.selectedRow == currentCell.CurrentRow){
            // already details shown. hide it.
            self.selectedRow = -1
        }else{
            self.selectedRow = currentCell.CurrentRow
        }
        
        self.tableView.reloadData()
    }

}

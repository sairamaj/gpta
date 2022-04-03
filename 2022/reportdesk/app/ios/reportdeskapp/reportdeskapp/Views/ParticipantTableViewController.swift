//
//  ParticipantTableViewController.swift
//  reportdeskapp
//
//  Created by Sourabh Jamlapuram on 3/21/17.
//  Copyright © 2017 gpta. All rights reserved.
//

import UIKit

extension ParticipantTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
       
        if (searchController.isActive){
             shouldShowSearchResults = true
        }
        if(searchController.isBeingDismissed){
            shouldShowSearchResults = false
        }
    
        filterContentForSearchText(searchText: searchController.searchBar.text!)
        tableView.reloadData()
    }
}
class ParticipantTableViewController: UITableViewController ,UISearchBarDelegate, UISearchDisplayDelegate{

    var CurrentProgram:Program!
    var participants:[Participant] = []
    var filteredParticipants:[Participant] = []    
    var shouldShowSearchResults = false
    let searchController = UISearchController(searchResultsController: nil)
    
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
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchBar.sizeToFit()

        self.sortParticipants()
        tableView.separatorStyle = .none
        
    }

    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
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
        if shouldShowSearchResults {
            return self.filteredParticipants.count
        } else {
            return self.participants.count
        }

    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Note: self.tableView is important rather than just tableView. ( tableView. works good and once searchbar is introduced we get exception )
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "participantcellidentifier", for: indexPath) as! ParticipantTableViewCell

        var participant:Participant
        if shouldShowSearchResults {
            participant = self.filteredParticipants[indexPath.row]
        }else{
            participant = self.participants[indexPath.row]
        }
        
        cell.CurrentParticipant = participant
        cell.nameLabel?.text =  participant.name
        if participant.arrived {
            cell.arrivedSwitch.isOn = true
        }else{
            cell.arrivedSwitch.isOn = false     // Note: even though default is off we need to set explict ,because the cells are shared in UI and if there
            // are more than screen fit and we don't set explict false then it will take from the previously set value ( as the cell UI is shared)
        }
        
        cell.serialNumberLabel.text = String( participant.serialNumber)

        return cell
    }
 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        shouldShowSearchResults = true
        self.filterContentForSearchText(searchText: searchText)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        self.tableView.reloadData()
    }
    
    func sortParticipants() -> Void{
        self.participants = self.participants.sorted(by: { (p1, p2) -> Bool in
            p1.name.localizedCompare(p2.name)  == ComparisonResult.orderedAscending      })
        
        var serialNumber = 1
        // re assign serial numbers
        for p in self.participants{
            p.serialNumber = serialNumber
            serialNumber += 1
        }
    }

    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        self.filteredParticipants = self.participants.filter({( participant: Participant) -> Bool in
            if (participant.name.lowercased().range(of: searchText.lowercased()) != nil){
                return true
            }
            return false
        })
        
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

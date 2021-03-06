//
//  TicketHolderTableViewController.swift
//  ticketapp
//
//  Created by Sourabh Jamlapuram on 4/2/17.
//  Copyright © 2017 gpta. All rights reserved.
//

import UIKit

extension TicketHolderTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
        tableView.reloadData()
    }
}

class TicketHolderTableViewController: UITableViewController ,UISearchBarDelegate, UISearchDisplayDelegate,TaskChangedDelegate{
    var selectedRow:Int = -1
    var ticketHolders:[TicketHolder] = []
    var filteredTicketHolders:[TicketHolder] = []
    let searchController = UISearchController(searchResultsController: nil)
    var timer = Timer()
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        load()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchBar.sizeToFit()
        
        
        refreshTimer()
        NotificationCenter.default.addObserver(self, selector:#selector(TicketHolderTableViewController.defaultsChanged), name: UserDefaults.didChangeNotification, object: nil)
        
        
    }
    
    func refreshTimer(){
        timer.invalidate()
        if Settings.shared.IsAutoRefreshEnabled(){
            // start the timer
            let refreshInterval = Settings.shared.getAutoRefreshIntervalInMinutes()
            Slim.info("enabling the timer with: \(refreshInterval) seconds"  )
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(refreshInterval), target: self, selector: #selector(refreshTimerAction), userInfo: nil, repeats: true)
        }else{
            Slim.info("disabling the timer")
        }
        
    }
    
    func defaultsChanged(){
        Slim.info("settings changed.")
        refreshTimer()
    }
    
    // called every time interval from the timer
    func refreshTimerAction() {
        counter += 1
        Slim.info("autoRefresh: \(counter)")
        self.refreshTicketHolderInfo()
        Slim.info("autoRefresh: triggered")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.searchController.isActive {
            return self.filteredTicketHolders.count
        }
        return self.ticketHolders.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ticketholdercell", for: indexPath) as! TicketHolderCell
        
        
        if self.searchController.isActive {
            cell.CurrentTicketHolder = self.filteredTicketHolders[indexPath.row]
        }else{
            cell.CurrentTicketHolder = self.ticketHolders[indexPath.row]
        }
        
        
        cell.tableView = self.tableView
        cell.CurrentCellRow = indexPath.row
        cell.taskChangeDelegate = self
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if( indexPath.row == self.selectedRow){
            return CGFloat(250)
        }
        
        return CGFloat(50)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        self.filteredTicketHolders   = self.ticketHolders.filter({( ticketHolder: TicketHolder) -> Bool in
            if (ticketHolder.Name.lowercased().range(of: searchText.lowercased()) != nil){
                return true
            }
            if (ticketHolder.ConfirmationNumber.lowercased().range(of: searchText.lowercased()) != nil){
                return true
            }
            return false
        })
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select row\n")
        
        self.selectedRow = indexPath.row
        self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.top)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("de select row\n")
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func load() -> Void{
        Slim.info("load starting.")
        
        Repository.shared.getTicketHolders( callback:    {
            (objects) -> Void in
            
            for object in objects{
                self.ticketHolders.append(object)
            }
            
            self.sortTicketHolders()
            Slim.info("loadPrograms done.")
            DispatchQueue.main.async {
                self.tableView.reloadData()    // reload in UI thread.
            }
            
            self.refreshTicketHolderInfo()
        })
    }
    
    
    @IBAction func onRefresh(_ sender: Any) {
        self.refreshTicketHolderInfo()
    }
    
    func TaskChanged(_ ticketHolder:TicketHolder, currentCell:TicketHolderCell,isDone:Bool){
        
        if( isDone )
        {
            self.selectedRow = -1
            let indexPath = IndexPath(row: currentCell.CurrentCellRow, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.top)
            Repository.shared.updateTicketHolder( ticketHolder ,callback: {
                (ticket) -> Void in
            
                    Slim.info("UpdateTicketolder ")
                DispatchQueue.main.async {
                    self.tableView.reloadData()    // reload in UI thread.
                }
            })
        }
        
        self.updateTitle()
    }
    
    func updateTitle() {
        var totalTickets:Int = 0
        var totalArrived:Int = 0
        
        for ticketHolder in self.ticketHolders{
            totalTickets += ticketHolder.AdultCount + ticketHolder.KidCount
            totalArrived += ticketHolder.AdultsArrived + ticketHolder.KidsArrived
        }
        
        self.title = String(totalArrived) + "/" + String(totalTickets)
    }
    
    func refreshTicketHolderInfo(){
        Slim.info("refreshing ticket holders arrivals")
        
        Repository.shared.refreshTicketHolderInfo( ticketHolders: self.ticketHolders, callback:    {
            (objects) -> Void in
            Slim.info("refreshing ticket holders arrivals done.")
            
            DispatchQueue.main.async {
                self.tableView.reloadData()    // reload in UI thread.
            }
        })
        
    }
    
    func sortTicketHolders() -> Void{
        self.ticketHolders = self.ticketHolders.sorted(by: { (p1, p2) -> Bool in
            p1.Name.localizedCompare(p2.Name)  == ComparisonResult.orderedAscending      })
        
        // reset serlial numbers
        var serialNumber = 1
        for ticketHolder in self.ticketHolders{
            ticketHolder.SerialNumber = serialNumber
            serialNumber += 1
        }
        
    }
}

//
//  ProgramTableViewController.swift
//  reportdeskapp
//
//  Created by Sourabh Jamlapuram on 3/19/17.
//  Copyright © 2017 gpta. All rights reserved.
//

import UIKit

extension ProgramTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
        tableView.reloadData()
    }
}

class ProgramTableViewController: UITableViewController ,UISearchBarDelegate, UISearchDisplayDelegate, DetailButtonPressedDelegate{
    
    var programs:[Program] = []
    var filteredPrograms:[Program] = []
    var selectedRow:Int = -1
    var timer = Timer()
    var counter = 0
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.loadPrograms()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchBar.sizeToFit()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.separatorStyle = .none
        
        refreshTimer()
        NotificationCenter.default.addObserver(self, selector:#selector(ProgramTableViewController.defaultsChanged), name: UserDefaults.didChangeNotification, object: nil)
       
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
        self.refreshParticipantArrivalInfo()
        Slim.info("autoRefresh: triggered")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.tableView.reloadData()    // reload in UI thread.
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return getDataSource().count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Note: self.tableView is important rather than just tableView. ( tableView. works good and once searchbar is introduced we get exception )
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "programcellidentifier", for: indexPath) as! ProgramTableViewCell
        
        cell.CurrentProgram = getDataSource()[indexPath.row]
        cell.CurrentRow = indexPath.row
        cell.showDetailDelegate = self
        
        return cell
    }
    
    func sortPrograms() -> Void{
        self.programs = self.programs.sorted(by: { (p1, p2) -> Bool in
            p1.Sequence < p2.Sequence      })
        
    }
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        self.filteredPrograms = self.programs.filter({( program: Program) -> Bool in
            if (program.Name.lowercased().range(of: searchText.lowercased()) != nil){
                return true
            }
            return false
        })
        
    }
    
    /*
     Only one program will be shown with details
     */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if( indexPath.row == self.selectedRow){
            return CGFloat(180)
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
        
        var currentProgram:Program!
        
        if let selectedRowPath  = self.tableView.indexPathForSelectedRow{
            currentProgram = self.getDataSource()[selectedRowPath.row]
        }
        participantController.CurrentProgram = currentProgram
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
    
    @IBAction func onRefresh(_ sender: Any) {
        
        self.refreshParticipantArrivalInfo()
    }
    
    func refreshParticipantArrivalInfo(){
        Slim.info("refreshing participant arrivals")
        
        Repository.shared.refreshParticipantArrivalInfo( programs: self.programs, callback:    {
            (objects) -> Void in
            Slim.info("refreshing participant arrivals done.")
            
            DispatchQueue.main.async {
                self.tableView.reloadData()    // reload in UI thread.
            }
        })
        
    }
    
    func loadPrograms() -> Void{
        Slim.info("loadPrograms starting.")
        
        Repository.shared.getPrograms( callback:    {
            (objects) -> Void in
            
            Slim.info("loadPrograms done.")
            for object in objects{
                self.programs.append(object)
            }
            
            self.sortPrograms()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()    // reload in UI thread.
            }
            
            self.refreshParticipantArrivalInfo()
        })
    }
    
    func getDataSource() ->[Program]{
        if self.searchController.isActive{
            return self.filteredPrograms
        }else{
            return self.programs
        }
    }
}

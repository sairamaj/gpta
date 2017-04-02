//
//  LogViewTableViewController.swift
//  reportdeskapp
//
//  Created by Sourabh Jamlapuram on 4/1/17.
//  Copyright © 2017 gpta. All rights reserved.
//

import UIKit

class LogViewTableViewController: UITableViewController ,LogDetailButtonPressedDelegate, LogDestination{

    var messages : Array<LogMessage> = Array()
    var selectedRow:Int = -1
    
    override func viewDidLoad() {
        
        Slim.addLogDestination(self as! LogDestination)
        
        super.viewDidLoad()

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
        return messages.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "logcellidentifier", for: indexPath) as! LogTableViewCell

        cell.Log = self.messages[indexPath.row]
        cell.CurrentRow = indexPath.row
        cell.showDetailDelegate = self
        return cell
    }
    
    /*
     Only one program will be shown with details
     */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if( indexPath.row == self.selectedRow){
            return CGFloat(140)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    let dateFormatter = DateFormatter()
    let serialLogQueue: DispatchQueue = DispatchQueue(label: "ConsoleDestinationQueue")

    func log<T>( _ message: @autoclosure () -> T, level:LogLevel,
             filename: String, line: Int) {
        if level.rawValue >= SlimConfig.consoleLogLevel.rawValue {
            let msg = message()
            self.serialLogQueue.async {
                //  self.messages.append(String(format:"\(self.dateFormatter.string(from: Date() as Date)):\(level.string):\(filename):\(line) - \(msg)"))
                let logMessage = LogMessage( dateTime: Date() , fileName: filename, line: line,  logType: level.string, message: msg as! String)
                self.messages.append(logMessage)
                DispatchQueue.main.async {
                    self.tableView.reloadData()    // reload in UI thread.
                }
            }
        }
    }
    
    func OnClicked( currentCell:LogTableViewCell){
        if( self.selectedRow == currentCell.CurrentRow){
            // already details shown. hide it.
            self.selectedRow = -1
        }else{
            self.selectedRow = currentCell.CurrentRow
        }
        
        self.tableView.reloadData()
    }

}

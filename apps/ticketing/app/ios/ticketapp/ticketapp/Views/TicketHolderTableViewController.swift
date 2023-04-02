//
//  TicketHolderTableViewController.swift
//  ticketapp
//
//  Created by Sourabh Jamlapuram on 4/2/17.
//  Copyright © 2017 gpta. All rights reserved.
//

import UIKit
import AVFoundation

@available(iOS 10.0, *)
extension TicketHolderTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
        tableView.reloadData()
    }
}

@available(iOS 10.0, *)
class TicketHolderTableViewController:
    UITableViewController ,UISearchBarDelegate,UpdatedOnScanDelegate, UISearchDisplayDelegate,AVCaptureMetadataOutputObjectsDelegate,TaskChangedDelegate{
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
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
    
    @objc func defaultsChanged(){
        Slim.info("settings changed.")
        refreshTimer()
    }
    
    // called every time interval from the timer
    @objc func refreshTimerAction() {
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
    
    @IBAction func onScan(_ sender: Any) {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            if captureSession.isRunning {
                self.captureSession.stopRunning()
                qrCodeFrameView?.removeFromSuperview()
                self.videoPreviewLayer?.removeFromSuperlayer()
                return
            }
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)

            if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
                for input in inputs {
                    captureSession.removeInput(input)
                }
            }
            
            if let outputs = captureSession.outputs as? [AVCaptureMetadataOutput] {
                for output in outputs {
                    captureSession.removeOutput(output)
                }
            }
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]

            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
     
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture.
            captureSession.startRunning()
            

            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()

            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
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
                self.updateTitle()
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
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
         // Check if the metadataObjects array is not nil and it contains at least one object.
         if metadataObjects.count == 0 {
             qrCodeFrameView?.frame = CGRect.zero
             //qrCodeInfo.text = "No QR code is detected"
             return
         }

         // Get the metadata object.
         let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject

         if metadataObj.type == AVMetadataObject.ObjectType.qr {
             // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
             let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
             qrCodeFrameView?.frame = barCodeObject!.bounds

             if metadataObj.stringValue != nil {
                //qrCodeInfo.text = metadataObj.stringValue
                let text = metadataObj.stringValue!
                 do{
                     
                     
                     let ticketHolder = try QRCodeParser.parse(val: text)
                     
                     ticketHolder.AdultsArrived = ticketHolder.AdultCount
                     ticketHolder.KidsArrived = ticketHolder.KidCount
                     let updatePopUpWindow = UpdateTicketPopUpWindow(title: "GPTA Ticket",
                                               text: text,
                                               ticketHolder : ticketHolder,
                                               buttontext: "Check In")
                     updatePopUpWindow.updatedOnScanDelegate = self
                     self.present(updatePopUpWindow, animated: true, completion: {
                                () in print("Done🔨")
                         
                     })
                 }
                 catch QRCodeParseError.notAValidTicket
                {
                    let popUpWindow = PopUpWindow(title: "Error Not a valid ticket", text:text, buttontext: "OK")
                    self.present(popUpWindow, animated: true, completion: nil)
                }
                catch
                {
                     let popUpWindow = PopUpWindow(title: "Error Not a valid ticket", text:text, buttontext: "OK")
                     self.present(popUpWindow, animated: true, completion: nil)
                 }
                 
                 self.captureSession.stopRunning()
                 qrCodeFrameView?.removeFromSuperview()
                 self.videoPreviewLayer?.removeFromSuperlayer()
                
                 // Move the message label and top bar to the front
                 //view.bringSubview(toFront: qrCodeInfo)
                 //view.bringSubview(toFront: topbar)
             }
         }
     }
    
    func TaskChanged(_ ticketHolder:TicketHolder) -> QRScanUpdateStatus{

        Slim.info("checkin: \(ticketHolder.Name)")
        
        var found = false;
        var alreadyCheckedInCount = false
        // move this to repository (updating this memory)
        for t in self.ticketHolders{
            if t.ConfirmationNumber == ticketHolder.ConfirmationNumber{
                if( t.AdultsArrived > 0 || t.KidsArrived > 0){
                    alreadyCheckedInCount = true
                }else{
                    t.AdultsArrived = ticketHolder.AdultsArrived
                    t.KidsArrived = ticketHolder.KidsArrived
                }
                found = true
                break
            }
        }
        
        if(!found){
            return QRScanUpdateStatus.ticketNotFound  // did not find the scanned ticket
        }
        
        if(alreadyCheckedInCount){
            return QRScanUpdateStatus.alreadyArrived
        }
        
        Repository.shared.updateTicketHolder( ticketHolder ,callback: {
            (ticket) -> Void in
         
            DispatchQueue.main.async {
                print("done updating: \(ticketHolder.Name)")
                self.tableView.reloadData()
                self.updateTitle()
            }
        })
        
        return QRScanUpdateStatus.success
    }

}

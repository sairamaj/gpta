//
//  ReportViewController.swift
//  ticketapp
//
//  Created by Sourabh Jamlapuram on 3/26/19.
//  Copyright © 2019 gpta. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {

    @IBOutlet weak var totalCheckedInKids: UILabel!
    @IBOutlet weak var totalKids: UILabel!
    @IBOutlet weak var totalCheckedInAdults: UILabel!
    @IBOutlet weak var totalAdults: UILabel!
    @IBOutlet weak var totalTickets: UILabel!
    @IBOutlet weak var notSyncedLabel: UILabel!
    @IBAction func onRetryFailedTickets(_ sender: Any) {
        print("retrying failed ones")
        for ticket in Repository.shared.ticketHolders{
            if ticket.isSynced > 0 {
                print("\(ticket.Name)")
                Repository.shared.updateTicketHolder( ticket ,callback: {
                    (ticket) -> Void in
                    DispatchQueue.main.async {
                        self.refresh()   // reload in UI thread.
                    }
                    
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        refresh()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func refresh() -> Void{
        var count = 0
        var totalAdults = 0
        var totalKids = 0
        var totalCheckedInAdults = 0
        var totalCheckedInKids = 0
        for ticket in Repository.shared.ticketHolders{
            if ticket.isSynced > 0 {
                count = count+1
            }
            totalAdults += ticket.AdultCount
            totalKids += ticket.KidCount
            totalCheckedInAdults += ticket.AdultsArrived
            totalCheckedInKids += ticket.KidsArrived
        }
        
        self.notSyncedLabel.text = String(count)
        self.totalTickets.text = String(Repository.shared.ticketHolders.count)
        self.totalAdults.text = String(totalAdults)
        self.totalKids.text = String(totalKids)
        self.totalCheckedInAdults.text = String(totalCheckedInAdults)
        self.totalCheckedInKids.text = String(totalCheckedInKids)
    }
}

//
//  ReportViewController.swift
//  ticketapp
//
//  Created by Sourabh Jamlapuram on 3/26/19.
//  Copyright © 2019 gpta. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {

    @IBAction func onRetryFailedTickets(_ sender: Any) {
        print("retrying failed ones")
        for ticket in Repository.shared.ticketHolders{
            if ticket.isSynced > 0 {
                print("\(ticket.Name)")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

}

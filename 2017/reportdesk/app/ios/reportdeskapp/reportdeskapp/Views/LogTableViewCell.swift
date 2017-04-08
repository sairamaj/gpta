//
//  LogTableViewCell.swift
//  reportdeskapp
//
//  Created by Sourabh Jamlapuram on 4/1/17.
//  Copyright © 2017 gpta. All rights reserved.
//

import UIKit

protocol LogDetailButtonPressedDelegate{
    func OnClicked(currentCell:LogTableViewCell)
}

class LogTableViewCell: UITableViewCell {


    var Log : LogMessage!
    var CurrentRow:Int = 0
    var showDetailDelegate:LogDetailButtonPressedDelegate!
    
    let dateFormatter = DateFormatter()
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var fileLabel: UILabel!
    @IBOutlet weak var lineLabel: UILabel!
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var logTypeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        dateFormatter.dateFormat = "HH:mm:ss:SSS"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        if Log == nil{
            return
        }
        
        self.timeLabel.text = self.dateFormatter.string(from: Date() as Date)
        self.fileLabel.text = self.Log.FileName
        self.lineLabel.text = String(self.Log.Line)
        self.messageLabel.text = self.Log.Message
        self.logTypeLabel.text = self.Log.LogType
        self.idLabel.text = String(self.Log.Id)
        
        if self.Log.LogType.localizedCompare("ERROR") == ComparisonResult.orderedSame{
            self.messageLabel.textColor = UIColor.red
        }else{
            self.messageLabel.textColor = UIColor.black
        }
       
    }

    @IBAction func onDetail(_ sender: Any) {
        if let delegate = self.showDetailDelegate{
            delegate.OnClicked(currentCell: self)
        }
    }
}

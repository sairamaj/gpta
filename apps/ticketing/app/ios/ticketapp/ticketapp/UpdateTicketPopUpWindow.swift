//
//  PopUpWindow.swift
//  PopUpWindowExample
//
//  Created by John Codeos on 1/18/20.
//  Copyright © 2020 John Codeos. All rights reserved.
//

import Foundation
import UIKit

protocol UpdatedOnScanDelegate{
    func TaskChanged(_ ticketHolder:TicketHolder) -> QRScanUpdateStatus
}

class UpdateTicketPopUpWindow: UIViewController {

    private let popUpWindowView = UpdateTicketPopUpWindowView()
    private var ticketHolder:TicketHolder!
    var updatedOnScanDelegate:UpdatedOnScanDelegate? = nil
    var updateStatus = QRScanUpdateStatus.unknown
    var isFirstTime = true
    let BorderWidth: CGFloat = 2.0
    
    init(title: String, text: String, ticketHolder: TicketHolder!, buttontext: String) {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        
        self.ticketHolder = ticketHolder
        popUpWindowView.popupTitle.text = title
        popUpWindowView.popupText.text = text
        popUpWindowView.popupButton.setTitle(buttontext, for: .normal)
        popUpWindowView.popupButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        popUpWindowView.popupCancelButton.addTarget(self, action: #selector(dismissViewWithCancel), for: .touchUpInside)
        view = popUpWindowView
        
        self.changeToInfoMode(text: text)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func dismissView(){
        if isFirstTime == false {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        if self.ticketHolder != nil {
            updateStatus = (self.updatedOnScanDelegate?.TaskChanged(self.ticketHolder))!
        }else{
            updateStatus = QRScanUpdateStatus.success
        }

        let name = self.ticketHolder.Name ?? "unknown"
        if updateStatus == QRScanUpdateStatus.success {
            self.changeToSuccessMode(text : "\(name) checked-in.")
        }else if updateStatus == QRScanUpdateStatus.alreadyArrived {
            self.changeToErrorMode(text :" \(name) already checked-in.")
        }
        else if updateStatus == QRScanUpdateStatus.ticketNotFound {
            self.changeToErrorMode(text :"\(name) not found in current tickets.")
        }else{
            self.changeToErrorMode(text :"\(name) unknown error.")
        }
        
        isFirstTime = false
        
    }
    
    @objc func dismissViewWithCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func changeToErrorMode(text : String) {
        
        // entire back groun.
        popUpWindowView.popupView.backgroundColor = UIColor.systemRed
        
        // title
        popUpWindowView.popupTitle.backgroundColor = UIColor.colorFromHex("#BC214B")
        popUpWindowView.popupTitle.textColor = UIColor.white
        popUpWindowView.popupTitle.text = "Error"
        
        // text
        popUpWindowView.popupText.backgroundColor = UIColor.systemRed
        popUpWindowView.popupText.textColor = UIColor.black
        popUpWindowView.popupText.text = text
        
        if self.ticketHolder == nil{
            popUpWindowView.popupText2.isHidden = true
        }else{
            popUpWindowView.popupText2.backgroundColor = UIColor.systemRed
            popUpWindowView.popupText2.textColor = UIColor.black
            popUpWindowView.popupText2.text = "Adult:\(self.ticketHolder.AdultCount) Kids:\(self.ticketHolder.KidCount)"
        }
        
        // button
        popUpWindowView.popupButton.backgroundColor = UIColor.colorFromHex("#BC214B")
        popUpWindowView.popupButton.setTitleColor(UIColor.white, for: .normal)
        popUpWindowView.popupButton.setTitle("OK", for: .normal)

        popUpWindowView.popupCancelButton.isHidden = true
        popUpWindowView.popupCancelButton.translatesAutoresizingMaskIntoConstraints = true
        popUpWindowView.popupButton.translatesAutoresizingMaskIntoConstraints = true
    }

    func changeToSuccessMode(text : String) {
    
        // entire back groun.
        popUpWindowView.popupView.backgroundColor = UIColor.green
        
        // title
        popUpWindowView.popupTitle.backgroundColor = UIColor.systemGreen
        popUpWindowView.popupTitle.textColor = UIColor.white
        popUpWindowView.popupTitle.text = "Success"
        
        // text
        popUpWindowView.popupText.backgroundColor = UIColor.green
        popUpWindowView.popupText.textColor = UIColor.black
        popUpWindowView.popupText.text = text
        
        if self.ticketHolder == nil{
            popUpWindowView.popupText2.isHidden = true
        }else{
            popUpWindowView.popupText2.backgroundColor = UIColor.green
            popUpWindowView.popupText2.textColor = UIColor.black
            
            popUpWindowView.popupText2.text = "Adult:\(self.ticketHolder.AdultCount) Kids:\(self.ticketHolder.KidCount)"
        }
        
        // button
        popUpWindowView.popupButton.backgroundColor = UIColor.systemGreen
        popUpWindowView.popupButton.setTitleColor(UIColor.white, for: .normal)
        popUpWindowView.popupButton.setTitle("OK", for: .normal)
        popUpWindowView.popupCancelButton.isHidden = true
    }
    
    func changeToInfoMode(text : String){
        
        // entire back groun.
        popUpWindowView.popupView.backgroundColor = UIColor.gray
        
        // title
        popUpWindowView.popupTitle.backgroundColor = UIColor.black
        popUpWindowView.popupTitle.textColor = UIColor.white
        popUpWindowView.popupTitle.text = "Ticket"
        
        // text
        popUpWindowView.popupText.backgroundColor = UIColor.gray
        popUpWindowView.popupText.textColor = UIColor.black
        popUpWindowView.popupText.text = text
   
        if self.ticketHolder == nil{
            popUpWindowView.popupText2.isHidden = true
        }else{
            popUpWindowView.popupText2.backgroundColor = UIColor.gray
            popUpWindowView.popupText2.textColor = UIColor.green
            popUpWindowView.popupText2.text = "Adult:\(self.ticketHolder.AdultCount) Kids:\(self.ticketHolder.KidCount)"
        }
        
        // button
        popUpWindowView.popupButton.backgroundColor = UIColor.black
        popUpWindowView.popupButton.setTitleColor(UIColor.white, for: .normal)
        popUpWindowView.popupButton.setTitle("Check In", for: .normal)
        
        popUpWindowView.popupCancelButton.backgroundColor = UIColor.black
        popUpWindowView.popupCancelButton.setTitleColor(UIColor.white, for: .normal)
        popUpWindowView.popupCancelButton.setTitle("Cancel", for: .normal)
    }
}

private class UpdateTicketPopUpWindowView: UIView {
    
    let popupView = UIView(frame: CGRect.zero)
    let popupTitle = UILabel(frame: CGRect.zero)
    let popupText = UILabel(frame: CGRect.zero)
    let popupText2 = UILabel(frame: CGRect.zero)
    let popupButton = UIButton(frame: CGRect.zero)
    let popupCancelButton = UIButton(frame: CGRect.zero)
    
    let BorderWidth: CGFloat = 2.0
    
    init() {
        super.init(frame: CGRect.zero)
        // Semi-transparent background
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        // UIColor.colorFromHex("#BC214B")
        // Popup Background
        popupView.backgroundColor = UIColor.colorFromHex("#00FF00")
        popupView.layer.borderWidth = BorderWidth
        popupView.layer.masksToBounds = true
        popupView.layer.borderColor = UIColor.white.cgColor
        
        //
        // Popup Title
        popupTitle.textColor = UIColor.white
        popupTitle.backgroundColor = UIColor.colorFromHex("#000000")
        popupTitle.layer.masksToBounds = true
        popupTitle.adjustsFontSizeToFitWidth = true
        popupTitle.clipsToBounds = true
        popupTitle.font = UIFont.systemFont(ofSize: 23.0, weight: .bold)
        popupTitle.numberOfLines = 1
        popupTitle.textAlignment = .center
        
        // Popup Text
        popupText.textColor = UIColor.black
        popupText.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        popupText.numberOfLines = 0
        popupText.textAlignment = .center
        
        popupText2.textColor = UIColor.black
        popupText2.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        popupText2.numberOfLines = 0
        popupText2.textAlignment = .center
        
        // Popup Button
        popupButton.setTitleColor(UIColor.white, for: .normal)
        popupButton.titleLabel?.font = UIFont.systemFont(ofSize: 23.0, weight: .bold)
        popupButton.backgroundColor = UIColor.colorFromHex("#9E1C40")
    
        popupCancelButton.setTitleColor(UIColor.white, for: .normal)
        popupCancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 23.0, weight: .bold)
        popupCancelButton.backgroundColor = UIColor.colorFromHex("#9E1C40")
        
        popupView.addSubview(popupTitle)
        popupView.addSubview(popupText)
        popupView.addSubview(popupText2)
        popupView.addSubview(popupButton)
        popupView.addSubview(popupCancelButton)
        
        //popupText.isHidden = true
        
        // Add the popupView(box) in the PopUpWindowView (semi-transparent background)
        addSubview(popupView)
        
        
        // PopupView constraints
        popupView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupView.widthAnchor.constraint(equalToConstant: 293),
            popupView.heightAnchor.constraint(equalToConstant: 250),
            popupView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            popupView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
        
        // PopupTitle constraints
        popupTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupTitle.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: BorderWidth),
            popupTitle.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -BorderWidth),
            popupTitle.topAnchor.constraint(equalTo: popupView.topAnchor, constant: BorderWidth),
            popupTitle.heightAnchor.constraint(equalToConstant: 55)
            ])
        
        
        // PopupText constraints
        popupText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupText.heightAnchor.constraint(greaterThanOrEqualToConstant: 67),
            popupText.topAnchor.constraint(equalTo: popupTitle.bottomAnchor, constant: 8),
            popupText.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 15),
            popupText.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -15),
            popupText.bottomAnchor.constraint(equalTo: popupButton.topAnchor, constant: -8)
            ])

        popupText2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupText2.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            popupText2.topAnchor.constraint(equalTo: popupText.bottomAnchor, constant: 58),
            popupText2.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 15),
            popupText2.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -15),
            popupText2.bottomAnchor.constraint(equalTo: popupButton.topAnchor, constant: -8)
            ])
        
        // PopupButton constraints
        popupButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupButton.heightAnchor.constraint(equalToConstant: 44),
            popupButton.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: -100.0),
            popupButton.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -BorderWidth),
            popupButton.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -BorderWidth)
            ])
        
        popupCancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        popupCancelButton.centerXAnchor.constraint(equalTo: popupView.centerXAnchor, constant: 50),
        popupCancelButton.centerYAnchor.constraint(equalTo: popupButton.centerYAnchor),
        popupCancelButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

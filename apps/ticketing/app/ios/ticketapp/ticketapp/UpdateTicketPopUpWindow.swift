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
    
    init(title: String, text: String, ticketHolder: TicketHolder!, buttontext: String) {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        
        self.ticketHolder = ticketHolder
        popUpWindowView.popupTitle.text = title
        popUpWindowView.popupText.text = text
        popUpWindowView.popupButton.setTitle(buttontext, for: .normal)
        popUpWindowView.popupButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        view = popUpWindowView
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
    
    func changeToErrorMode(text : String) {
        popUpWindowView.popupText.text = text
        popUpWindowView.popupView.backgroundColor = UIColor.colorFromHex("#BC214B")
        popUpWindowView.popupTitle.backgroundColor = UIColor.colorFromHex("#9E1C40")
        popUpWindowView.popupTitle.text = "Error"
        popUpWindowView.popupText.textColor = UIColor.white
        popUpWindowView.popupButton.setTitleColor(UIColor.white, for: .normal)
        popUpWindowView.popupButton.setTitle("OK", for: .normal)
    }

    func changeToSuccessMode(text : String) {
        popUpWindowView.popupText.text = text
        popUpWindowView.popupView.backgroundColor = UIColor.colorFromHex("#00FF00")
        popUpWindowView.popupTitle.backgroundColor = UIColor.colorFromHex("#00FF00")
        popUpWindowView.popupTitle.text = "Success"
        popUpWindowView.popupTitle.textColor = UIColor.black
        popUpWindowView.popupText.textColor = UIColor.black
        popUpWindowView.popupButton.setTitleColor(UIColor.black, for: .normal)
        popUpWindowView.popupButton.setTitle("OK", for: .normal)
    }
}

private class UpdateTicketPopUpWindowView: UIView {
    
    let popupView = UIView(frame: CGRect.zero)
    let popupTitle = UILabel(frame: CGRect.zero)
    let popupText = UILabel(frame: CGRect.zero)
    let popupButton = UIButton(frame: CGRect.zero)
    
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
        
        // Popup Button
        popupButton.setTitleColor(UIColor.white, for: .normal)
        popupButton.titleLabel?.font = UIFont.systemFont(ofSize: 23.0, weight: .bold)
        popupButton.backgroundColor = UIColor.colorFromHex("#9E1C40")
        
        popupView.addSubview(popupTitle)
        popupView.addSubview(popupText)
        popupView.addSubview(popupButton)
        
        // Add the popupView(box) in the PopUpWindowView (semi-transparent background)
        addSubview(popupView)
        
        
        // PopupView constraints
        popupView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupView.widthAnchor.constraint(equalToConstant: 293),
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

        
        // PopupButton constraints
        popupButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupButton.heightAnchor.constraint(equalToConstant: 44),
            popupButton.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: BorderWidth),
            popupButton.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -BorderWidth),
            popupButton.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -BorderWidth)
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
}

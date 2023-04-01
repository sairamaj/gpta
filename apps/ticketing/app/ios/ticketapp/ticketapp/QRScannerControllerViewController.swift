//
//  QRScannerControllerViewController.swift
//  ticketapp
//
//  Created by Dad on 4/1/23.
//  Copyright © 2023 gpta. All rights reserved.
//

import UIKit
import AVFoundation

@available(iOS 10.0, *)
class QRScannerControllerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    @IBOutlet weak var qrCodeInfo: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Get the back-facing camera for capturing videos
        //let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: //[.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
    
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
      
        //
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        // Move the message label and top bar to the front
        //view.bringSubview(toFront: messageLabel)
        //view.bringSubview(toFront: topbar)
        
      
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)

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
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
         // Check if the metadataObjects array is not nil and it contains at least one object.
         if metadataObjects.count == 0 {
             qrCodeFrameView?.frame = CGRect.zero
             qrCodeInfo.text = "No QR code is detected"
             return
         }

         // Get the metadata object.
         let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject

         if metadataObj.type == AVMetadataObject.ObjectType.qr {
             // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
             let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
             qrCodeFrameView?.frame = barCodeObject!.bounds

             if metadataObj.stringValue != nil {
                qrCodeInfo.text = metadataObj.stringValue
                let text = metadataObj.stringValue
                var popUpWindow: PopUpWindow!
                popUpWindow = PopUpWindow(title: "Error", text: text!, buttontext: "OK")
                self.present(popUpWindow, animated: true, completion: nil)
                 
                 // Move the message label and top bar to the front
                 view.bringSubview(toFront: qrCodeInfo)
                 //view.bringSubview(toFront: topbar)
             }
         }
     }
     
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

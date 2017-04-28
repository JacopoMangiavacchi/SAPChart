//
//  MessageDetailViewController.swift
//  SAPChart
//
//  Created by Jacopo Mangiavacchi on 27/04/2017.
//  Copyright © 2017 Jacopo. All rights reserved.
//

import UIKit
import MessageUI

class MessageDetailViewController: UIViewController, UserViewProtocol, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var userView1: UserView!
    @IBOutlet weak var userView2: UserView!
    
    var plantName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        plantNameLabel.text = plantName
        _setPlantUsers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func _setPlantUsers() {
        userView1.delegate = self
        userView1.idLabel.textColor = Constants.darkColor
        
        userView1.imageView.image = UIImage(named: "User3.png")
        userView1.nameLabel.text = "Gina Cardosi"
        userView1.idLabel.text = "ID XCA749"

        userView2.delegate = self
        userView2.idLabel.textColor = Constants.darkColor

        userView2.imageView.image = UIImage(named: "User4.png")
         userView2.nameLabel.text = "Maxwell Brown"
        userView2.idLabel.text = "ID XCA312"
    }

    func call() {
        UIApplication.shared.open(URL(string: "facetime:\(Constants.facetimeID)")!, options: [:], completionHandler: nil)
    }
    
    func message() {
        if !UIDevice.isSimulator {
            let messageVC = MFMessageComposeViewController()
            
            messageVC.body = "";
            messageVC.recipients = [Constants.facetimeID]
            messageVC.messageComposeDelegate = self;
            
            self.present(messageVC, animated: false, completion: nil)
        }
        else {
            print("No iMessage on Simulator")
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case .cancelled:
            print("Message was cancelled")
            self.dismiss(animated: true, completion: nil)
        case .failed:
            print("Message failed")
            self.dismiss(animated: true, completion: nil)
        case .sent:
            print("Message was sent")
            self.dismiss(animated: true, completion: nil)
        }
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

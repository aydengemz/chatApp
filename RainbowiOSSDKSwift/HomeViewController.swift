//
//  HomeViewController.swift
//  RainbowiOSSDKSwift
//
//  Created by Ayden Xu on 12/25/18.
//  Copyright © 2018 ALE. All rights reserved.
//

import UIKit
import Rainbow

class HomeViewController: UIViewController {

    @IBOutlet weak var unreadMessagesCountLabel: UILabel!
    @IBOutlet weak var numberOfContactsLabel: UILabel!
    @IBOutlet weak var numberOfNetworksLabel: UILabel!
    @IBOutlet weak var NameLabel: UILabel!
    
    var totalNbOfUnreadMessagesInAllConversations = 0
    var conversationsLoaded = false
    var contactsLoaded = false
    var contact: Contact?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        unreadMessagesCountLabel.text = "\(totalNbOfUnreadMessagesInAllConversations)"
        
        // notification related to the ContactManagerService
        NotificationCenter.default.addObserver(self, selector: #selector(didEndPopulatingMyNetwork(notification:)), name: NSNotification.Name(kContactsManagerServiceDidEndPopulatingMyNetwork), object: nil)
        
        // notifications related to unread conversation count
        NotificationCenter.default.addObserver(self, selector: #selector(didEndLoadingConversations(notification:)), name:NSNotification.Name(kConversationsManagerDidEndLoadingConversations), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateMessagesUnreadCount(notification:)), name:NSNotification.Name(kConversationsManagerDidUpdateMessagesUnreadCount), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // ServicesManager.sharedInstance().loginManager.
        
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // notification related to the ContactManagerService
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(kContactsManagerServiceDidEndPopulatingMyNetwork), object: nil)
        
        // notifications related to unread conversation count
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(kConversationsManagerDidEndLoadingConversations), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(kConversationsManagerDidUpdateMessagesUnreadCount), object: nil)
    }
    // MARK: - ContactManagerService notifications
    
    @objc func didEndPopulatingMyNetwork(notification : Notification) {
        // Enforce that this method is called on the main thread
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                self.didEndPopulatingMyNetwork(notification: notification)
            }
            return
        }
        NSLog("Did end populating my network");
        contactsLoaded = true
        if isViewLoaded {
            //contactsButton.isEnabled = true
            print("d")
        }
    }
    // MARK: - Notifications related to unread conversation count
    
    @objc func didEndLoadingConversations(notification : Notification) {
        conversationsLoaded = true
        // Read the unread message count in a asynchronous block as it is a synchronous method protected by a lock
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                if self.isViewLoaded {
                    //self.conversationsButton.isEnabled = true
                    self.conversationsLoaded = true
                }
            }
            self.totalNbOfUnreadMessagesInAllConversations = ServicesManager.sharedInstance().conversationsManagerService.totalNbOfUnreadMessagesInAllConversations
            NSLog("totalNbOfUnreadMessagesInAllConversations=%ld", self.totalNbOfUnreadMessagesInAllConversations)
        }
    }
    @objc func didUpdateMessagesUnreadCount(notification : Notification) {
        // Read the unread message count in a asynchronous block as it is a synchronous method protected by a lock
        DispatchQueue.global().async {
            self.totalNbOfUnreadMessagesInAllConversations = ServicesManager.sharedInstance().conversationsManagerService.totalNbOfUnreadMessagesInAllConversations
            NSLog("totalNbOfUnreadMessagesInAllConversations=%ld", self.totalNbOfUnreadMessagesInAllConversations)
        }
    }
}

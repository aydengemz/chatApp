/*
 * Rainbow SDK sample
 *
 * Copyright (c) 2018, ALE International
 * All rights reserved.
 *
 * ALE International Proprietary Information
 *
 * Contains proprietary/trade secret information which is the property of
 * ALE International and must not be made available to, or copied or used by
 * anyone outside ALE International without its written authorization
 *
 * Not to be disclosed or used except in accordance with applicable agreements.
 */

import UIKit
import Rainbow

class ContactsTableViewController: UITableViewController {
    let serviceManager : ServicesManager
    let contactsManager : ContactsManagerService
    var populated = false
    var selectedIndex : IndexPath? = nil
    var selectedIndex2 : IndexPath? = nil
    var allObjects : [Contact] = []
    
    required init?(coder aDecoder: NSCoder) {
        serviceManager = ServicesManager.sharedInstance()
        contactsManager = serviceManager.contactsManagerService
    
        super.init(coder: aDecoder)
    }
    
    deinit {
        selectedIndex = nil
        selectedIndex2 = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contacts"
        allObjects = []
        for contact in contactsManager.contacts {
            if contact.isInRoster {
                allObjects.append(contact)
            }
        }
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(didAddContact(notification:)), name: NSNotification.Name(kContactsManagerServiceDidAddContact), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateContact(notification:)), name: NSNotification.Name(kContactsManagerServiceDidUpdateContact), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didRemoveContact(notification:)), name: NSNotification.Name(kContactsManagerServiceDidRemoveContact), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(kContactsManagerServiceDidAddContact), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(kContactsManagerServiceDidUpdateContact), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(kContactsManagerServiceDidRemoveContact), object: nil)
    }
    
    func insert(_ contact : Contact) {
        // Ignore myself
        if contact == serviceManager.myUser.contact {
            return
        }
        // Ignore contact not in roster
        if !contact.isInRoster {
            return
        }
        
        if let index = allObjects.index(of: contact) {
            allObjects[index] = contact
        } else {
            allObjects.append(contact)
        }
    }
    
    @objc func didAddContact(notification : Notification) {
        // Enforce that this method is called on the main thread
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                self.didAddContact(notification: notification)
            }
            return
        }
        
        if let contact = notification.object as? Contact {
            self.insert(contact)
            if self.isViewLoaded && populated {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func didUpdateContact(notification : NSNotification) {
        // Enforce that this method is called on the main thread
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                self.didUpdateContact(notification: notification)
            }
            return
        }
        
        if let userInfo = notification.object as? Dictionary<String, Contact> {
            if let contact = userInfo[kContactKey] {
                self.insert(contact)
                if self.isViewLoaded && populated {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func didRemoveContact(notification : NSNotification) {
        // Enforce that this method is called on the main thread
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                self.didRemoveContact(notification: notification)
            }
            return
        }
        if let contact = notification.object as? Contact {
            if let index = allObjects.index(of: contact) {
                self.allObjects.remove(at: index)
            }
            if self.isViewLoaded && populated {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allObjects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath)
        return cell
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let contactCell = cell as? ContactTableViewCell {
            let contact = allObjects[indexPath.row]
            contactCell.name.text = contact.fullName
            if contact.photoData != nil {
                contactCell.avatar.image = UIImage.init(data: contact.photoData)
                contactCell.avatar.tintColor = UIColor.clear
            } else {
                contactCell.avatar.image = UIImage.init(named: "Default_Avatar")
                contactCell.avatar.tintColor = UIColor.init(hue: CGFloat(indexPath.row*36%100)/100.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex2 = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
        print(self.selectedIndex2)
        //performSegue(withIdentifier: "ShowContactDetailSegue", sender: self)
    }
 
    @IBAction func getButtonIndex(_ sender: Any) {
        print("clicked")
        guard let cell = (sender as AnyObject).superview?.superview as? ContactTableViewCell else {
            return // or fatalError() or whatever
        }
        
        self.selectedIndex = self.tableView.indexPath(for: cell)
        print(self.selectedIndex)
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare called **************")
        if  segue.identifier == "ShowContactDetailSegue" {
            print("ShowContactDetailSegue called **************")
            if let selectedIndex = self.selectedIndex {
                print("selectedIndex")
                if let vc = segue.destination as? DetailViewController {
                    print("detailViewContoller")
                    vc.contact = allObjects[selectedIndex.row]
                    print(vc.contact?.firstName)
                
                    if let cell = self.tableView.cellForRow(at: selectedIndex) as? ContactTableViewCell {
                        vc.contactImage = cell.avatar.image!
                        vc.contactImageTint = cell.avatar.tintColor
                    }
                }
            }
        }
        if  segue.identifier == "ShowMessagesFromContactSegue" {
            print("segue invoked**")
            
            if let selectedIndex2 = self.selectedIndex2 {
              // let selectedIndex2 = self.selectedIndex2
            
                print("selectedIndex**")
                if let vc = segue.destination as? ChatViewController {
                    print("vc**")
                    
                    vc.contact = allObjects[selectedIndex2.row]
                        
                    if let cell = self.tableView.cellForRow(at: selectedIndex2) as? ContactTableViewCell {
                            vc.contactImage = (tableView.cellForRow(at: selectedIndex2) as? ContactTableViewCell)?.avatar.image
                            vc.contactImageTint = (tableView.cellForRow(at: selectedIndex2) as? ContactTableViewCell)?.avatar.tintColor
                        
                    }
                
                    }
               }
            }
    }
}

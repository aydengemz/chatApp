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


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
 
    //hi
    //Sandbox
    let appID = "7f7f7310027c11e983d3adfcbc7e45d7"
    let secretKey = "LkgZMcksQzjQXPh5dVNH9dM8dbPMEEvURjN3SHo0ovTy6yEhtmeXpsDZZaDHlHFg"
    
    //Production: App:  rainbow-ibm-watsonassistant-1221
    //let appID = "0693ba70057811e9a57909f9105a07c6"
    //let secretKey = "dUahZy1n0WtjXZep3Sq2uaW0xenW6nYhOUXnmi6M6GWPI5Bz0HYMmslTxDtD6583"
    
    //beta:  openraibow.net
    //let appID = ""
   // let secretKey = ""
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        ServicesManager.sharedInstance().setAppID(appID, secretKey: secretKey)
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        ServicesManager.sharedInstance().loginManager.disconnect()
        ServicesManager.sharedInstance().loginManager.resetAllCredentials()
    }


}


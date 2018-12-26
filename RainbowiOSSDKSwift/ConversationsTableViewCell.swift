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

class ConversationsTableViewCell: UITableViewCell {
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var dateSent: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

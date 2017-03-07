//
//  userTweetCell.swift
//  TweetTweet
//
//  Created by Aarya BC on 3/7/17.
//  Copyright © 2017 Aarya BC. All rights reserved.
//

import UIKit

class userTweetCell: UITableViewCell {

    
    @IBOutlet weak var userTweetTextLabel: UILabel!
    var tweet: Tweet! {
        didSet{
            userTweetTextLabel.text = tweet.text!
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

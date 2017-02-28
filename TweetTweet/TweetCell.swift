//
//  TweetCell.swift
//  TweetTweet
//
//  Created by Aarya BC on 2/26/17.
//  Copyright © 2017 Aarya BC. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    var tweet: Tweet!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var tweetImage: UIImageView!
    @IBOutlet weak var tweetTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        tweetImage.layer.cornerRadius = 5
        tweetImage.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tweetLabel.preferredMaxLayoutWidth = tweetLabel.frame.size.width
    }
}

//
//  TweetUserViewController.swift
//  TweetTweet
//
//  Created by Aarya BC on 3/7/17.
//  Copyright © 2017 Aarya BC. All rights reserved.
//

import UIKit

class TweetUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tweet: Tweet!
    var tweets: [Tweet]!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var headerView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        profilePic.setImageWith(tweet.profileImageURL!)
        if (tweet.headerURL != nil) {
            self.headerView.setImageWith(tweet.headerURL!)
            
        } else {
            print ("no header available")
        }
        userNameLabel.text = tweet.user["name"]! as? String
        handleLabel.text = tweet.user["screen_name"]! as? String
        followerCountLabel.text = "\(tweet.user["followers_count"]!)"
        followingCountLabel.text = "\(tweet.user["friends_count"]!)"
        profilePic.layer.cornerRadius = 5
        profilePic.clipsToBounds = true
        TwitterClient.sharedInstance?.userTimeline((self.tweet.user["screen_name"] as? String)!, success: {(tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userTweetView", for: indexPath) as! UserTweetsTableViewCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
}

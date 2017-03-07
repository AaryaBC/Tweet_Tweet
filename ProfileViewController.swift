//
//  ProfileViewController.swift
//  TweetTweet
//
//  Created by Aarya BC on 3/7/17.
//  Copyright © 2017 Aarya BC. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var followerCount: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var headerPic: UIImageView!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    var tweets: [Tweet]!
    var currUser: User!
    var screenname: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // retrieve user
        
            self.screenname = currUser.screenName!
            self.userNameLabel.text = currUser.name!
        self.followerCount.text = "\(currUser.followers_count!)" + " followers"
            self.followingCount.text = "\(currUser.following_count!)" + " following"
            self.handleLabel.text = "@" + currUser.screenName!
            
            self.profilePic.setImageWith(currUser.profileUrl! as URL)
            if (currUser.headerURL != nil) {
                self.headerPic.setImageWith(currUser.headerURL!)
                
            } else {
                print ("no header available")
            }
            self.tweetCountLabel.text = "\(currUser.tweetCount!)" + " tweets"
        
        
        print(self.screenname!)
        // Get userTimeline
        TwitterClient.sharedInstance?.userTimeline(self.screenname!, success: {(tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        
        // blur header
        addBlurArea(area: headerPic.bounds)
        
        // rounded corner pics
        profilePic.layer.cornerRadius = 5
        profilePic.clipsToBounds = true
        
    }
    
    
    func addBlurArea(area: CGRect) {
        let effect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurView = UIVisualEffectView(effect: effect)
        blurView.frame = CGRect(x: 0, y: 0, width: area.width+40, height: area.height+65)
        
        let container = UIView(frame: area)
        container.alpha = 0.8
        container.addSubview(blurView)
        
        self.view.insertSubview(container, at: 1)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userTweetCell", for: indexPath) as! userTweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }}

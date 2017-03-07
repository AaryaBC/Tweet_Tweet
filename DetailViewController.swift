//
//  DetailViewController.swift
//  TweetTweet
//
//  Created by Aarya BC on 3/7/17.
//  Copyright © 2017 Aarya BC. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var profilepicView: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UIButton!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilepicView.layer.cornerRadius = 5
        profilepicView.clipsToBounds = true
        userNameLabel.setTitle(tweet.user?["name"]! as! String?, for: .normal)
        handleLabel.text = "@" + (tweet.user?["screen_name"]  as! String?)!
        
        tweetTextLabel.text = tweet.text!
        profilepicView.setImageWith(tweet.profileImageURL!)
        if let timestamp = tweet.timeStamp {
            timestampLabel.text = TwitterClient.tweetTimeFormatted(timestamp: timestamp)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tweetIdentifier"{
            let vc = segue.destination as! TweetUserViewController
            vc.tweet = tweet
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        }
    }
}

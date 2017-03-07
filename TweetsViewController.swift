//
//  TweetsViewController.swift
//  TweetTweet
//
//  Created by Aarya BC on 2/26/17.
//  Copyright © 2017 Aarya BC. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var tweets: [Tweet]!
    var tweeterImage: URL?
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 172, blue: 237, alpha: 1.0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            }, failure: { (error: Error) in
                    print(error.localizedDescription)
        })

//         Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        let tweet = self.tweets![indexPath.row]
        cell.userNameLabel.text = tweet.user["name"]! as? String
        cell.tweetLabel.text = tweet.text!
        if let url = tweet.profileImageURL {
            cell.tweetImage.setImageWith(url)
        }
        if let timestamp = tweet.timeStamp {
            cell.tweetTime.text = TwitterClient.tweetTimeFormatted(timestamp: timestamp)
        }
        if (tweet.retweeted)!{
            cell.retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: UIControlState.normal)
        }
        else{
            cell.retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon"), for: UIControlState.normal)
        }
        if (tweet.favorited)!{
            cell.favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: UIControlState.normal)
        }
        else {
            cell.favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: UIControlState.normal)
        }
        cell.favoriteCountLabel.text = "\(tweet.favoritesCount)"
        cell.retweetCountLabel.text = "\(tweet.retweetCount)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        }
        else{
            print("fail")
            return 0;
        }
    }
    
    
    @IBAction func favorite(_ sender: Any){
        let buttonPosition:CGPoint = (sender as AnyObject).convert(CGPoint.zero, to: self.tableView)
        let indexPath = tableView.indexPathForRow(at: buttonPosition)
        let tweet = tweets?[(indexPath?.row)!]
        if (tweet?.favorited!)! {
            TwitterClient.sharedInstance?.unfavorite(tweet: tweet!, success: { (tweet: Tweet) -> () in
                TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]) -> () in
                    self.tweets = tweets
                    self.tableView.reloadData()
                }, failure: { (error: Error) -> () in
                    print(error.localizedDescription)
                })
                print("unfavorited")
            }, failure: { (error: Error) -> () in
                print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance?.favorite(tweet: tweet!, success: { (tweet: Tweet) -> () in
                TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]) -> () in
                    self.tweets = tweets
                    self.tableView.reloadData()
                }, failure: { (error: Error) -> () in
                    print(error.localizedDescription)
                })
                print("favorited")
            }, failure: { (error: Error) -> () in
                print(error.localizedDescription)
            })
        }
    }
    
    
    
    @IBAction func Retweet(_ sender: Any) {
        let buttonPosition:CGPoint = (sender as AnyObject).convert(CGPoint.zero, to: self.tableView)
        let indexPath = tableView.indexPathForRow(at: buttonPosition)
        let tweet = tweets?[(indexPath?.row)!]
        if (tweet?.retweeted!)! {
            TwitterClient.sharedInstance?.unretweet(tweet: tweet!, success: { (tweet: Tweet) -> () in
            TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]) -> () in
                    self.tweets = tweets
                    self.tableView.reloadData()
                }, failure: { (error: Error) -> () in
                    print(error.localizedDescription)
                })
                print("unretweeted")
            }, failure: { (error: Error) -> () in
                print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance?.retweet(tweet: tweet!, success: { (tweet: Tweet) -> () in
            TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]) -> () in
                    self.tweets = tweets
                    self.tableView.reloadData()
                }, failure: { (error: Error) -> () in
                    print(error.localizedDescription)
                })
                print("retweeted")
            }, failure: { (error: Error) -> () in
                print(error.localizedDescription)
            })
        }
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tweetsToDetailSegue" {
            let cell = sender! as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = self.tweets[indexPath!.row]
            
            let detailVC = segue.destination as! DetailViewController
            detailVC.tweet = tweet
            
        }
    }
}

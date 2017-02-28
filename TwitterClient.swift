//
//  TwitterClient.swift
//  TweetTweet
//
//  Created by Aarya BC on 2/25/17.
//  Copyright © 2017 Aarya BC. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com") as URL!, consumerKey: "0BdbaCRpBE3opHiyfXJISxSbY", consumerSecret: "umjcFAwr6566rIkeXJh8hAwkFUSzh17pvTlnFSIdg2Rp2z0oqJ")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()){
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response: Any?) in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
            print ("name: \(user.name!)")
            print("screen: \(user.screenName!)")
            print("profile url: \(user.profileUrl!)")
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print ("Failure")
            failure(error)
        })
    }
    
    func homeTimeLine(success:@escaping ([Tweet]) -> (), failure:@escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func login(success: @escaping ()->(), failure: @escaping (Error) -> ()){
        loginSuccess = success
        loginFailure = failure
        
        deauthorize() //logout -- clears the key chain
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string:"mytwitterdemo://oauth") as URL!, scope: nil, success: { (requestToken:
            BDBOAuth1Credential?) -> Void in
            print ("Token recieved!")
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)") as URL!
            //            UIApplication.shared.openURL(url!)
            UIApplication.shared.open(url!)
            print ("Yaaay!")
        }) { (error: Error?) -> Void in
            print ("error: \(error!.localizedDescription)")
            self.loginFailure?(error!)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
    func handleOpenUrl(url: URL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            print ("Got access token!")
            self.currentAccount(success: {(user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: {(error: Error) -> () in
                self.loginFailure?(error)
            })
            self.loginSuccess?()
        }) {(error: Error?) -> Void in
            print ("error: \(error!.localizedDescription)")
            self.loginFailure?(error!)
        }
    }
    
    static func tweetTimeFormatted(timestamp: Date) -> String {
        
        let interval = timestamp.timeIntervalSinceNow
        
        if interval < 60 * 60 * 24 {
            let seconds = -Int(interval.truncatingRemainder(dividingBy: 60))
            let minutes = -Int((interval / 60).truncatingRemainder(dividingBy: 60))
            let hours = -Int((interval / 3600))
            
            let result = (hours == 0 ? "" : "\(hours)h ") + (minutes == 0 ? "" : "\(minutes)m ") + (seconds == 0 ? "" : "\(seconds)s")
            return result
        } else {
            let formatter: DateFormatter = {
                let f = DateFormatter()
                f.dateFormat = "EEE/MMM/d"
                return f
            }()
            return formatter.string(from: timestamp)
        }
    }
}

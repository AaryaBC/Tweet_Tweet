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
    
    func currentAccount(){
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response: Any?) in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            print ("name: \(user.name!)")
            print("screen: \(user.screenName!)")
            print("profile url: \(user.profileUrl!)")
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print ("Failure")
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
    
    func handleOpenUrl(url: URL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            print ("Got access token!")
            self.loginSuccess?()
//            currentAccount()
//            homeTimeLine(success: { (tweets: [Tweet]) in
//                for tweet in tweets {
//                    print(tweet.text!)
//                }
//            }, failure: { (error: Error) in
//                print(error.localizedDescription)
//            })
        }) {(error: Error?) -> Void in
            print ("error: \(error!.localizedDescription)")
            self.loginFailure?(error!)
        }
    }
}

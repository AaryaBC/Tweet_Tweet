//
//  Tweet.swift
//  TweetTweet
//
//  Created by Aarya BC on 2/25/17.
//  Copyright © 2017 Aarya BC. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text: String?
    var timeStamp : Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var user: NSDictionary!
    var profileImageURL: URL?
    var favorited: Bool?
    var retweeted: Bool?
    var id_str: String?
    var current_user_retweet: Tweet?
    var retweeted_status: Tweet?
    var tweetID: Int
    
    init(dictionary: NSDictionary){
        text = dictionary["text"] as? String
        id_str = dictionary["id_str"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        let timeStampString = dictionary["created_at"] as? String
        if let timeStampString = timeStampString{
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timeStamp = formatter.date(from: timeStampString)
        }
        user = dictionary["user"] as? NSDictionary
        if let profileImageURLString = user?["profile_image_url_https"] as? String,
            let profileImageURL = URL(string: profileImageURLString) {
            self.profileImageURL = profileImageURL
        } else {
            self.profileImageURL = nil
        }
        tweetID = dictionary["id"] as! Int
        self.retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        self.favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        self.favorited = dictionary["favorited"] as? Bool
        self.retweeted = dictionary["retweeted"] as? Bool
        let current_user_retweet_dict = (dictionary["current_user_retweet"] as? NSDictionary)
        if current_user_retweet_dict != nil {
            current_user_retweet = Tweet(dictionary: current_user_retweet_dict!)
        } else {
            current_user_retweet = nil
        }
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        retweeted = dictionary["retweeted"] as? Bool
        let retweeted_status_dict = (dictionary["retweeted_status"] as? NSDictionary) ?? nil
        if retweeted_status_dict != nil {
            retweeted_status = Tweet(dictionary: retweeted_status_dict!)
        } else {
            retweeted_status = nil
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        for dictionary in dictionaries{
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}

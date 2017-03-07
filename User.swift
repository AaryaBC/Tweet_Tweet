//
//  User.swift
//  TweetTweet
//
//  Created by Aarya BC on 2/25/17.
//  Copyright © 2017 Aarya BC. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var screenName: String?
    var profileUrl: NSURL?
    var tagLine: String?
    var dictionary: NSDictionary?
    static let userDidLogoutNotification = "UserDidLogout"
    var followers_count: Int?
    var following_count: Int?
    var tweetCount: Int?
    var headerURL: URL?
    var headerURLString: String?
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        print(screenName!)
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString)
        }
        tagLine = dictionary["description"] as? String
        followers_count = dictionary["followers_count"] as? Int
        following_count = dictionary["friends_count"] as? Int
        tweetCount = dictionary["statuses_count"] as? Int
        headerURLString = dictionary["profile_banner_url"] as? String
        if headerURLString != nil {
            headerURLString?.append("/600x200")
        } else {
            headerURLString = dictionary["profile_background_image_url_https"] as? String
        }
        if let headerURLString = headerURLString {
            headerURL = URL(string: headerURLString)
        }
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
                if let userData = userData{
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user){
            _currentUser = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.setValue(data, forKeyPath: "currentUserData")
            } else {
                defaults.setValue(nil, forKeyPath: "currentUserData")
            }
            defaults.synchronize()
        }
    }
}

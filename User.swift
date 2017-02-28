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
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["name"] as? String
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString)
        }
        tagLine = dictionary["description"] as? String
        
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

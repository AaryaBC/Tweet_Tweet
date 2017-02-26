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
    
    init(dictionary: NSDictionary){
        name = dictionary["name"] as? String
        screenName = dictionary["name"] as? String
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString)
        }
        tagLine = dictionary["description"] as? String
        
    }
}

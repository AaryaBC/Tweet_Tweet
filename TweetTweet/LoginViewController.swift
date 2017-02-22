//
//  LoginViewController.swift
//  TweetTweet
//
//  Created by Aarya BC on 2/21/17.
//  Copyright © 2017 Aarya BC. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onLoginButton(_ sender: Any) {
        let twitterClient = BDBOAuth1SessionManager(baseURL: NSURL(string: "https://api.twitter.com") as URL!, consumerKey: "0BdbaCRpBE3opHiyfXJISxSbY", consumerSecret: "umjcFAwr6566rIkeXJh8hAwkFUSzh17pvTlnFSIdg2Rp2z0oqJ")
        
        twitterClient?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string: "mytwitterdemo://oauth") as URL!, scope: nil, success: {
            (requestToken: BDBOAuth1Credential?) -> Void in
            let url = NSURL(string:"https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")
            UIApplication.shared.open(url as! URL, options: [:], completionHandler: nil)
            print ("Works")
        }, failure: { (error: Error?) -> Void in
            print ("Error \(error!.localizedDescription)")
        })
    }
}

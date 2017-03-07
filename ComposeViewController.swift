//
//  ComposeViewController.swift
//  TweetTweet
//
//  Created by Aarya BC on 3/7/17.
//  Copyright © 2017 Aarya BC. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate  {
    var tweets: User!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.delegate = self
        tweetTextView.becomeFirstResponder()
        nameLabel.text = tweets.name as String?
        nameLabel.sizeToFit()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onSaveButton(_ sender: Any) {
        if let text = self.tweetTextView.text {
            TwitterClient.sharedInstance?.sendTweet(text: text, callBack: { (tweet, error) in
                DispatchQueue.main.async {
                    self.view.endEditing(true)
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    @IBAction func onCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }

}

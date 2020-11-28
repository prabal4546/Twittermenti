//
//  ViewController.swift
//  Twittermenti
//
//  Created by Prabaljit Walia 

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class ViewController: UIViewController {
    
    let tweetCount = 100
   
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let sentimentClassifier = TweetSentimentClassifier()
    
    let swifter = Swifter(consumerKey: "PCEvMKpR1hEEqzU3nL5r0M2kh", consumerSecret:"IFpvi8UNlCBUqvF3pU5xa0rjometLVgwrlZE5cR4a7XzdN3uty")


    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        }
        
//        let prediction = try! sentimentClassifier.prediction(text: "@Apple is a flawless company")
//
//        print(prediction.label)
        
        
        
        
        
       
        
    

    @IBAction func predictPressed(_ sender: Any) {
        
        fetchTweets()
    
    }
    
    func fetchTweets(){
        if let searchText = textField.text{
                      swifter.searchTweet(using: searchText,lang:"en",count: tweetCount,tweetMode: .extended, success: { (results, metadata) in
                                 
                        var tweets = [TweetSentimentClassifierInput]()
                                 
                        for i in 0..<self.tweetCount{
                                 
                                 if let tweet = results[i]["full_text"].string{
                                     let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                                    tweets.append(tweetForClassification)
                                     }
                                 }
                        self.makePrediction(with: tweets)
                                 
                                 
                                 
                               
                             }) { (error) in
                                 print("an error with Twitter API Request.\(error)")
                             }
                      
        
        
            }
    }
    func makePrediction(with tweets: [TweetSentimentClassifierInput]){
        
        do{
            let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
            //print(predictions[0].label)
            var sentimentsScore = 0
            
            for pred in predictions{
                if pred.label == "Pos"{
                    sentimentsScore += 1
                }
                else if pred.label == "Neg"{
                    sentimentsScore -= 1
                    }
                }
            updateUI(with: sentimentsScore)
        
            }
        catch{
            print("their was an error making the prediction,\(error)")
        }
    }
    func updateUI(with sentimentsScore: Int){
        if sentimentsScore > 20{
                    self.sentimentLabel.text = "😍"
                }
                else if sentimentsScore > 10{
                    self.sentimentLabel.text = "😀"
                }
                else if sentimentsScore > 0{
                    self.sentimentLabel.text = "🙂"
                }
                else if sentimentsScore == 0{
                    self.sentimentLabel.text = "😐"
                }
                else if sentimentsScore > -10{
                    self.sentimentLabel.text = "😕"
                }
                else{
                    self.sentimentLabel.text = "🤮"
                }
    }

}

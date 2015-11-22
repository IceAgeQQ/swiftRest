//
//  ViewController.swift
//  swiftRest
//
//  Created by Chao Xu on 15/11/21.
//  Copyright © 2015年 Chao Xu. All rights reserved.
// this is chao

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ipLabel:UILabel!
    @IBOutlet weak var postResultLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateIP()
        postDataToURL()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: -REST calls
        // This makes the get call to httpbin.org.It simple gets the Ip address and display it on the screen
    
    func updateIP(){
        //SETUP THE SESSION TO MAKE REST CALL.NOTICE THE RUL IS HTTPS NOT HTTP
        let postEndpoint: String = "https://httpbin.org/ip"
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: postEndpoint)!
        
        //Make the post call and handle it in a completion handler
        session.dataTaskWithURL(url,completionHandler: {(data:NSData?,response:NSURLResponse?,error:NSError?)->
            Void in
            //make sure we get the OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else{
                    print("Not a 200 response")
                    return
            }
            //Read the JSON
            do{
                if let ipString = NSString(data: data!, encoding: NSUTF8StringEncoding){
                    //print what we got from the call
                    print(ipString)
                    //Parse the JSON to get the IP
                    let jsonDictionary =  try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    let origin  = jsonDictionary["origin"] as! String
                    //update the label
                    self.performSelectorOnMainThread("updateIPLabel:", withObject: origin, waitUntilDone: false)
                }
            }catch{
                print("bad things")
            }
        }).resume()
    }
    func postDataToURL(){
        //Setup the session to make rest post call
        let postEndpoint: String = "http://requestb.in/13q4iyr1"
        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession.sharedSession()
        let postParams : [String: AnyObject] = ["hello": "Hello POST world by CHAOX"]
        
        // Create the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
            print(postParams)
        } catch {
            print("bad things happened")
        }
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    print("Not a 200 response")
                    return
            }
            
            // Read the JSON
            if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                // Print what we got from the call
                print("POST: " + postString)
                self.performSelectorOnMainThread("updatePostLabel:", withObject: postString, waitUntilDone: false)
            }
            
        }).resume()
    }
    //MARK: - Methods to update the UI immediately
    func updateIPLabel(text:String){
        self.ipLabel.text = "Your IP is" + text
    }
    
    func updatePostLabel(text:String){
        self.postResultLabel.text = "Post :" + text
        print("hello world")
    }
}


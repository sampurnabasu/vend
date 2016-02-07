//
//  StartViewController.swift
//  Smart Vendor
//
//  Created by Sagar Punhani on 1/31/16.
//  Copyright © 2016 Sagar Punhani. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Firebase
import Parse

class Candy {
    var image: UIImage
    var title: String
    var price: Float
    static let cornerRadius: CGFloat = 25
    static var chosen = false
    static var personImage: UIImage?
    init(image: UIImage, title: String, price: Float) {
        self.image = image
        self.title = title
        self.price = price
    }
    
    static func changeImage(url: String) {
        let url = NSURL(string: url)
        
        let data = NSData(contentsOfURL: url!)
        
        Candy.personImage = UIImage(data: data!)
    }
    
    static var user: PFObject?
    
    static var globalPlayer: AVAudioPlayer? // Global variable

    
    
}



class StartViewController: UIViewController {
    
    
    let candy1 = Candy(image: UIImage(named: "oreos")!, title: "Oreos", price : 3.75)
    let candy2 = Candy(image: UIImage(named: "skittles")!, title: "Skittles", price: 2.75)
    let candy3 = Candy(image: UIImage(named: "peanuts")!, title: "Peanuts", price: 2.75)
    let candy4 = Candy(image: UIImage(named: "nutrigrain")!, title: "Nutri-Grain", price: 1.25)
    
    var candyMap = [String:Candy]()
    
    @IBOutlet weak var playerView: UIView!
    
    var player: AVPlayer?
    
    // Create a reference to a Firebase location
    var ref = Firebase(url:"https://project-vend.firebaseio.com")
    
    var scview: SCLAlertViewResponder?

    @IBOutlet weak var buyButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //candies
        candyMap["Oreos"] = candy1
        candyMap["Skittles"] = candy2
        candyMap["Peanuts"] = candy3
        candyMap["Nutri-Grain"] = candy4
        
        
        self.view.layer.borderWidth = 5.0
        self.view.layer.masksToBounds = true
        self.view.layer.borderColor = UIColor.orangeColor().CGColor
        buyButton.layer.cornerRadius =  Candy.cornerRadius
        

        ref.observeEventType(.ChildChanged, withBlock: { snapshot in
            if snapshot.key == "picture"  {
                print(snapshot.value)
                print(Candy.chosen)
                if snapshot.value as! Int == 1 && Candy.chosen == false {
                    self.ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
                        let query = PFQuery(className:"Person")
                        print("firebase")
                        print(snapshot.childSnapshotForPath("currentUser").value)
                        query.whereKey("name", equalTo: snapshot.childSnapshotForPath("currentUser").value)
                        query.findObjectsInBackgroundWithBlock {
                            (objects: [PFObject]?, error: NSError?) -> Void in
                            
                            if error == nil {
                                // The find succeeded.
                                self.player!.pause()
                                self.scview?.close()
                                let object = objects!.first
                                Candy.user = object
                                self.performSegueWithIdentifier("buy", sender: object!["candy"])
                                self.ref.childByAppendingPath("picture").setValue(0)
                                let qualityOfServiceClass = QOS_CLASS_BACKGROUND
                                let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
                                dispatch_async(backgroundQueue, {
                                    self.gettingImage()
                                })
                            }
                        }
                        
                        

                    })
                    
                }
                self.ref.childByAppendingPath("picture").setValue(0)


            }
        })
        
        /*let candy = PFObject(className: "Candy")
        candy["name"] = "Oreos"
        candy["maleCount"] = Int(arc4random_uniform(15))
        candy["femaleCount"] = Int(arc4random_uniform(12))
        var array1 = [Int]()
        for var i = 0; i < 4; i++ {
            array1.append(Int(arc4random_uniform(12) + 1))
        }
        candy["ageCount"] = array1
        var array = [Int]()
        for var i = 0; i < 24; i++ {
            array.append(Int(arc4random_uniform(12) + 1))
        }
        candy["timeCount"] = array
        
        candy.saveInBackground()
        
        let candy2 = PFObject(className: "Candy")
        candy2["name"] = "Oreos"
        candy2["maleCount"] = Int(arc4random_uniform(15))
        candy2["femaleCount"] = Int(arc4random_uniform(12))
        array1 = [Int]()
        for var i = 0; i < 4; i++ {
            array1.append(Int(arc4random_uniform(12) + 1))
        }
        candy2["ageCount"] = array1
        array = [Int]()
        for var i = 0; i < 24; i++ {
            array.append(Int(arc4random_uniform(12) + 1))
        }
        candy2["timeCount"] = array
        
        candy2.saveInBackground()
        
        let candy3 = PFObject(className: "Candy")
        candy3["name"] = "Oreos"
        candy3["maleCount"] = Int(arc4random_uniform(15))
        candy3["femaleCount"] = Int(arc4random_uniform(12))
        array1 = [Int]()
        for var i = 0; i < 4; i++ {
            array1.append(Int(arc4random_uniform(12) + 1))
        }
        candy3["ageCount"] = array1
        array = [Int]()
        for var i = 0; i < 24; i++ {
            array.append(Int(arc4random_uniform(12) + 1))
        }
        candy3["timeCount"] = array
        
        candy3.saveInBackground()
        
        
        let candy4 = PFObject(className: "Candy")
        candy4["name"] = "Oreos"
        candy4["maleCount"] = Int(arc4random_uniform(15))
        candy4["femaleCount"] = Int(arc4random_uniform(12))
        array1 = [Int]()
        for var i = 0; i < 4; i++ {
            array1.append(Int(arc4random_uniform(12) + 1))
        }
        candy4["ageCount"] = array1
        array = [Int]()
        for var i = 0; i < 24; i++ {
            array.append(Int(arc4random_uniform(12) + 1))
        }
        candy4["timeCount"] = array
        
        candy4.saveInBackground()
        */
        

        // Do any additional setup after loading the view.
    }
    
    func gettingImage() {
        Candy.changeImage("https://nerflock.blob.core.windows.net/picture/ben.jpg")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private var firstAppear = true
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if firstAppear {
            playVideo()
            firstAppear = false
            
        }
    }
    
    private func playVideo() {
        let path = NSBundle.mainBundle().pathForResource("Video", ofType:"mp4")
        player = AVPlayer(URL: NSURL(fileURLWithPath: path!))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = playerView.frame
        self.view.layer.addSublayer(playerLayer)
        player!.play()
    }
    
    
    @IBAction func buyAction(sender: AnyObject) {
        let alertView = SCLAlertView()
        alertView.showCloseButton = false
        
        scview = alertView.showWait("Taking Your Picture", subTitle: "Please wait")
        
        ref.childByAppendingPath("touch").setValue(1)
        
        let seconds = 11.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.scview?.close()
            // here code perfomed with delay
            
        })
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "buy" {
            let candy = candyMap[sender as! String]
            if let ivc = segue.destinationViewController as? ItemViewController {
                ivc.recCandy = candy

            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //player?.pause()
    }
    

}

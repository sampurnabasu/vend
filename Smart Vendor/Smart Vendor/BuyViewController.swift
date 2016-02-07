//
//  BuyViewController.swift
//  Smart Vendor
//
//  Created by Sagar Punhani on 2/2/16.
//  Copyright © 2016 Sagar Punhani. All rights reserved.
//

import UIKit
import Firebase
import Parse

class BuyViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var buyButton: UIButton!
    
    @IBOutlet weak var cancel: UIButton!
    
    var candy: Candy?
    
    var ref = Firebase(url:"https://project-vend.firebaseio.com")

    override func viewDidLoad() {
        super.viewDidLoad()
        image.image = candy?.image
        titleLabel.text = candy?.title
        priceLabel.text = "$\(candy!.price)"
        cancel.layer.cornerRadius = Candy.cornerRadius
        buyButton.layer.cornerRadius = Candy.cornerRadius
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func buyCandy(sender: UIButton) {
        Candy.globalPlayer?.pause()
        self.performSegueWithIdentifier("purchase", sender: self)
        
        ref.childByAppendingPath(candy!.title).setValue(1)
        ref.childByAppendingPath("name").setValue(candy!.title)
        let query = PFQuery(className:"Candy")
        query.whereKey("name", equalTo:(candy?.title)!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                if let object = objects?.first {
                    
                    PFQuery(className: "Person").getObjectInBackgroundWithId((Candy.user?.objectId)!, block: { (user, error) -> Void in
                        if error == nil {
                            print(user?["gender"])
                            if (user!["gender"] as! String) == "male" {
                                object["maleCount"] = (object["maleCount"] as! NSNumber).integerValue + 1
                            } else {
                                object["femaleCount"] = (object["maleCount"] as! NSNumber).integerValue + 1
                                
                            }
                            let age = (user!["age"] as! NSNumber).doubleValue
                            var array = object["ageCount"] as! [Int]
                            if age < 15 {
                                array[0] = array[0] + 1
                            }
                            else if age < 20 {
                                array[1] = array[1] + 1
                            }
                            else if age < 25 {
                                array[2] = array[2] + 1
                            }
                            else {
                                array[3] = array[3] + 1
                            }
                            object["ageCount"] = array
                            var newarray = object["timeCount"] as! [Int]
                            let date = NSDate()
                            let calendar = NSCalendar.currentCalendar()
                            let components = calendar.components([.Hour, .Minute], fromDate: date)
                            let hour = components.hour
                            var index = hour - 8
                            if index < 0 {
                                index += 24
                            }
                            newarray[index] = newarray[index] + 1
                            object["timeCount"] = newarray
                            object.saveInBackground()
                            
                            
                        }

                    })
                    
                    
                }
                
            }
        }

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

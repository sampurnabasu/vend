//
//  DoneViewController.swift
//  Smart Vendor
//
//  Created by Sagar Punhani on 2/6/16.
//  Copyright © 2016 Sagar Punhani. All rights reserved.
//

import UIKit
import Parse
import AVFoundation


class DoneViewController: UIViewController {
    
    
    @IBOutlet weak var image: UIImageView!

    @IBOutlet weak var conShoppingButton: UIButton!
    
    @IBOutlet weak var doneButton: UIButton!
    
    var audioPlayer: AVAudioPlayer! // Global variable

    
    override func viewDidLoad() {
        super.viewDidLoad()
        conShoppingButton.layer.cornerRadius = Candy.cornerRadius
        doneButton.layer.cornerRadius = Candy.cornerRadius
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        image.image = Candy.personImage
        
        do {
            audioPlayer =  try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Happy", ofType: "m4a")!))
            audioPlayer.play()
            
        } catch {
            print("Error")
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.audioPlayer.pause()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func continueShopping(sender: UIButton) {
        
    }
    
    
    @IBAction func doneShopping(sender: UIButton) {
        Candy.chosen = false
        Candy.personImage = nil
        Candy.user = nil

    }
    
    func changeImage(url: String) {
        let url = NSURL(string: url)
        
        let data = NSData(contentsOfURL: url!)
        
        image.image = UIImage(data: data!)
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

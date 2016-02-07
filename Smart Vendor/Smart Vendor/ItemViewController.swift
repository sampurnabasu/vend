//
//  ItemViewController.swift
//  Smart Vendor
//
//  Created by Sagar Punhani on 2/2/16.
//  Copyright © 2016 Sagar Punhani. All rights reserved.
//

import UIKit
import Parse
import Firebase
import AVFoundation

class ItemViewController: UIViewController, CustomIOS8AlertViewDelegate {
    
    @IBOutlet weak var button1: UIButton!
    
    @IBOutlet weak var button2: UIButton!
    
    @IBOutlet weak var button3: UIButton!
    
    @IBOutlet weak var button4: UIButton!
    
    let alertView = CustomIOS8AlertView()
    
    var recCandy: Candy?
    
    var allCandies = [Candy]()
    
    let candy1 = Candy(image: UIImage(named: "oreos")!, title: "Oreos", price : 3.75)
    let candy2 = Candy(image: UIImage(named: "skittles")!, title: "Skittles", price: 2.75)
    let candy3 = Candy(image: UIImage(named: "peanuts")!, title: "Peanuts", price: 2.75)
    let candy4 = Candy(image: UIImage(named: "nutrigrain")!, title: "Nutri-Grain", price: 1.25)
    
    var ref = Firebase(url:"https://project-vend.firebaseio.com")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add candies
        allCandies.append(candy1)
        allCandies.append(candy2)
        allCandies.append(candy3)
        allCandies.append(candy4)
        
        if recCandy == nil {
            recCandy = allCandies[0]
        }
        
        button1.tag = 0
        button2.tag = 1
        button3.tag = 2
        button4.tag = 3
        
        
        button1.layer.borderWidth = 2.0
        button1.layer.borderColor = UIColor.orangeColor().CGColor
        button2.layer.borderWidth = 2.0
        button2.layer.borderColor = UIColor.orangeColor().CGColor
        button3.layer.borderWidth = 2.0
        button3.layer.borderColor = UIColor.orangeColor().CGColor
        button4.layer.borderWidth = 2.0
        button4.layer.borderColor = UIColor.orangeColor().CGColor

        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        do {
            Candy.globalPlayer =  try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("final", ofType: "m4a")!))
            Candy.globalPlayer!.play()
            
        } catch {
            print("Error")
        }
        if Candy.chosen == false {
            self.showRecommededProduct()
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buyItem(sender: UIButton) {
        let candy = allCandies[sender.tag]
        performSegueWithIdentifier("candy", sender: candy)
        

    }
    
    // Handle button touches
    func customIOS8AlertViewButtonTouchUpInside(alertView: CustomIOS8AlertView, buttonIndex: Int) {
        alertView.close()
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "candy" {
            let candy = sender as! Candy
            if let ivc = segue.destinationViewController as? BuyViewController {
                ivc.candy = candy
            }
        }
    }
    
    func showRecommededProduct() {
        //recommeneded product
        
        Candy.chosen = true
        alertView.delegate = self
        
        let width = self.view.bounds.width * 0.5
        
        let view = UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: width,height: 400)))
        let label = UILabel(frame: CGRect(origin: CGPointZero, size: CGSize(width: width, height: 50)))
        label.text = "Recommended Product: \(recCandy!.title)"
        label.textAlignment = .Center
        label.font = UIFont(name: "Copperplate", size: 20)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 50), size: CGSize(width: width, height: 300)))
        imageView.image = recCandy!.image
        let buyButton = UIButton()
        buyButton.frame = CGRect(origin: CGPoint(x: 0, y: 350), size: CGSize(width: width, height: 50))
        buyButton.setTitle("Buy", forState: .Normal)
        buyButton.backgroundColor = UIColor.orangeColor()
        buyButton.addTarget(self, action: "buy", forControlEvents: .TouchUpInside)
        
        view.addSubview(label)
        view.addSubview(imageView)
        view.addSubview(buyButton)
        
        alertView.containerView = view
        alertView.show { (bool) -> Void in
            
        }
        self.ref.childByAppendingPath("picture").setValue(0)

    }
    
    func buy() {
        alertView.close()
        performSegueWithIdentifier("candy", sender: recCandy)
    }
    

}



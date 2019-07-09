//
//  ViewController.swift
//  DiceRollerApp
//
//  Created by Erick Soto on 7/9/19.
//  Copyright © 2019 Erick Soto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var randomDiceIndex1: Int = 0
    var randomDiceIndex2: Int = 0
    
    // this is the controller for the two dice images
    @IBOutlet weak var diceImageView1: UIImageView!
    @IBOutlet weak var diceImageView2: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // this is the controller for the roll button
    @IBAction func rollButtonPressed(_ sender: UIButton) {
        // this will create random numbers from 0 and 5
        randomDiceIndex1 = Int.random(in: 0 ... 5)
        randomDiceIndex2 = Int.random(in: 0 ... 5)
    }
    
}


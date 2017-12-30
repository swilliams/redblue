//
//  EndViewController.swift
//  RedBlue
//
//  Created by Scott Williams on 12/30/17.
//  Copyright © 2017 Scott Williams. All rights reserved.
//

import UIKit

class EndViewController: UIViewController {
    @IBOutlet weak var winLabel: UILabel!
    var winText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        winLabel.text = winText
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

}

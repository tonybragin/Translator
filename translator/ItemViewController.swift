//
//  ItemViewController.swift
//  translator
//
//  Created by TONY on 21/05/2019.
//  Copyright © 2019 TONY. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {

    @IBOutlet weak var langFromLabel: UILabel!
    @IBOutlet weak var langToLabel: UILabel!
    
    
    @IBOutlet weak var inputedText: UITextView!
    @IBOutlet weak var translatedText: UITextView!
    
    var item: Translator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        langFromLabel.text = item.source
        langToLabel.text = item.target
        inputedText.text = item.inputedText
        translatedText.text = item.translatedText
        
    }

}

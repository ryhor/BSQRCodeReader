//
//  ViewController.swift
//  BSQRCodeReader
//
//  Created by Bobby Stenly on 04/12/2016.
//  Copyright (c) 2016 Bobby Stenly. All rights reserved.
//

import UIKit
import BSQRCodeReader

class ViewController: UIViewController, BSQRCodeReaderDelegate {

    @IBOutlet weak var reader: BSQRCodeReader!
    @IBOutlet weak var lblResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.reader.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.reader.startScanning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: BSQRCodeReaderDelegate 
    func didFailWithError(_ error: NSError) {
        
    }
    func beforeStartScanning(_ reader: BSQRCodeReader){
        
    }
    func afterStopScanning(_ reader: BSQRCodeReader){
        
    }
    func didCaptureQRCodeWithContent(_ content: String) -> Bool {
        self.lblResult.text = content
        return true
    }
}


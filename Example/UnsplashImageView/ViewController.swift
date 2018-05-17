//
//  ViewController.swift
//  UnsplashImageView
//
//  Created by adboco@telefonica.net on 05/15/2018.
//  Copyright (c) 2018 adboco@telefonica.net. All rights reserved.
//

import UIKit
import UnsplashImageView

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var modeControl: UISegmentedControl!
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var intervalSlider: UISlider!
    @IBOutlet weak var transitionControl: UISegmentedControl!
    @IBOutlet weak var transitionDurationLabel: UILabel!
    @IBOutlet weak var transitionSlider: UISlider!
    @IBOutlet weak var termsField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UnsplashConfig.default.query = .random(featured: false)
        UnsplashConfig.default.size = CGSize(width: 600, height: 600)
        UnsplashConfig.default.terms = ["fruit", "vegan"]
        UnsplashConfig.default.mode = .gallery(interval: 10.0, transition: .fade(0.5))
        
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.unsplash.start()
        
        imageView.unsplash.willTransition = { image, url in
            print("Unsplash.WillTransition: \(url?.absoluteString ?? "")")
        }
        
        imageView.unsplash.didTransition = { image, url in
            print("Unsplash.DidTransition: \(url?.absoluteString ?? "")")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func reload() {
        switch modeControl.selectedSegmentIndex {
        case 1:
            let interval = Double(intervalSlider.value)
            UnsplashConfig.default.mode = .gallery(interval: interval, transition: transitionStyle())
        default:
            UnsplashConfig.default.mode = .single(transition: transitionStyle())
        }
        
        let text = termsField.text
        let terms = text?.components(separatedBy: ",").compactMap({ $0.replacingOccurrences(of: " ", with: "") })
        UnsplashConfig.default.terms = terms
        
        imageView.unsplash.start()
    }
    
    func transitionStyle() -> UnsplashTransition {
        let duration = Double(transitionSlider.value)
        switch transitionControl.selectedSegmentIndex {
        case 1: return .fade(duration)
        case 2: return .flipFromLeft(duration)
        case 3: return .flipFromRight(duration)
        default:
            return .none
        }
    }

    @IBAction func modeDidChange(_ sender: Any) {
        let control = sender as! UISegmentedControl
        switch control.selectedSegmentIndex {
        case 0:
            intervalSlider.isEnabled = false
            intervalLabel.isEnabled = false
        default:
            intervalSlider.isEnabled = true
            intervalLabel.isEnabled = true
        }
        reload()
    }
    
    @IBAction func intervalDidChange(_ sender: Any) {
        let slider = sender as! UISlider
        intervalLabel.text = String(format: "%.1f", slider.value)
        reload()
    }
    
    @IBAction func transitionDidChange(_ sender: Any) {
        let control = sender as! UISegmentedControl
        switch control.selectedSegmentIndex {
        case 0:
            transitionSlider.isEnabled = false
            transitionDurationLabel.isEnabled = false
        default:
            transitionSlider.isEnabled = true
            transitionDurationLabel.isEnabled = true
        }
        reload()
    }
    
    @IBAction func transitionDurationDidChange(_ sender: Any) {
        let slider = sender as! UISlider
        transitionDurationLabel.text = String(format: "%.1f", slider.value)
        reload()
    }
    
    @IBAction func searchTerms(_ sender: Any) {
        termsField.resignFirstResponder()
        reload()
    }
    
}


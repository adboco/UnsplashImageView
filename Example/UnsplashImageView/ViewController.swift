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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UnsplashConfig.default.query = .random(featured: false)
        UnsplashConfig.default.size = CGSize(width: 1000, height: 1000)
        UnsplashConfig.default.terms = ["fruit", "vegan"]
        UnsplashConfig.default.mode = .gallery(interval: 10.0, transition: .fade(0.5))
        
        let imageView: UIImageView = {
            let imageView = UIImageView(frame: view.frame)
            imageView.contentMode = .scaleAspectFill
            return imageView
        }()
        
        view.addSubview(imageView)
        imageView.unsplash.setImage()
        
        imageView.unsplash.willTransition = { image, url in
            print("Unsplash.WillTransition: \(url?.absoluteString ?? "")")
        }
        
        imageView.unsplash.didTransition = { image, url in
            print("Unsplash.DidTransition: \(url?.absoluteString ?? "")")
        }
    }

}


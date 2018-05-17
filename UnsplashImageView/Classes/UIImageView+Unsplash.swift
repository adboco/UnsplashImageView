//
//  UIImageView+Unsplash.swift
//  FBSnapshotTestCase
//
//  Created by Adrián Bouza Correa on 15/05/2018.
//

import UIKit
import Repeat

public typealias UnsplashTransitionClosure = (UIImage?, URL?) -> Void

public extension UIImageView {
    
    fileprivate struct AssociatedKeys {
        static var willTransition = "unsplashWillTransition"
        static var didTransition = "unsplashDidTransition"
        
        static var timer = "unsplashTimer"
    }
    
    // MARK: - Transition closures
    
    /// Closure called when the UIImageView will change its image
    internal var unsplash_willTransition: UnsplashTransitionClosure? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.willTransition) as? UnsplashTransitionClosure }
        set { objc_setAssociatedObject(self, &AssociatedKeys.willTransition, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    /// Closure called when the UIImageView finishes to change its image
    internal var unsplash_didTransition: UnsplashTransitionClosure? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.didTransition) as? UnsplashTransitionClosure }
        set { objc_setAssociatedObject(self, &AssociatedKeys.didTransition, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    // MARK: - Timer
    
    internal var unsplash_timer: Repeater? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.timer) as? Repeater }
        set { objc_setAssociatedObject(self, &AssociatedKeys.timer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
}

extension UIImageView: UnsplashCompatible { }

// MARK: Unsplash for UIImageView

public extension Unsplash where Base: UIImageView {
    
    public var willTransition: UnsplashTransitionClosure? {
        get { return base.unsplash_willTransition }
        set { base.unsplash_willTransition = newValue }
    }
    
    public var didTransition: UnsplashTransitionClosure? {
        get { return base.unsplash_didTransition }
        set { base.unsplash_didTransition = newValue }
    }
    
    internal var timer: Repeater? {
        get { return base.unsplash_timer }
        set { base.unsplash_timer = newValue }
    }
    
    // MARK: - Start loading images with UnsplashConfig
    
    /// Start loading images from Unsplash
    ///
    /// - Parameter config: Unsplash configuration
    public func start(with config: UnsplashConfig = UnsplashConfig.default) {
        stop()
        
        let url = config.buildURL()
        switch config.mode {
        case .single(transition: let transition):
            UnsplashDownloader.downloadImage(with: url) { image in
                self.transition(transition, to: image, url: url)
            }
        case .gallery(interval: let interval, transition: let transition):
            UnsplashDownloader.downloadImage(with: url) { image in
                self.transition(transition, to: image, url: url)
            }
            
            self.timer = Repeater(interval: .seconds(interval), mode: .infinite) { _ in
                self.timer?.pause()
                UnsplashDownloader.downloadImage(with: config.buildURL()) { image in
                    self.transition(transition, to: image, url: url)
                    self.timer?.start()
                }
            }
            self.timer?.start()
        }
    }
    
    /// Stop loading images
    public func stop() {
        self.timer?.pause()
        self.timer = nil
    }
    
    // MARK: - Transitions
    
    /// Makes transitions between images
    ///
    /// - Parameters:
    ///   - type: Type of transition
    ///   - image: Final image
    ///   - url: Final image url
    internal func transition(_ type: UnsplashTransition, to image: UIImage?, url: URL?) {
        willTransition?(image, url)
        
        let completionBlock: (Bool) -> Void = { finished in
            guard finished else {
                return
            }
            self.didTransition?(image, url)
        }
        
        switch type {
        case .none:
            self.base.image = image
            completionBlock(true)
        case .fade(let duration):
            UIView.transition(with: self.base, duration: duration, options: .transitionCrossDissolve, animations: {
                self.base.image = image
            }, completion: completionBlock)
        case .flipFromTop(let duration):
            UIView.transition(with: self.base, duration: duration, options: .transitionFlipFromTop, animations: {
                self.base.image = image
            }, completion: completionBlock)
        case .flipFromBottom(let duration):
            UIView.transition(with: self.base, duration: duration, options: .transitionFlipFromBottom, animations: {
                self.base.image = image
            }, completion: completionBlock)
        case .flipFromLeft(let duration):
            UIView.transition(with: self.base, duration: duration, options: .transitionFlipFromLeft, animations: {
                self.base.image = image
            }, completion: completionBlock)
        case .flipFromRight(let duration):
            UIView.transition(with: self.base, duration: duration, options: .transitionFlipFromRight, animations: {
                self.base.image = image
            }, completion: completionBlock)
        case .curlUp(let duration):
            UIView.transition(with: self.base, duration: duration, options: .transitionCurlUp, animations: {
                self.base.image = image
            }, completion: completionBlock)
        case .curlDown(let duration):
            UIView.transition(with: self.base, duration: duration, options: .transitionCurlDown, animations: {
                self.base.image = image
            }, completion: completionBlock)
        }
    }
    
}

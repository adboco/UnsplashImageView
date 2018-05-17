//
//  UnsplashConfig.swift
//  FBSnapshotTestCase
//
//  Created by Adrián Bouza Correa on 15/05/2018.
//

import UIKit

internal var unsplashBaseURL = "https://source.unsplash.com"

/// Unsplash Source Query
///
/// - photo: Single photo by id
/// - random: Random photo
/// - randomFromUser: Random photo from user
/// - randomFromUserLikes: Random photo from user's likes
/// - randomFromCollection: Random photo from collection
public enum UnsplashQuery {
    
    case photo(id: String)
    case random(featured: Bool)
    case randomFromUser(username: String)
    case randomFromUserLikes(username: String)
    case randomFromCollection(id: String)
    
    internal var isSingle: Bool {
        switch self {
        case .photo(id: _): return true
        default: return false
        }
    }
    
    internal func build() -> String {
        switch self {
        case .photo(id: let photoId):
            return unsplashBaseURL + "/" + photoId
        case .random(featured: let featured):
            return unsplashBaseURL + (featured ? "/featured" : "/random")
        case .randomFromUser(username: let username):
            return unsplashBaseURL + "/user/" + username
        case .randomFromUserLikes(username: let username):
            return unsplashBaseURL + "/user/" + username + "/likes"
        case .randomFromCollection(id: let collectionId):
            return unsplashBaseURL + "/collection/" + collectionId
        }
    }
    
}

/// Unsplash Update type. This indicates the update frequency for a specific request
///
/// - none: It always gets a new photo
/// - daily: It gets a new photo daily
/// - weekly: It gets a new photo weekly
public enum UnsplashUpdateType {
    
    case none
    case daily
    case weekly
    
    func build() -> String? {
        switch self {
        case .none:
            return nil
        case .daily:
            return "/daily"
        case .weekly:
            return "/weekly"
        }
    }
    
    internal var isSingle: Bool {
        switch self {
        case .none: return false
        default: return true
        }
    }
    
}

/// Different types of transition between images
///
/// - none: No transition
/// - fade: Fade
/// - flipFromTop: Flip from top
/// - flipFromBottom: Flip from bottom
/// - flipFromLeft: Flip from left
/// - flipFromRight: Flip from right
/// - curlUp: Curl up
/// - curlDown: Curl down
public enum UnsplashTransition {
    
    case none
    case fade(Double)
    case flipFromTop(Double)
    case flipFromBottom(Double)
    case flipFromLeft(Double)
    case flipFromRight(Double)
    case curlUp(Double)
    case curlDown(Double)
    
}

/// Transition configuration
public enum UnsplashMode {
    
    case single(transition: UnsplashTransition)
    case gallery(interval: TimeInterval, transition: UnsplashTransition)
    
    internal var isSingle: Bool {
        switch self {
        case .single(transition: _): return true
        default: return false
        }
    }
    
    internal var transition: UnsplashTransition {
        switch self {
        case .single(transition: let transition): return transition
        case .gallery(interval: _, transition: let transition): return transition
        }
    }
    
}

/// Unsplash configuration
public struct UnsplashConfig {
    
    public init() {}
    
    /// Singleton for default configuration
    public static var `default`: UnsplashConfig = UnsplashConfig()
    
    /// Mode
    public var mode: UnsplashMode = .single(transition: .none) {
        didSet { preventUnvalidConfig() }
    }
    
    /// Query
    public var query: UnsplashQuery = .random(featured: false) {
        didSet { preventUnvalidConfig() }
    }
    
    /// Desired size of images
    public var size: CGSize?
    
    /// Search terms
    public var terms: [String]?
    
    /// Update behaviour
    public var fixed: UnsplashUpdateType = .none {
        didSet { preventUnvalidConfig() }
    }
    
    internal mutating func preventUnvalidConfig() {
        // Avoid unvalid configs. Example: gallery mode with daily photo or photo(id: String) query
        switch (mode.isSingle, query.isSingle, fixed.isSingle){
        case (false, true, _), (false, _, true):
            mode = .single(transition: mode.transition)
        default:
            break
        }
    }
    
    internal func buildURL() -> URL? {
        var query = self.query.build()
        
        if let imageSize = size {
            let width = Int(imageSize.width)
            let height = Int(imageSize.height)
            query += "/\(width)x\(height)"
        }
        
        if let updateQuery = fixed.build() {
            query += updateQuery
        }
        
        if let searchTerms = terms, !searchTerms.isEmpty {
            let listOfTerms = searchTerms.joined(separator: ",")
            query += "/?" + listOfTerms
        }
        
        return URL(string: query)
    }
    
}

public class Unsplash<Base> {
    
    public let base: Base
    
    init(_ base: Base) {
        self.base = base
    }
    
}

public protocol UnsplashCompatible {
    
    associatedtype CompatibleType
    var unsplash: Unsplash<CompatibleType> { get set }
    
}

public extension UnsplashCompatible {
    
    public var unsplash: Unsplash<Self> {
        get { return Unsplash(self) }
        set { }
    }
    
}

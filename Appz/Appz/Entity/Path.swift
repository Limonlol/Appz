//
//  Path.swift
//  Appz
//
//  Created by Mazyad Alabduljaleel on 12/13/15.
//  Copyright © 2015 kitz. All rights reserved.
//

import Foundation


public struct Path {
    
    public var pathComponents = [String]()
    public var queryParameters = [String:String]()
    public var needDoubleSlash: Bool = true
    
    public var queryItems: [URLQueryItem] {
        return queryParameters
            .map { URLQueryItem(name: $0, value: $1) }
    }
    
    public init() {}
    
    public init(pathComponents: [String], queryParameters: [String:String], needDoubleSlash: Bool = true) {
        
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
        self.needDoubleSlash = needDoubleSlash
    }
    
    /**
     This method will take the base URL and append components to it.
     
     - Parameter baseURL:  The base URL.
     
     */
    public func appendToURL(_ baseURL: String) -> URL? {
        
        guard let url = URL(string: baseURL) else {
            return nil
        }
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = queryItems.isEmpty ? nil : queryItems
        
        var pathComponents = self.pathComponents
        
        if let firstPath = pathComponents.first, urlComponents?.host == nil {
            urlComponents?.host = firstPath
            pathComponents = Array(pathComponents.dropFirst())
        }
        
        if !pathComponents.isEmpty {
            urlComponents?.path = "/" + pathComponents.joined(separator: "/")
        }
        
        if !needDoubleSlash {
            let stringReplace = urlComponents?.path.replacingOccurrences(of: "//", with: "") ?? ""
            urlComponents?.path = stringReplace
        }
        return urlComponents?.url
    }
}


extension Path: Equatable {}

public func ==(lhs: Path, rhs: Path) -> Bool {
    return (
        lhs.pathComponents == rhs.pathComponents
        && lhs.queryParameters == rhs.queryParameters
    )
}

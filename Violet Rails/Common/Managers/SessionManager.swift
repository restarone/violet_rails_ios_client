//
//  SessionManager.swift
//  Violet Rails
//
//  Created by Joses Solmaximo on 08/05/23.
//

import Foundation

struct SessionManager {
    enum Keys {
        static let selectedURL = "selectedURL"
        static let baseURLs = "baseURLs"
        static let cookies = "cookies"
    }
    
    static func setSelectedURL(url: URL) {
        UserDefaults.standard.set(url, forKey: Keys.selectedURL)
    }
    
    static func getSelectedURL() -> URL? {
        return UserDefaults.standard.url(forKey: Keys.selectedURL)
    }
    
    static func setBaseURLs(urls: [URL]) {
        UserDefaults.standard.set(urls.map(\.absoluteString), forKey: Keys.baseURLs)
    }
    
    static func getBaseURLs() -> [URL]? {
        guard let stringURLs = UserDefaults.standard.array(forKey: Keys.baseURLs) as? [String] else {
            return nil
        }
        
        return stringURLs.compactMap({ URL(string: $0) })
    }
    
    static func setCookies(url: URL, cookies: [HTTPCookie]){
        
    }
}
